<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use DB;

class privacy extends Controller
{
    //
	function getPrivacyData(Request $req){

		$privacy_info = 
		DB::table('all_info_together as a')
		->join('privacy as p' , 'p.email' , '=' ,'a.email')
		->where('a.email' , '=' , $req->email)
		->select(
			'a.first_name as First Name' , 'p.first_name',
			'a.last_name as Last Name' , 'p.last_name',
			'a.name_bangla as Bangla Name' , 'p.name_bangla',
			"a.fathers_name as Father's Name" , 'p.fathers_name',
			"a.mother_name as Mother's Name" , 'p.mother_name',
			"a.spouse_name as Spouse's Name" , 'p.spouse_name',
			"a.spouse_name as Spouse's Name" , 'p.spouse_name',
			"a.mobile as Mobile" , 'p.mobile',
			"a.mobile as Mobile" , 'p.mobile',
			"a.institution_id as Institution Id" , 'p.institution_id',
			"a.membership_number as Membership Number" , 'p.membership_number',
			"a.gender as Gender" , 'p.gender',
			"a.nid_or_passport as NID/Passport" , 'p.nid_or_passport',
			"a.number_of_children as Number Of Children" , 'p.number_of_children',
			"a.profession as Profession" , 'p.profession',
			"a.designation as Designation" , 'p.designation',
			"a.institution as Institution" , 'p.institution',
			"a.blood_group as Blood Group" , 'p.blood_group',
			"a.religion as Religion" , 'p.religion',
			"a.date_of_birth as Date Of Birth" , 'p.date_of_birth',
			"a.status as Status" , 'p.status',
			"a.type as Type" , 'p.type',
			"a.change_request as Change Request" , 'p.change_request',
		)
		->get();


		$user_info['privacy_info'] = $privacy_info;

		$user_info['all_info'] = 
		DB::table('all_info_together as a')
		->where('a.email' , '=' , $req->email)
		->get();




		return $user_info;



	}


	function updatePrivacy(Request $req){

		DB::table($req->table_name)
		->where('email', '=' , $req->email )
		->update([ $req->field_name => $req->privacy_value]);

		return $req;


	}



}
