<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use DB;

class purchase extends payment
{

	//this function gets the initial pre-requisite data for adding purchase.
	function getData_add_purchase(Request $req)
	{

		//this will get all the supplier list for the autocomplete
		$people = DB::table('people')->where('type', '=', 'Supplier')->get();

		//get the product list for autocomplete
		$products = DB::table('products as p')
			->select(
				DB::raw('concat( p.product_name , " brand: " , b.brand_name ) as product_name'),
				DB::raw('concat( "Received" ) as status'),
				DB::raw('CAST( p.selling_price as char(10) ) as selling_price'),
				DB::raw('CAST( p.purchase_cost as char(10)) as unit_price '),
				DB::raw('CAST( p.selling_quantity as char(10)) as quantity'),

				'p.warranty_days',
				'p.having_serial',
				'p.p_id',

			)
			->join('brand as b', 'b.brand_id', '=', 'p.brand_id')
			->get();


		//get all the serial for duplication serial verification
		$serial = DB::table('serial_number')
			->select('invoice_number_purchase', 'product_id', 'serial_number', 'status')
			->get();


		//get warehouse list for autocomplete
		$warehouse = DB::table('warehouse')->get();

		//send the invoice number , maximum number will be sent
		$invoice_number =
			DB::table('purchase_or_sell')
			->select(DB::raw('max(invoice_number)+1 as c'))
			->get();


		//counter of item sold or remaining
		$count_purchase_or_sell =
			DB::table('count_purchase_or_sell')
			->get();



		//marge and send the data
		$arrayData['supplier'] = $people;
		$arrayData['serial'] = $serial;
		$arrayData['warehouse'] = $warehouse;
		$arrayData['products'] = $products;
		$arrayData['invoice_number'] = $invoice_number[0]->c;
		$arrayData['count_purchase_or_sell'] = $count_purchase_or_sell;


		return $arrayData;
	}




	//this function is used for finally sending data to database, both for add/edit purchase
	function add_purchase(Request $req)
	{
		//delete all the existing data using the invoice number. this is specially needed for updating data
		DB::table('purchase_or_sell')
			->where('invoice_number', $req->invoice_number)
			->delete();

		DB::table('sell_or_purchase_details')
			->where([
				['invoice_number', '=', $req->invoice_number]
			])
			->delete();


		DB::table('serial_number')
			->where('invoice_number_purchase', $req->invoice_number)
			->delete();


		//step_1
		//insert to purchase_or_sell , this is the purchase info purpose
		DB::table('purchase_or_sell')
			->insert($req->purchase_or_sell);

		//step_2
		//insert to sell_or_purchase_details , for example product_id , quantity
		foreach ($req->sell_or_purchase_details as $key => $value) {

			DB::table('sell_or_purchase_details')
				->insert(
					(array) $value
				);
		}

		//step_3
		//insert to serial_number table
		foreach ($req->serial_number as $key => $value) {

			DB::table('serial_number')
				->insert(
					(array) $value
				);
		}
		// return 'ok';

		//call add_payment f
		parent::add_payment_general($req);
	}




	//this function is used for finally sending data to database, both for add/edit purchase
	function update_purchase(Request $req)
	{

		//delete all the existing data using the invoice number. this is specially needed for updating data
		DB::table('purchase_or_sell')
			->where('invoice_number', $req->invoice_number)
			->delete();

		DB::table('sell_or_purchase_details')
			->where('invoice_number', $req->invoice_number)
			->delete();

		// delete serial
		//delete all the existing data using the invoice number. this is specially needed for updating data
		DB::table('serial_number')
			->where(
				[
					[
						'invoice_number_purchase', $req->invoice_number
					],
					[
						'status', 'Purchase'
					]
				]
			)
			->delete();

		//step_1
		//insert to purchase_or_sell , this is the purchase info purpose
		DB::table('purchase_or_sell')
			->insert($req->purchase_or_sell);

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
				->updateOrInsert(
					['serial_number' =>  $value['serial_number']],
					(array) $value
				);
		}

