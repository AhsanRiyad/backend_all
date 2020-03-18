<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use DB;


class users_info extends Controller
{
    //

    function get_data_update_request_list(Request $req){

    	$request_list = 
    	DB::table('all_info_together')
    	->where([
    		['change_request' , '=' , 'requested']
    	])
    	->select(
    		DB::raw("concat(first_name, ' ' , last_name) as full_name"),
    		'email as Email',
    		'change_request_time',
    	)
    	->get();


    	return $request_list;

    }
    function get_new_user_request_list(Request $req){

        $new_user_list = 
        DB::table('all_info_together')
        ->where([
            ['status' , '=' , 'new']
        ])
        ->select(
            DB::raw("concat(first_name, ' ' , last_name) as full_name"),
            'email as Email',
            'registration_date',
        )
        ->get();


        return $new_user_list;

    }
    function get_info_of_a_particular_user_with_promise(Request $req){

        $users_info = 
        DB::table('all_info_together')
        ->where([
            ['email' , '=' , $req->email]
        ])
        ->select(

            "first_name as First Name" ,
            "last_name as Last Name" ,
            "name_bangla as Bangla Name" ,
            "institution_id as institution Id" ,
            "mobile as Mobile",
            "nid_or_passport as NID/Passport" ,
            "blood_group as Blood Group" ,
            "religion as Religion"  ,
            "date_of_birth as Date Of Birth",
            "fathers_name as Father's Name",
            "mother_name as Mother's Name" ,
            "spouse_name as Spouse's Name" ,
            "number_of_children as Number Of Children" ,
            "profession as Profession" ,
            "institution as Workplace" ,
            "designation as Designation" ,
            "present_line1 as Present Address Line 1" ,
            "present_post_office_name as Present Post Office Name" ,
            "present_post_code as Present Post Code" ,
            "present_police_station as Present Police Station" ,
            "present_district as Present District" ,
            "present_country as Present Country" ,  
            "parmanent_line1 as Permanent Address Line 1" ,
            "parmanent_post_office_name as Permanent Post Office Name" ,
            "parmanent_post_code as Permanent Post Code" ,
            "parmanent_police_station as Permanent Police Station" ,
            "parmanent_district as Permanent District" ,
            "parmanent_country as Permanent Country"

        )
        ->get();

        return $users_info;
    }
}
