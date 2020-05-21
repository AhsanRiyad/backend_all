<?php

namespace App\Http\Traits;

use DB;
use App\Transactions;
use App;


//a trait built by me for having common methods here
trait PaymentTrait
{

	function invoice_trait($invoice_number)
	{


		// return $invoice_number;

		// $invoice_number = 10001;

		$isPurchaseOrSell =
			DB::table('purchase_or_sell')
				->select('status')
				->where('invoice_number', $invoice_number)
				->get()[0]->status;

		$ext = '';
		$customerOrSupplier = '';

		if($isPurchaseOrSell == 'Received'){
			$ext = 'purchase';
			$customerOrSupplier = 'supplier_id';
			
		}else{
			$ext = 'sell';
			$customerOrSupplier = 'customer_id';
		}

		//serial list for serial cart of individual product
		$serial_cart = DB::table('serial_number')
			->where('invoice_number_'.$ext, '=', $invoice_number)
			->select('invoice_number_purchase', 'invoice_number_'.$ext,  'product_id', 'serial_number', 'status')
			->get();


		// return $serial_cart;

		//this will send the existing sells/purchase info 
		$sells_info =
			DB::table('purchase_or_sell as sp')
				->where('sp.invoice_number', '=',  $invoice_number)
				->join('warehouse as w', 'w.id', '=', 'sp.warehouse_id')
				->join('people as s', 's.people_id', '=', 'sp.'. $customerOrSupplier)
				->select('sp.*', 's.full_name as customer_name', 'w.name as warehouse_name', 's.mobile', 's.address')
				->get();


		// dd( $sells_info );

		//this is the product cart
		$product_cart =
			DB::table('sell_or_purchase_details as sp')
			->join('products as p', 'p.p_id', '=', 'sp.product_id')
			->join('brand as b', 'b.brand_id', '=', 'p.brand_id')
			->where('invoice_number', '=', $invoice_number)
			->select(
				DB::raw('concat( p.product_name , " brand: " ,b.brand_name ) as product_name'),
				'sp.product_id as p_id',
				DB::raw('CAST( sp.unit_price as char(10) ) as unit_price'),
				DB::raw('CAST( p.purchase_cost as char(10)) as purchase_cost '),
				DB::raw('CAST( sp.quantity as char(10)) as quantity'),
				'p.having_serial',
				'sp.status',
				'p.product_code'
			)
			->get();


		//mergin the data for sending to vue
		$arrayData['serial_cart'] = $serial_cart;
		$arrayData['sells_info'] = $sells_info[0];
		$arrayData['product_cart'] = $product_cart;

		return $arrayData;
	}
}
