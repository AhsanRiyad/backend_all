<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use DB;

class product extends Controller
{


	function get_product(Request $req){

		
		$product = DB::table('products')->get();
		$arrayData['product'] = $product; 


		// ->join('people as s' , 's.people_id' , '=' 'sp.supplier_id')

		$products = DB::table('products as p')
		->join('category as c', 'p.category_id', '=', 'c.category_id')
		->join('brand as b', 'b.brand_id', '=', 'p.brand_id')
		->select('p.*', 'b.brand_name as brand_name', 'c.category_name as category_name')
		->get();

		$arrayData['product'] = $products; 

		
		return $arrayData;

		// $users = DB::table('users')
		// ->join('contacts', 'users.id', '=', 'contacts.user_id')
		// ->join('orders', 'users.id', '=', 'orders.user_id')
		// ->select('users.*', 'contacts.phone', 'orders.price')
		// ->get();



		// return '';

	}
	function test(Request $req){


		return 'echo';


	}




}
