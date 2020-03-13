<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use DB;
class search extends Controller
{
    //
    
	function getAllPeopleList(Request $req){


		$people = DB::table('all_info_together')->get();

		return $people;

	}

}
