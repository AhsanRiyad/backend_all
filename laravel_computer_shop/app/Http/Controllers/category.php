<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use DB;


class category extends Controller
{
    //

	function get_category(Request $req){


		$category = DB::table('category')->get();
		$arrayData['category'] = $category; 

		return $arrayData;


	}
	function get_category_details(Request $req){


		$category = DB::table('category')->where( 'category_id' , '=' , $req->category_id )->get();
		
		$arrayData['category'] = $category; 

		return $arrayData;


	}
	function edit_category(Request $req){


		$category_exists = DB::table('category')->where('category_name', $req->category_name)->count();

		if($category_exists > 0 ){
			return 'category_exists';
		}else{

			$affected = DB::table('category')
			->where('category_id', $req->category_id)
			->update([
				'category_name' => $req->category_name , 
				'category_description' => $req->category_details
				]);


			$categorys = DB::table('category')->get();
			$arrayData['category'] = $categorys; 
			$arrayData['status'] = 'updated'; 

			return $arrayData;
		}







	}


}
