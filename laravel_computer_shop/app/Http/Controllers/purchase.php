<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use DB;

class purchase extends Controller
{
	function get_supplier(Request $req){

		$people = DB::table('people')->where('type' , '=' , 'Supplier')->get();
		
		// $products = DB::table('products')->get();

		// $products = DB::select(" select concat( p.product_name , ' brand: ' ,b.brand_name) as product_name , p.selling_price , p.purchase_cost , p.selling_quantity , p.warranty_days , p.p_id as p_id, p.brand_id from products p , brand b where p.brand_id = b.brand_id ");

		$products = DB::table('products as p')
		->select(
			DB::raw('concat( p.product_name , " brand: " ,b.brand_name ) as product_name'),
			DB::raw('concat( "Received" ) as status'),
			'p.selling_price' ,
			'p.purchase_cost' ,
			'p.selling_quantity' ,
			'p.warranty_days',
			'p.having_serial',
			'p.p_id',

		)
		->join('brand as b', 'b.brand_id' , '=' , 'p.brand_id')
		->get();

		$serial = DB::table('serial_number')->get();
		$warehouse = DB::table('warehouse')->get();
		
		$arrayData['people'] = $people; 
		$arrayData['products'] = $products; 
		$arrayData['serial'] = $serial; 
		$arrayData['warehouse'] = $warehouse; 
		// $arrayData['products_test'] = $products_test; 

		return $arrayData;
	}

	//add_purchase
	function add_purchase(Request $req){


		//invoice nubmer generation
		$invoice_number;
		if($req->invoice_number != 0){

		$invoice_number = 
		DB::table('purchase_or_sell')
		->max('invoice_number');

		if($invoice_number == ''){

			$invoice_number = 100000;

		}else{

			$invoice_number += 1; 
		}




		//adding serial


		$i = 0;
		for($i = 0 ; $i < count($req->purchase_data['serial']); $i++ ){




			if( in_array( $req->purchase_data['serial'][$i]['p_id']  ,  $req->purchase_data['product_id_returned'] ) ){

				$req->purchase_data['serial'][$i]['status'] = 'Returned';


			}else{

				$req->purchase_data['serial'][$i]['status'] = 'Purchase';
			}





			DB::table('serial_number')->insert(
				[
					'invoice_number' => $invoice_number, 
					'product_id' => $req->purchase_data['serial'][$i]['p_id'],
					'serial_number' => $req->purchase_data['serial'][$i]['serial_number'],
					'status' => $req->purchase_data['serial'][$i]['status'],
				]
			);
		}



		DB::table('purchase_or_sell')->insert(
			[
				'invoice_number' => $invoice_number,
				'date' => $req->purchase_data['date'] ,
				'reference_number' => $req->purchase_data['reference_number'],
				'warehouse_id' => $req->purchase_data['warehouse_id'],
				'supplier_id' => $req->purchase_data['supplier_id'],
				'status' => $req->purchase_data['status'],
				'type' => 'purchase' ,
				'correction_status' => $req->purchase_data['correction_status'] ,
			]

		);


		$status = DB::update(
			'UPDATE 
			`purchase_or_sell` 
			SET 
			`insert_time_date`= sysdate()
			WHERE
			invoice_number = (?)' , 
			[
				$invoice_number
			]
		);




		$i = 0;
		for($i = 0 ; $i < count($req->purchase_data['products']); $i++ ){


			DB::table('sell_or_purchase_details')->insert(
				[
					'invoice_number' => $invoice_number, 
					'product_id' => $req->purchase_data['products'][$i]['p_id'],
					'quantity' => $req->purchase_data['products'][$i]['selling_quantity'],
					'unit_price' => $req->purchase_data['products'][$i]['purchase_cost'],
				]
			);





		}




		// return $req->purchase_data['date'];
		return $req;
		// return $req->purchase_data['products'][0];
		// return $req->purchase_data['products'][0]['product_name'];
		// return $invoice_number;
	}


	// purchase_list
	function purchase_list(Request $req){
		


		$purchase_list = DB::select("
			
			select 
			s.* , p.full_name 
			from 
			people p, purchase_or_sell s 
			where 
			p.people_id = s.supplier_id 

			");

		$purchaseData['purchase_list'] = $purchase_list;


		return $purchaseData;



	}

	// purchase_list
	function edit_purchase(Request $req){
		
		
		$people = DB::table('people')->where('type' , '=' , 'Supplier')->get();
		
		// $products = DB::table('products')->get();

	

		$products = DB::table('products as p')
		->select(
			DB::raw('concat( p.product_name , " brand: " ,b.brand_name ) as product_name'),
			DB::raw('concat( "Received" ) as status'),
			'p.selling_price' ,
			'p.purchase_cost' ,
			'p.selling_quantity' ,
			'p.warranty_days',
			'p.having_serial',
			'p.p_id',

		)
		->join('brand as b', 'b.brand_id' , '=' , 'p.brand_id')
		->get();




		$serial = DB::table('serial_number')->get();
		$warehouse = DB::table('warehouse')->get();
		
		$arrayData['people'] = $people; 
		$arrayData['products'] = $products; 
		$arrayData['serial'] = $serial; 
		$arrayData['warehouse'] = $warehouse; 

		$serial_cart = DB::table('serial_number')
		->where('invoice_number', '=', $req->invoice_number)
		->select('product_id as p_id' , 'serial_number' , 'status')
		->get();

		$purchase_info = 
		DB::table('purchase_or_sell as sp')
		->join('warehouse as w' , 'w.id' , '=' , 'sp.warehouse_id')
		->join('people as s' , 's.people_id' , '=' , 'sp.supplier_id')
		->where('invoice_number', '=', $req->invoice_number)
		->select('sp.*', 's.full_name as supplier_name', 'w.name as warehouse_name')
		->get();

		$product_cart = 
		DB::table('sell_or_purchase_details as sp')
		->join('products as p' , 'p.p_id' , '=' , 'sp.product_id')
		->join('brand as b', 'b.brand_id' , '=' , 'p.brand_id')
		->where('invoice_number', '=', $req->invoice_number )
		->select(
			DB::raw('concat( p.product_name , " brand: " ,b.brand_name ) as product_name'),
			'sp.product_id as p_id', 
			'sp.quantity as selling_quantity' , 
			'sp.unit_price as selling_price' , 
			'p.having_serial',
			'sp.status'

		)
		->get();

		$arrayData['serial_cart'] = $serial_cart; 
		$arrayData['purchase_info'] = $purchase_info; 
		$arrayData['product_cart'] = $product_cart; 


		return $arrayData;
	}

	function test(Request $req){




		$products = DB::table('products as p')
		->select(
			DB::raw('concat( p.product_name , " brand: " ,b.brand_name ) as product_name'),
			'p.selling_price' ,
			'p.purchase_cost' ,
			'p.selling_quantity' ,
			'p.warranty_days')
		->join('brand as b', 'b.brand_id' , '=' , 'p.brand_id')
		->get();

		return $products;		

	}


}
