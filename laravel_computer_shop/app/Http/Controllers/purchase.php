<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use DB;

class purchase extends Controller
{
	function get_supplier(Request $req){

		$people = DB::table('people')->where('type' , '=' , 'Supplier')->get();
		
		// $products = DB::table('products')->get();

		$products = DB::select(" select concat( p.product_name , ' brand: ' ,b.brand_name) as product_name , p.selling_price , p.purchase_cost , p.selling_quantity , p.warranty_days , p.p_id as p_id, p.brand_id from products p , brand b where p.brand_id = b.brand_id ");


		$serial = DB::table('serial_number')->get();
		$warehouse = DB::table('warehouse')->get();
		
		$arrayData['people'] = $people; 
		$arrayData['products'] = $products; 
		$arrayData['serial'] = $serial; 
		$arrayData['warehouse'] = $warehouse; 
		// $arrayData['products_test'] = $products_test; 

		return $arrayData;
	}


	function add_purchase(Request $req){




		//invoice nubmer generation



		$invoice_number = DB::table('purchase_or_sell')->max('invoice_number');
		if($invoice_number == ''){

			$invoice_number = 100000;

		}else{

			$invoice_number += 1; 
		}



		//adding serial


		$i = 0;
		for($i = 0 ; $i < count($req->purchase_data['serial']); $i++ ){

			DB::table('serial_number')->insert(
				[
					'invoice_number' => $invoice_number, 
					'product_id' => $req->purchase_data['serial'][$i]['p_id'],
					'serial_number' => $req->purchase_data['serial'][$i]['serial_number'],
					'status' => 'purhase'
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


		$status = DB::update('UPDATE `purchase_or_sell` SET 
			`insert_time_date`= sysdate()
			WHERE
			invoice_number = (?)' , 
			[
				$invoice_number
			]);




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






}
