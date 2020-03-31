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
		->select('invoice_number', 'product_id', 'serial_number', 'status' )
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

}
