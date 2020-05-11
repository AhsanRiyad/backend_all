<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use DB;

class sell extends payment
{
	
	//this function gets the initial pre-requisite data for adding purchase.
	function getData_add_sell(Request $req){

		//this will get all the supplier list for the autocomplete
		$customer = 
		DB::table('people')
		->where('type' , '=' , 'Customer')
		->get();
		
		//get the product list for autocomplete
		$products = DB::table('products as p')
		->select(
			DB::raw('concat( p.product_name , " brand: " , b.brand_name ) as product_name'),
			DB::raw('concat( "Sold" ) as status'),
			DB::raw('CAST( p.selling_price as char(10) ) as unit_price'),
			DB::raw('CAST( p.selling_price as char(10)) as selling_price '),
			DB::raw('CAST( p.selling_quantity as char(10)) as quantity'),
			'p.product_code',
			'p.warranty_days',
			'p.having_serial',
			'p.p_id',

		)
		->join('brand as b', 'b.brand_id' , '=' , 'p.brand_id')
		->get();


		//get all the serial for duplication serial verification
		$serial = DB::table('serial_number')
		->select('invoice_number_purchase', 'invoice_number_sell' , 'product_id', 'serial_number', 'status' )
		->get();


		//get warehouse list for autocomplete
		$warehouse = DB::table('warehouse')->get();
		
		//send the invoice number , maximum number will be sent
		$invoice_number = 
		DB::table('purchase_or_sell')
		->select(DB::raw('max(invoice_number)+1 as c'))
		->get();


		//marge and send the data
		$arrayData['customer'] = $customer; 
		$arrayData['serial'] = $serial; 
		$arrayData['warehouse'] = $warehouse; 
		$arrayData['products'] = $products; 
		$arrayData['invoice_number'] = $invoice_number[0]->c;


		return $arrayData;

	}    




	//this function is used for finally sending data to database, both for add/edit purchase
	function add_sell(Request $req){

		//delete all the existing data using the invoice number. this is specially needed for updating data
		DB::table('purchase_or_sell')
		->where('invoice_number' , $req->invoice_number)
		->delete();

		DB::table('sell_or_purchase_details')
		->where('invoice_number' , $req->invoice_number)
		->delete();


		//step_1
		//insert to purchase_or_sell , this is the purchase info purpose
		DB::table('purchase_or_sell')
		->insert( $req->purchase_or_sell );

		//step_2
		//insert to sell_or_purchase_details , for example product_id , quantity
		foreach ($req->sell_or_purchase_details as $key => $value) {

			DB::table('sell_or_purchase_details')
			->insert(
				(array) $value
			);
		}

		//step_3
		//update the serial number
		foreach ($req->serial_number as $key => $value) {			
			DB::table('serial_number')
			->where('serial_number',  $value['serial_number'] )
			->update((array) $value);

		}

		
		//add transaction
		parent::add_payment_general($req);

	}


	//sends the required list for sells_list component, path /sells_list
	function sells_list(){

		$sells_list = DB::table('people as p')
		->select(
			'p.full_name',
			's.invoice_number',
			's.customer_id',
			's.status',
			's.correction_status',
			's.discount',
			DB::raw("concat( date(s.date), ' ' , time(s.timestamp)  ) as date"),

		)
		->where('status' , 'Sold')
		->join('purchase_or_sell as s', 'p.people_id' , '=' , 's.customer_id')
		->get();


		/*$total_amount = 
		DB::table('sell_or_purchase_details as s')
		->select(DB::raw('sum( s.quantity * s.unit_price )-(sum( s.quantity * s.unit_price )*p.discount/100) as total'), 's.invoice_number', 'p.discount')
		->join('purchase_or_sell as p' , 'p.invoice_number' , '=' , 's.invoice_number') 
		->where('s.status', '=', 'Sold')
		->groupBy('s.invoice_number', 'p.discount')
		->get();
*/

		$total_amount = DB::table('total_amount')->get();
		$amount_paid= 
		DB::table('transactions')
		->select('invoice_number' , DB::raw('sum(total_amount) as total_paid'))
		->where('paying_or_receiving', 'Receiving')
		->groupBy('invoice_number')
		->get();


		$sellsData['sells_list'] = $sells_list;
		$sellsData['total_amount'] = $total_amount;
		$sellsData['amount_paid'] = $amount_paid;


		return $sellsData;
	}







