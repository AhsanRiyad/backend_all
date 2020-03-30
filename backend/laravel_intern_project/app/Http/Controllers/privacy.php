<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use DB;

class privacy extends Controller
{
    //
	function getPrivacyData(Request $req){

		// $req->email = "riyad298@gmail.com";

		

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
			"a.mobile as Mobile" , 'p.mobile',
			"a.email as Email" , 'p.email',
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
			"a.present_line1 as Present Address Line1" , 'p.present_line1',


			"a.first_name as Social Network"  , 'p.social_network', 



			"a.present_post_office_name as Present Post Office Name" , "p.present_post_office_name" ,
			"a.present_post_code as Present Post Code" , "p.present_post_code" ,
			"a.present_police_station as Present Police Station" , "p.present_police_station" , 
			"a.present_district as Present District" , "p.present_district" , 
			"a.present_country as Present Country" ,   "p.present_country" , 
			"a.parmanent_line1 as Permanent Adress Line 1" , "p.parmanent_line1" , 
			"a.parmanent_post_office_name as Permanent Post Office Name" , "p.parmanent_post_office_name" , 
			"a.parmanent_post_code as Permanent Post Code" , "p.parmanent_post_code" , 
			"a.parmanent_police_station as Permanent Police Station" , "p.parmanent_police_station" , 
			"a.parmanent_district as Permanent District" , "p.parmanent_district" , 
			"a.parmanent_country as Permanent Country", "p.parmanent_country" , 
			"a.parmanent_country as Permanent Country", "p.parmanent_country" , 
			"a.membership_fee as Membership Fee", "p.membership_fee" 


			
			
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


		if($req->purpose == 'forProfile'){


			// echo 'update Privacy';



			$change_request_exists = 
			DB::table($req->table_name)
			->where('email', '=' , $req->email )
			->select('change_request')
			->get();

			// echo $change_request_exists[0]->change_request;

			if($change_request_exists[0]->change_request == 'approved'){




				$old = DB::table('all_info_together')
				->where([
					[ 'email' , '=' , /*$req->email*/  $req->email  ]
				])
				->select('first_name' , 'last_name' , 'name_bangla' , 'institution_id' , 'mobile', 'nid_or_passport' , 'blood_group' , 'religion'  , 'date_of_birth', 'fathers_name', 'mother_name' , 'spouse_name' , 'number_of_children' , 'profession' , 'institution' , 'designation' , 'present_line1' , 'present_post_office_name' , 'present_post_code' , 'present_police_station' , 'present_district' , 'present_country' ,   
					'parmanent_line1' , 'parmanent_post_office_name' , 'parmanent_post_code' , 'parmanent_police_station' , 'parmanent_district' , 'parmanent_country'

				)
				->get();


				$r =  json_decode($old);


				foreach($r[0] as $key => $value) {
			// print "$key => $value\n";

			// echo '<br>';


					DB::table('data_log')
					->where('email', '=' ,  $req->email  )
					->update([ $key => $value ]);


				}



				DB::table('all_info_together')
				->where('email', '=' ,  $req->email   )
				->update([ 'change_request' => 'requested']);





			}



		}




		if($req->purpose == 'forUpdateRequest'){

			if($req->privacy_value == 'rejected'){



				$old = DB::table('data_log')
				->where([
					[ 'email' , '=' , /*$req->email*/  $req->email  ]
				])
				->select('first_name' , 'last_name' , 'name_bangla' , 'institution_id' , 'mobile', 'nid_or_passport' , 'blood_group' , 'religion'  , 'date_of_birth', 'fathers_name', 'mother_name' , 'spouse_name' , 'number_of_children' , 'profession' , 'institution' , 'designation' , 'present_line1' , 'present_post_office_name' , 'present_post_code' , 'present_police_station' , 'present_district' , 'present_country' ,   
					'parmanent_line1' , 'parmanent_post_office_name' , 'parmanent_post_code' , 'parmanent_police_station' , 'parmanent_district' , 'parmanent_country'

				)
				->get();


				$r =  json_decode($old);


				foreach($r[0] as $key => $value) {
			// print "$key => $value\n";

			// echo '<br>';


					DB::table('all_info_together')
					->where('email', '=' ,  $req->email  )
					->update([ $key => $value ]);


				}



				DB::table('all_info_together')
				->where('email', '=' ,  $req->email   )
				->update([ 'change_request' => 'rejected']);
			}


		}else if($req->purpose == 'forNewUserRequest'){


			$membership_number = 
			DB::table('users_registration')
			->select( DB::raw("max(membership_number)+1 as c") )
			->get();

			$membership_number_extracted = $membership_number[0]->c;

			DB::table($req->table_name)
			->where('email', '=' , $req->email )
			->update([ 'membership_number' => $membership_number_extracted ]);


		}





		DB::table($req->table_name)
		->where('email', '=' , $req->email )
		->update([ $req->field_name => $req->privacy_value]);

		return $req;


	}


	function test(Request $req){


		$membership_number = 
		DB::table('users_registration')
		->select( DB::raw("max(membership_number)+1 as c") )
		->get();


		// dd($membership_number[0]->c);
		return ($membership_number[0]->c);



	}



}
