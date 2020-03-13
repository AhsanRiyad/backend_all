<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use DB;

class photos extends Controller
{
    //
	function getPhotosForAll(Request $req){

		// $req->email = 'riyad298@gmail.com';


		$recent_and_old_photos = 
		DB::table('all_info_together')
		->select('old_photo' , 'recent_photo')
		->where([
			['email' , '=' , $req->email]
		])
		->get();

		$group_photos = 
		DB::table('user_photos')
		->select('group_photo')
		->where([
			['email' , '=' , $req->email]
		])
		->get();

		$photos['recent_and_old'] = $recent_and_old_photos;
		$photos['group_photos'] = $group_photos;

		return $photos;
	}


	function deletePhoto(Request $req){

		// $req->email = 'riyad298@gmail.com';

		DB::table('user_photos')->where([
			['group_photo', '=', $req->photo_name],
			['email', '=', $req->email],
			])->delete();

		return $req;
	}
}