		parent::UpdateTransactions($req);
	}

	// this is used for showing purchase list, initial page
	function purchase_list(Request $req)
	{
		$isPaid =
			DB::table('amount_paid')
			->where(
				'paying_or_receiving',
				'Paying'
			)
			->count();

		if ($isPaid > 0) {
			$purchase_list = DB::table('people as p')
				->select(
					'p.full_name',
					's.invoice_number',
					's.supplier_id',
					's.status',
					's.date',
					's.correction_status',
					's.discount',
					't.total',
					'ap.paid_or_received as amount_paid',
					't.total as balance',
					//concating date and time from two different field as we did not take the time input from the form
					DB::raw("concat( date(s.date), ' ' , time(s.timestamp)  ) as date"),

				)
				->where([
					['s.status', 'Received'],
					['paying_or_receiving', 'Paying'],
					])
				->join('purchase_or_sell as s', 'p.people_id', '=', 's.supplier_id')
				->join('total_amount as t', 's.invoice_number', '=', 't.invoice_number')
				->join('amount_paid as ap', 's.invoice_number', '=', 'ap.invoice_number')
				->get();
		} else {
			$purchase_list = DB::table('people as p')
				->select(
					'p.full_name',
					's.invoice_number',
					's.supplier_id',
					's.status',
					's.date',
					's.correction_status',
					's.discount',
					't.total',
					DB::raw('concat( 0 ) as amount_paid'),
					't.total as balance',
					//concating date and time from two different field as we did not take the time input from the form
					DB::raw("concat( date(s.date), ' ' , time(s.timestamp)  ) as date"),

				)
				->where('s.status', 'Received')
				->join('purchase_or_sell as s', 'p.people_id', '=', 's.supplier_id')
				->join('total_amount as t', 's.invoice_number', '=', 't.invoice_number')
				->get();
		}
		// return $isPaid;

		$total_amount = DB::table('total_amount')->get();

		$amount_paid =
			DB::table('transactions')
			->select('invoice_number', DB::raw('sum(total_amount) as total_paid'))
			->where('paying_or_receiving', 'Receiving')
			->groupBy('invoice_number')
			->get();



		$purchaseData['purchase_list'] = $purchase_list;
		$purchaseData['total_amount'] = $total_amount;
		$purchaseData['amount_paid'] = $amount_paid;

		return $purchaseData;
	}

	//inital funciton, this function is used for editing a purchase... this function will send the existing data according to the invoice number so that old data can be read and update if needed.
	function edit_purchase(Request $req)
	{
		//this will get all the supplier list for the autocomplete
		$supplier = DB::table('people')->where('type', '=', 'Supplier')->get();

		//get the product list for autocomplete
		$products = DB::table('products as p')
			->select(
				DB::raw('concat( p.product_name , " brand: " , b.brand_name ) as product_name'),
				DB::raw('concat( "Received" ) as status'),
				DB::raw('CAST( p.selling_price as char(10) ) as selling_price'),
				DB::raw('CAST( p.purchase_cost as char(10)) as unit_price '),
				DB::raw('CAST( p.selling_quantity as char(10)) as quantity'),

				'p.warranty_days',
				'p.having_serial',
				'p.p_id',

			)
			->join('brand as b', 'b.brand_id', '=', 'p.brand_id')
			->get();

		//get all the serial for duplication serial verification
		$serial = DB::table('serial_number')
			->select('invoice_number_purchase', 'invoice_number_sell', 'product_id', 'serial_number', 'status')
			->get();

		//get warehouse list for autocomplete
		$warehouse = DB::table('warehouse')->get();

		$serial_cart = DB::table('serial_number')
			->where('invoice_number_purchase', '=', $req->invoice_number)
			->select('invoice_number_purchase', 'product_id', 'serial_number', 'status')
			->get();


		//this will send the existing purchase info 
		$purchase_info =
			DB::table('purchase_or_sell as sp')
				->where('sp.invoice_number', '=',  $req->invoice_number)
				->join('warehouse as w', 'w.id', '=', 'sp.warehouse_id')
				->join('people as s', 's.people_id', '=', 'sp.supplier_id')
				->select('sp.*', 's.full_name as supplier_name', 'w.name as warehouse_name')
				->get()[0];


		//this is the product cart
		$product_cart =
			DB::table('sell_or_purchase_details as sp')
			->join('products as p', 'p.p_id', '=', 'sp.product_id')
			->join('brand as b', 'b.brand_id', '=', 'p.brand_id')
			->where('invoice_number', '=', $req->invoice_number)
			->select(
				DB::raw('concat( p.product_name , " brand: " ,b.brand_name ) as product_name'),
				'sp.product_id as p_id',


				DB::raw('CAST( p.selling_price as char(10) ) as selling_price'),
				DB::raw('CAST( sp.unit_price as char(10)) as unit_price '),
				DB::raw('CAST( sp.quantity as char(10)) as quantity'),
				'p.having_serial',
				'sp.status'

			)
			->get();


		//counter of item sold or remaining
		$count_purchase_or_sell =
			DB::table('count_purchase_or_sell')
			->get();


		//mergin the data for sending to vue
		$arrayData['supplier'] = $supplier;
		$arrayData['products'] = $products;
		$arrayData['serial'] = $serial;
		$arrayData['warehouse'] = $warehouse;
		$arrayData['count_purchase_or_sell'] = $count_purchase_or_sell;
		$arrayData['serial_cart'] = $serial_cart;
		$arrayData['purchase_info'] = $purchase_info;
		$arrayData['product_cart'] = $product_cart;

		return $arrayData;
	}

	//this funciton will delete the invoice number of purchase if the criteria of condition is full-filled
	function delete_invoice_purchase(Request $req)
	{

		$isAnyProductSold =
			DB::table('serial_number')
				->where([
					['invoice_number_purchase', '=',  $req->invoice_number],
					['status', '=',  'Sold'],
				])
				->select(DB::raw('count(*) as c'))
				->get()[0]->c;

		//if any product is sold then the invoice can not be deleted
		if ($isAnyProductSold > 0) return 'some_prouducts_already_sold';

		//delete all the existing data using the invoice number. 
		DB::table('purchase_or_sell')
			->where('invoice_number', $req->invoice_number)
			->delete();

		DB::table('sell_or_purchase_details')
			->where('invoice_number', $req->invoice_number)
			->delete();

		DB::table('serial_number')
			->where('invoice_number_purchase', $req->invoice_number)
			->delete();

		//delete all transactions related to this sell
		DB::table('transactions')
			->where('invoice_number', $req->invoice_number)
			->delete();

		return 'invoice_deleted_successfully';
	}
}
