<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use DB;

class product extends Controller
{

	function get_product($itemPerPage, $orderBy, $search)
	{

		// $orderBy = 'b.brand_name';

		$product = DB::table('products')->get();
		$arrayData['product'] = $product;

		$search == 'none' ? $search = '' : '';


		// ->join('people as s' , 's.people_id' , '=' 'sp.supplier_id')

		$products = DB::table('products as p')
			->join('category as c', 'p.category_id', '=', 'c.category_id')
			->join('brand as b', 'b.brand_id', '=', 'p.brand_id')
			->select('p.*', 'b.brand_name as b.brand_name', 'c.category_name as category_name')
			->orderBy($orderBy)
			->where('p.product_name', 'like', '%' . $search . '%')
			->paginate($itemPerPage);

		$arrayData['product'] = $products;


		return $arrayData;

		// $users = DB::table('users')
		// ->join('contacts', 'users.id', '=', 'contacts.user_id')
		// ->join('orders', 'users.id', '=', 'orders.user_id')
		// ->select('users.*', 'contacts.phone', 'orders.price')
		// ->get();



		// return '';

	}
	function get_category_brand_product_code()
	{

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

		if ($info['product_code'][0]->c == '') {
			$info['product_code'][0]->c = 10000;
		}
		return $info;
	}
	function add_product(Request $request)
	{
		//find product code
		$code['product_code'] =
			DB::table('products')
			->select(DB::raw('max(product_code)+1 as c'))
			->get();
		if ($code['product_code'][0]->c == '') {
			$code['product_code'][0]->c = 10000;
		}
		$product_info = $request->products_info;
		$product_info['product_code'] = $code['product_code'][0]->c;

		//insert to db
		DB::table('products')
			->insert($product_info);

		
		return $product_info;
	}
	function edit_product(Request $request)
	{
		$product_exists = DB::table('products')->where('product_name', $request->product_info['product_name'])->count();

		if ($product_exists > 1) return 0;

		$affected = DB::table('products')
			->where('p_id', $request->p_id)
			->update($request->product_info);
		return $affected;
	}
	function get_product_by_id($id)
	{
		$product =  DB::table('products as p')
			->select(
				DB::raw('CAST( p.selling_price as char(10) ) as selling_price'),
				DB::raw('CAST( p.selling_quantity as char(10)) as selling_quantity'),
				DB::raw('CAST( p.purchase_cost as char(10)) as purchase_cost'),
				'p.product_code',
				'p.warranty_days',
				'p.having_serial',
				'p.p_id',
				'p.brand_id',
				'p.category_id',
				'p.product_name',
				'p.product_details',
			)
			->where('p_id', $id)
			->get();

		return json_encode($product);
	}

	function get_product_post(Request $request)
	{
		// return $request;

		// $orderBy = 'b.brand_name';
		$product = DB::table('products')->get();
		$arrayData['product'] = $product;

		$request->search == 'none' ? $request->search = '' : '';

		// ->join('people as s' , 's.people_id' , '=' 'sp.supplier_id')

		$products = DB::table('products as p')
			->join('category as c', 'p.category_id', '=', 'c.category_id')
			->join('brand as b', 'b.brand_id', '=', 'p.brand_id')
			->select('p.*', 'b.brand_name as b.brand_name', 'c.category_name as category_name')
			->orderBy($request->orderBy)
			->where('p.product_name', 'like', '%' . $request->search . '%')
			->orWhere('b.brand_name', 'like', '%' . $request->search . '%')
			->orWhere('c.category_name', 'like', '%' . $request->search . '%')
			->orWhere('p.purchase_cost', 'like', '%' . $request->search . '%')
			->orWhere('p.selling_price', 'like', '%' . $request->search . '%')
			->orWhere('p.warranty_days', 'like', '%' . $request->search . '%')
			->paginate($request->itemPerPage);

		$arrayData['product'] = $products;

		return $arrayData;
		// $users = DB::table('users')
		// ->join('contacts', 'users.id', '=', 'contacts.user_id')
		// ->join('orders', 'users.id', '=', 'orders.user_id')
		// ->select('users.*', 'contacts.phone', 'orders.price')
		// ->get();
		// return '';
	}


	function test(Request $request)
	{


		DB::table('products')
			->insert();

		return 'echo';
	}
}
