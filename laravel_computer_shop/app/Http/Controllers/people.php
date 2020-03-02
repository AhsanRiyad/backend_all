<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use DB;


class people extends Controller
{


	function get_people(Request $req){


		$people = DB::table('people')->get();
		$arrayData['people'] = $people; 

		return $arrayData;


	}
	function get_people_details(Request $req){


		$people = DB::table('people')->where( 'people_id' , '=' , $req->people_id )->get();
		
		$arrayData['people'] = $people; 

		return $arrayData;



	}




	function edit_people(Request $req){


		$people_exists = DB::table('people')->where('mobile', $req->mobile)->count();

		if($people_exists > 0 ){
			return 'people_exists';
		}else{

			$affected = DB::table('people')
			->where('people_id', $req->people_id)
			->update([
				'full_name' => $req->full_name , 
				'company_name' => $req->company_name,
				'post_code' => $req->post_code,
				'email' => $req->email,
				'mobile' => $req->mobile,
				'address' => $req->address,
				'type' => $req->type,
			]);


			$people = DB::table('people')->get();
			$arrayData['people'] = $people; 
			$arrayData['status'] = 'updated'; 

			return $arrayData;





		}


}




}