	// this function is used for editing a sell... this function will send the existing data according to the invoice number so that old data can be read and update if needed.
	function edit_sell(Request $req){

		// $req->invoice_number = 10001;

		//this will get all the supplier list for the autocomplete
		$customer = DB::table('people')->where('type' , '=' , 'Customer')->get();


		//get the product list for autocomplete
		$products = DB::table('products as p')
		->select(
			DB::raw('concat( p.product_name , " brand: " , b.brand_name ) as product_name'),
			DB::raw('concat( "Sold" ) as status'),
			DB::raw('CAST( p.selling_price as char(10) ) as unit_price'),
			DB::raw('CAST( p.purchase_cost as char(10)) as purchase_cost '),
			DB::raw('CAST( p.selling_quantity as char(10)) as quantity'),

			'p.warranty_days',
			'p.having_serial',
			'p.p_id',

		)
		->join('brand as b', 'b.brand_id' , '=' , 'p.brand_id')
		->get();



		//get all the serial for duplication serial verification
		$serial = DB::table('serial_number')
		->select('invoice_number_purchase', 'invoice_number_sell', 'product_id', 'serial_number', 'status' )
		->get();


		//get warehouse list for autocomplete
		$warehouse = DB::table('warehouse')->get();


		//
		$serial_cart = DB::table('serial_number')
		->where('invoice_number_sell', '=', $req->invoice_number)
		->select('invoice_number_purchase', 'invoice_number_sell',  'product_id', 'serial_number', 'status' )
		->get();


		//this will send the existing purchase info 
		$sells_info = 
		DB::table('purchase_or_sell as sp')
		->where('sp.invoice_number', '=' ,  $req->invoice_number)
		->join('warehouse as w' , 'w.id' , '=' , 'sp.warehouse_id')
		->join('people as s' , 's.people_id' , '=' , 'sp.customer_id')
		->select('sp.*', 's.full_name as customer_name', 'w.name as warehouse_name')
		->get()[0];


		//this is the product cart
		$product_cart = 
		DB::table('sell_or_purchase_details as sp')
		->join('products as p' , 'p.p_id' , '=' , 'sp.product_id')
		->join('brand as b', 'b.brand_id' , '=' , 'p.brand_id')
		->where('invoice_number', '=', $req->invoice_number )
		->select(
			DB::raw('concat( p.product_name , " brand: " ,b.brand_name ) as product_name'),
			'sp.product_id as p_id', 

			DB::raw('CAST( sp.unit_price as char(10) ) as unit_price'),
			DB::raw('CAST( p.purchase_cost as char(10)) as purchase_cost '),
			DB::raw('CAST( sp.quantity as char(10)) as quantity'),

			'p.having_serial',
			'sp.status'

		)
		->get();

		
		//mergin the data for sending to vue
		$arrayData['customer'] = $customer; 
		$arrayData['products'] = $products; 
		$arrayData['serial'] = $serial; 
		$arrayData['warehouse'] = $warehouse; 
		

		$arrayData['serial_cart'] = $serial_cart; 
		$arrayData['sells_info'] = $sells_info; 
		$arrayData['product_cart'] = $product_cart; 

		return $arrayData;
	}

	function delete_invoice_sell(Request $req){

		//delete all the existing data using the invoice number. this is specially needed for updating data
		DB::table('purchase_or_sell')
		->where('invoice_number' , $req->invoice_number)
		->delete();


		//delete all transactions related to this sell
		DB::table('transactions')
		->where('invoice_number' , $req->invoice_number)
		->delete();

		DB::table('sell_or_purchase_details')
		->where('invoice_number' , $req->invoice_number)
		->delete();
		//step_3
		//update the serial number
		DB::table('serial_number')
		->where( 'invoice_number_sell', $req->invoice_number  )
		->update( [ 'invoice_number_sell' => '' ,
			'status' => 'Purchase'
		]);

		return $req;
	}
	
	
}
