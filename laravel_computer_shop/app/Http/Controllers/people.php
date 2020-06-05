<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use DB;


class people extends Controller
{


	function get_people(Request $req)
	{


		$people = DB::table('people')->get();
		$arrayData['people'] = $people;

		return $arrayData;
	}
	function get_people_details(Request $req)
	{


		$people = DB::table('people')->where('people_id', '=', $req->people_id)->get();

		$arrayData['people'] = $people;

		return $arrayData;
	}

	//this function will register user
	function add_people(Request $req)
	{

		$UserInfo = $req->UserInfo;

		// return $UserInfo;

		$isUserExists =
			DB::table('people')
				->where('email', $UserInfo['email'])
				->orWhere('mobile', '=', $UserInfo['mobile'])
				->select(DB::raw('count(*) as c'))
				->get()[0]->c;


		if ($isUserExists > 1) return 'user_exists';

		DB::table('people')
			->insert((array) $UserInfo);

		return 'ok';
	}

	function edit_people(Request $request)
	{
		$people_exists = DB::table('people')->where([['mobile', $request->UserInfo['mobile']],  ['full_name', $request->UserInfo['full_name']]])->count();

		if ($people_exists > 1) return 0;

		$affected = DB::table('people')
			->where('people_id', $request->id)
			->update($request->UserInfo);
		return $affected;
	}

	function get_all_people(Request $request)
	{
		// return $request;
		// $orderBy = 'b.brand_name';
		$request->search == 'none' ? $request->search = '' : '';
		// ->join('people as s' , 's.people_id' , '=' 'sp.supplier_id')
		$people = DB::table('people')
			->orderBy($request->orderBy)
			->where('full_name', 'like', '%' . $request->search . '%')
			->orWhere('mobile', 'like', '%' . $request->search . '%')
			->orWhere('email', 'like', '%' . $request->search . '%')
			->orWhere('company_name', 'like', '%' . $request->search . '%')
			->orWhere('type', 'like', '%' . $request->search . '%')
			->paginate($request->itemPerPage);

		$arrayData['people'] = $people;

		return $arrayData;
	}
}
