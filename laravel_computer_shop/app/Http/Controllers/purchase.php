<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use DB;

class purchase extends Controller
{
    function get_supplier(Request $req){

		$people = DB::table('people')->where('type' , '=' , 'Supplier')->get();
		
		$products = DB::table('products')->get();

		$serial = DB::table('serial_number')->get();
		
		$arrayData['people'] = $people; 
		$arrayData['products'] = $products; 
		$arrayData['serial'] = $serial; 

		return $arrayData;
	}






}
