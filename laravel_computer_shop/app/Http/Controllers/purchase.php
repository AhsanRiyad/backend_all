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
		$arrayData['products'] = $products; 
		$arrayData['people'] = $people; 
		$arrayData['serial'] = $serial; 
		$arrayData['warehouse'] = $warehouse; 
		// $arrayData['products_test'] = $products_test; 

		return $arrayData;
	}



	function update_purchase(Request $req){



		//invoice nubmer generation
		$invoice_number = $req->purchase_data['invoice_number'];
		


		DB::table('purchase_or_sell')->where('invoice_number', '=', $invoice_number)->delete();
		DB::table('sell_or_purchase_details')->where('invoice_number', '=', $invoice_number)->delete();
		DB::table('serial_number')->where('invoice_number', '=', $invoice_number)->delete();




		//adding serial
		$i = 0;
		for($i = 0 ; $i < count($req->purchase_data['serial']); $i++ ){

			echo 'serial_number';
			echo $req->purchase_data['serial'][$i]['serial_number'];


			DB::table('serial_number')->insert(
				[
					'invoice_number' => $invoice_number, 
					'product_id' => $req->purchase_data['serial'][$i]['p_id'],
					'serial_number' => $req->purchase_data['serial'][$i]['serial_number'],
					'status' => $req->purchase_data['serial'][$i]['status']
				]
			);


		}

		// $affected = DB::table('serial_number')
		// ->where('invoice_number', $invoice_number)
		// ->update(['status' => 'Purchase']);



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

		$i = 0;
		for($i = 0 ; $i < count($req->purchase_data['products']); $i++ ){

			//


			/*if($req->purchase_data['products'][$i]['status'] == 'Returned' ){


				DB::table('serial_number')
				->where([
					['status', '=', 'Purchase'],
					['invoice_number', '=', $invoice_number ],
					['product_id', '=', $req->purchase_data['products'][$i]['p_id'] 
				],
			])->update(['status' => 'Returned']);


		}*/




		DB::table('purchase_or_sell')
		->where('invoice_number', $invoice_number)
		->update(['insert_time_date' => DB::raw('sysdate()')]);





		DB::table('sell_or_purchase_details')->insert(
			[
				'invoice_number' => $invoice_number, 
				'product_id' => $req->purchase_data['products'][$i]['p_id'],
				'quantity' => $req->purchase_data['products'][$i]['selling_quantity'],
				'unit_price' => $req->purchase_data['products'][$i]['selling_price'],
				'status' => $req->purchase_data['products'][$i]['status'],
			]
		);
			//

			// echo $req->purchase_data['products'][$i]['status'];


	}


	$affected = DB::table('purchase_or_sell')
	->where('invoice_number', $invoice_number)
	->update(['insert_time_date' => DB::raw('sysdate()')]);


	$count_return =  DB::table('sell_or_purchase_details')
	->select(DB::raw('count(*) as c'))
	->where([
		['invoice_number' , '=' , $invoice_number],
		['status' , '=' , 'Returned'],

	])
	->get();

	$count_partially_returned =  DB::table('sell_or_purchase_details')
	->select(DB::raw('count(*) as c'))
	->where([
		['invoice_number' , '=' , $invoice_number],
		['status' , '=' , 'Partial Return'],

	])
	->get();

	$count_total =  DB::table('sell_or_purchase_details')
	->select(DB::raw('count(*) as c'))
	->where([
		['invoice_number' , '=' , $invoice_number],
	])
	->get();







	if( $count_partially_returned[0]->c > 0 ){

		// return 'partina1 ';
		$affected = DB::table('purchase_or_sell')
		->where('invoice_number', $invoice_number)
		->update(['status' => 'Partial Return']);



	}else if( $count_total[0]->c == $count_return[0]->c ){

		// return 'partina2';

		$affected = DB::table('purchase_or_sell')
		->where('invoice_number', $invoice_number)
		->update(['status' => 'Returned']);

	}else if( $count_return[0]->c > 0 ){

		// return 'partina3 ';


		$affected = DB::table('purchase_or_sell')
		->where('invoice_number', $invoice_number)
		->update(['status' => 'Partial Return']);

	}else {

		// return 'partina3 ';


		$affected = DB::table('purchase_or_sell')
		->where('invoice_number', $invoice_number)
		->update(['status' => 'Received']);

	}

	// $a['t']['count_partially_returned'] = $count_partially_returned[0]->c;
	// $a['t']['count_return'] = $count_return[0]->c;
	// $a['t']['count_total'] = $count_total[0]->c;


	// return $a;


/*
		$affected = DB::table('serial_number')
		->where('status', 'new')
		->update(['status' => 'Purchase']);
*/



		// return $req->purchase_data['date'];
		// return $req;
		// return $req->purchase_data['products'][0];
		// return $req->purchase_data['products'][0]['product_name'];
		// return $invoice_number;




	}

	//add_purchase
	function add_purchase(Request $req){


		//invoice nubmer generation
		

		$invoice_number = 
		DB::table('purchase_or_sell')
		->max('invoice_number');



		// echo 'invoice_number';
		// echo $invoice_number;
		if($invoice_number == ''){

			$invoice_number = 100000;

		}else{

			$invoice_number += 1; 
		}
		


		//adding serial
		$i = 0;
		for($i = 0 ; $i < count($req->purchase_data['serial']); $i++ ){

			echo 'serial_number';
			echo $req->purchase_data['serial'][$i]['serial_number'];

			DB::table('serial_number')->insert(
				[
					'invoice_number' => $invoice_number, 
					'product_id' => $req->purchase_data['serial'][$i]['p_id'],
					'serial_number' => $req->purchase_data['serial'][$i]['serial_number'],
					'status' => $req->purchase_data['serial'][$i]['status']
				]
			);


		}

		// $affected = DB::table('serial_number')
		// ->where('invoice_number', $invoice_number)
		// ->update(['status' => 'Purchase']);



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

		$i = 0;
		for($i = 0 ; $i < count($req->purchase_data['products']); $i++ ){

			//
			DB::table('sell_or_purchase_details')->insert(
				[
					'invoice_number' => $invoice_number, 
					'product_id' => $req->purchase_data['products'][$i]['p_id'],
					'quantity' => $req->purchase_data['products'][$i]['selling_quantity'],
					'unit_price' => $req->purchase_data['products'][$i]['selling_price'],
					'status' => $req->purchase_data['products'][$i]['status'],
				]
			);
			//

			// echo $req->purchase_data['products'][$i]['status'];


		}


		$affected = DB::table('purchase_or_sell')
		->where('invoice_number', $invoice_number)
		->update(['insert_time_date' => DB::raw('sysdate()')]);



		// return $req->purchase_data['date'];
		return $req;
		// return $req->purchase_data['products'][0];
		// return $req->purchase_data['products'][0]['product_name'];
		// return $invoice_number;
	}


	// purchase_list
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
		->select('invoice_number' ,  'product_id as p_id' , 'serial_number' , 'status')
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


	// 	DB::table('invoice_number')
	// 	->where([
	// 		['status', '=', 'Returned'],
	// 		['invoice_number', '=', $invoice_number ],
	// 		['product_id', '=', $req->purchase_data['products'][$i]['p_id'] 
	// 	],
	// ])
	// 	->update(['status' => 'Returned']);



		// $affected = DB::table('purchase_or_sell')
		// ->where('invoice_number', 100000)
		// ->update(['insert_time_date' => DB::raw('sysdate()')]);


		// return  DB::select( 'select count(*) as c  from serial_number where invoice_number = 100000 and product_id = 2');

		
		$i['total'] =  DB::table('serial_number')
		->select(DB::raw('count(*) as c'))
		->where([
			['invoice_number' , '=' , 100000],
			['product_id' , '=' , 2],

		])
		->get();

		$i['return'] =  DB::table('serial_number')
		->select(DB::raw('count(*) as c'))
		->where([
			['invoice_number' , '=' , 100000],
			['product_id' , '=' , 2],
			['status' , '=' , 'Returned'],

		])
		->get();

		if($i['total']->c == $i['return']->c ){

		}
		// return $affected;		

	}


}
