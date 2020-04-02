<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use DB;

class sell extends Controller
{
	
	//this function gets the initial pre-requisite data for adding purchase.
	function getData_add_sell(Request $req){

		//this will get all the supplier list for the autocomplete
		$customer = DB::table('people')->where('type' , '=' , 'Customer')->get();
		
		//get the product list for autocomplete
		$products = DB::table('products as p')
		->select(
			DB::raw('concat( p.product_name , " brand: " , b.brand_name ) as product_name'),
			DB::raw('concat( "Received" ) as status'),
			DB::raw('CAST( p.selling_price as char(10) ) as selling_price'),
			DB::raw('CAST( p.selling_price as char(10)) as selling_price '),
			DB::raw('CAST( p.selling_quantity as char(10)) as selling_quantity'),
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


	function add_sell(Request $req){

		return $req;

		//delete all the existing data using the invoice number. this is specially needed for updating data
		DB::table('purchase_or_sell')
		->where('invoice_number' , $req->invoice_number)
		->delete();

		DB::table('sell_or_purchase_details')
		->where('invoice_number' , $req->invoice_number)
		->delete();

		DB::table('serial_number')
		->where('invoice_number_sell' , $req->invoice_number)
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
		//insert to serial_number table
		foreach ($req->serial_number as $key => $value) {

			DB::table('serial_number')
			->insert(
				(array) $value
			);
		}


	}

}
