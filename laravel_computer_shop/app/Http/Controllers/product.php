<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use DB;

class product extends Controller
{

	function get_product($itemPerPage , $orderBy , $search ){

		// $orderBy = 'b.brand_name';

		$product = DB::table('products')->get();
		$arrayData['product'] = $product; 

		$search == 'none' ? $search = '': ''; 


		// ->join('people as s' , 's.people_id' , '=' 'sp.supplier_id')

		$products = DB::table('products as p')
		->join('category as c', 'p.category_id', '=', 'c.category_id')
		->join('brand as b', 'b.brand_id', '=', 'p.brand_id') 
		->select('p.*', 'b.brand_name as b.brand_name', 'c.category_name as category_name')
		->orderBy($orderBy)
		->where( 'p.product_name' , 'like' , '%'.$search.'%' )
		->paginate( $itemPerPage );

		$arrayData['product'] = $products; 

		
		return $arrayData;

		// $users = DB::table('users')
		// ->join('contacts', 'users.id', '=', 'contacts.user_id')
		// ->join('orders', 'users.id', '=', 'orders.user_id')
		// ->select('users.*', 'contacts.phone', 'orders.price')
		// ->get();



		// return '';

	}
	function get_category_brand_product_code(){

		$info['products'] = 
		DB::table('products')
		->get();

		$info['brand'] = 
		DB::table('brand')
		->get();

		$info['category'] = 
		DB::table('category')
		->get();

		$info['product_code'] = 
		DB::table('products')
		->select(DB::raw('max(product_code)+1 as c'))
		->get();
		return $info;
	}
	function add_product(Request $request){
		DB::table('products')
		->insert($request->products_info);
		return 'add_product';

	}
	function test(Request $request){


		DB::table('products')
		->insert();

		return 'echo';


	}




}
