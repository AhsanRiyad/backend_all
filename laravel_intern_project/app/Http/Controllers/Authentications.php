<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use DB;

class Authentications extends Controller
{
    //
	function login(Request $req){

		

	}
	function test(Request $req){

		/*$old = DB::table('all_info_together')
		->where([
			[ 'email' , '=' , 'riyad298@gmail.com' ]
		])
		->select('first_name' , 'last_name' , 'fathers_name', 'mother_name')
		->get();
*/


		$new = DB::table('all_info_together')
		->where([
			[ 'email' , '=' , $req->email /*'riyad298@gmail.com' */]
		])
		->select(
			"first_name" , "first_name as First Name" ,
			"last_name" ,  "last_name as Last Name" ,  
			"name_bangla" , "name_bangla as Bangla Name" , 
			"institution_id" , "institution_id as Institution Id" ,
			"mobile", "mobile as Mobile",
			"email", "email as Email",
			"nid_or_passport" , "nid_or_passport as NID or Passport" ,
			"blood_group" , "blood_group as Blood Group" ,
			"religion"  , "religion as Religion"  ,
			"date_of_birth", "date_of_birth as Date Of Birth",
			"fathers_name",  "fathers_name as Father's Name", 
			"mother_name" , "mother_name as Mother's Name" ,
			'spouse_name' , "spouse_name as Spouse's Name" ,
			"number_of_children" , "number_of_children as Number Of Children" ,
			"profession" , "profession as Profession" ,
			"institution" , "institution as Institution" ,
			"designation" , "designation as Designation" ,
			"present_line1" , "present_line1 as Present Adress Line 1" ,
			"present_post_office_name" , "present_post_office_name as Present Post Office Name" ,
			"present_post_code" , "present_post_code as Present Post Code" ,
			"present_police_station" , "present_police_station as Present Police Station" ,
			"present_district" , "present_district as Present District" ,
			"present_country" ,   "present_country as Present Country" ,   
			"parmanent_line1" , "parmanent_line1 as Permanent Adress Line 1" ,
			"parmanent_post_office_name" , "parmanent_post_office_name as Permanent Post Office Name" ,
			"parmanent_post_code" , "parmanent_post_code as Permanent Post Code" ,
			"parmanent_police_station" , "parmanent_police_station as Permanent Police Station" ,
			"parmanent_district" , "parmanent_district as Permanent District" ,
			"parmanent_country" , "parmanent_country as Permanent Country",

		)
		->get();

/*
		$r =  json_decode($old);*/

/*
		foreach($r[0] as $key => $value) {
			// print "$key => $value\n";

			// echo '<br>';


			DB::table('data_log')
			->where('email', '=' , 'riyad298@gmail.com' )
			->update([ $key => $value ]);


		}

*/
/*
		DB::table('all_info_together')
				->where('email', '=' , 'riyad298@gmail.com'  )
				->update([ 'change_request' => 'requested']);
*/
		// return $old;

		// var_dump(json_decode($old));


		// $r =  json_decode($old);

		// echo $r[0]->first_name;


/*
		foreach($r[0] as $key => $value) {
			print "$key => $value\n";

			DB::table('data_log')
			->where('email', '=' , 'riyad298@gmail.com' )
			->update([ $key=> $value ]);


		}*/


		$old = 
		DB::table('data_log')
			->where([
			[ 'email' , '=' , $req->email ]
		])
		->get();

		$data['old'] = $old;
		$data['new'] = $new;

		return $data;
		
	}

}
