<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use DB;

class purchase extends Controller
{

	//this function gets the initial pre-requisite data for adding purchase.
	function getData_add_purchase(Request $req){

		//this will get all the supplier list for the autocomplete
		$people = DB::table('people')->where('type' , '=' , 'Supplier')->get();
		
		//get the product list for autocomplete
		$products = DB::table('products as p')
		->select(
			DB::raw('concat( p.product_name , " brand: " , b.brand_name ) as product_name'),
			DB::raw('concat( "Received" ) as status'),
			DB::raw('CAST( p.selling_price as char(10) ) as selling_price'),
			DB::raw('CAST( p.purchase_cost as char(10)) as purchase_cost '),
			DB::raw('CAST( p.selling_quantity as char(10)) as selling_quantity'),
		
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
		$arrayData['supplier'] = $people; 
		$arrayData['serial'] = $serial; 
		$arrayData['warehouse'] = $warehouse; 
		$arrayData['products'] = $products; 
		$arrayData['invoice_number'] = $invoice_number[0]->c;


		return $arrayData;
	}




	//this function is used for finally sending data to database
	function add_purchase(Request $req){

		//delete all the existing data using the invoice number. this is specially needed for updating data
		DB::table('purchase_or_sell')
		->where('invoice_number' , $req->invoice_number)
		->delete();

		DB::table('sell_or_purchase_details')
		->where('invoice_number' , $req->invoice_number)
		->delete();

		DB::table('serial_number')
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
		//insert to serial_number table
		foreach ($req->serial_number as $key => $value) {

			DB::table('serial_number')
            ->insert(
                (array) $value
            );
		}

	}


	// this is used for showing purchase list, initial page
	function purchase_list(Request $req){


		$purchase_list = DB::table('people as p')
		->select(
			'p.full_name',
			's.*'
		)
		->join('purchase_or_sell as s', 'p.people_id' , '=' , 's.supplier_id')
		->get();


		$purchaseData['purchase_list'] = $purchase_list;

		return $purchaseData;

	}

	// this function is used for editing a purchase... this function will send the existing data according to the invoice number so that old data can be read and update if needed.
	function edit_purchase(Request $req){


		//this will get all the supplier list for the autocomplete
		$supplier = DB::table('people')->where('type' , '=' , 'Supplier')->get();

		

		//get the product list for autocomplete
		$products = DB::table('products as p')
		->select(
			DB::raw('concat( p.product_name , " brand: " , b.brand_name ) as product_name'),
			DB::raw('concat( "Received" ) as status'),
			DB::raw('CAST( p.selling_price as char(10) ) as selling_price'),
			DB::raw('CAST( p.purchase_cost as char(10)) as purchase_cost '),
			DB::raw('CAST( p.selling_quantity as char(10)) as selling_quantity'),
		
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


		$serial_cart = DB::table('serial_number')
		->where('invoice_number', '=', $req->invoice_number)
		->select('invoice_number', 'product_id', 'serial_number', 'status' )
		->get();


		//this will send the existing purchase info 
		$purchase_info = 
		DB::table('purchase_or_sell as sp')
		->where('sp.invoice_number', '=' ,  $req->invoice_number)
		->join('warehouse as w' , 'w.id' , '=' , 'sp.warehouse_id')
		->join('people as s' , 's.people_id' , '=' , 'sp.supplier_id')
		->select('sp.*', 's.full_name as supplier_name', 'w.name as warehouse_name')
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
			

			DB::raw('CAST( p.selling_price as char(10) ) as selling_price'),
			DB::raw('CAST( p.purchase_cost as char(10)) as purchase_cost '),
			DB::raw('CAST( p.selling_quantity as char(10)) as selling_quantity'),
			


			'p.having_serial',
			'sp.status'

		)
		->get();



		//mergin the data for sending to vue
		$arrayData['supplier'] = $supplier; 
		$arrayData['products'] = $products; 
		$arrayData['serial'] = $serial; 
		$arrayData['warehouse'] = $warehouse; 


		$arrayData['serial_cart'] = $serial_cart; 
		$arrayData['purchase_info'] = $purchase_info; 
		$arrayData['product_cart'] = $product_cart; 


		return $arrayData;
	}

}
