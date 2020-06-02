<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;



class brand extends Controller
{
    //
	function edit_brand(Request $req){
		$brand_exists = DB::table('brand')->where('brand_name', $req->brand_name)->count();

		if($brand_exists > 1 ){
			return 'brand_exists';
		}else{

			$affected = DB::table('brand')
			->where('brand_id', $req->brand_id)
			->update([
				'brand_name' => $req->brand_name , 
				'brand_description' => $req->brand_details
				]);


			$brands = DB::table('brand')->get();
			$arrayData['brand_list'] = $brands; 
			$arrayData['status'] = 'updated'; 

			return $arrayData;
		}
		

	}

	function test(Request $request){



		return 'in the laravel';


	}

}
