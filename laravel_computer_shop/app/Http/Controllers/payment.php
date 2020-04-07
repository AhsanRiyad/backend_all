<?php
namespace App\Http\Controllers;

use Illuminate\Http\Request;
use DB;

class payment extends Controller
{
    /*
	| this funtion will send initial data for adding payment
    */
	function add_payment_get_initial_data(Request $req){
		
		$peopleList = 
		DB::table('people')
		->select(DB::raw('concat(full_name,  " type: " , type   ) as full_name'), 'people_id')
		->get();

		return $peopleList;
	}

    /*
	| this funtion will finally add payment to database 
    */
	function add_payment_general(Request $req){
		
		// return $req->transactions;

		//get the transaction id
		$transaction_id = 
		DB::table('transactions')
		->select(DB::raw('max(transaction_id)+1 as c'))
		->get()[0]->c;

		//this is basic exception handling
		$transaction_id == null ? $transaction_id = 1000000 : '';

		//first insert transaction id
		DB::table('transactions')
		->insert( [ 'transaction_id' => $transaction_id ] );


		//then update the data according to transaction id
		DB::table('transactions')	
		->where( 'transaction_id' , $transaction_id )
		->update( $req->transactions );

		return 'OK';
	}


}
