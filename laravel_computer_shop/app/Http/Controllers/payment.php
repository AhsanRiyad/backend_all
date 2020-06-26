<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Http\Traits\PaymentTrait;
use DB;


class payment extends Controller
{
	use PaymentTrait;

	/*
	| this funtion will send initial data for adding payment
    */
	function add_payment_get_initial_data(Request $req)
	{
		$peopleList =
			DB::table('people')
			->select(DB::raw('concat(full_name,  " type: " , type   ) as full_name'), 'people_id')
			->get();

		return $peopleList;
	}

	/*
	| this funtion will finally add payment to database // works for add_payment/edit_payment submit button
    */
	function add_payment_general(Request $req)
	{

		// return $req->transactions;
		if ($req->transaction_id != '') {

			//then update the data according to transaction id
			DB::table('transactions')
				->where('transaction_id', $req->transaction_id)
				->update($req->transactions);

			return 'OK';
		}

		//get the transaction id
		$transaction_id =
			DB::table('transactions')
				->select(DB::raw('max(transaction_id)+1 as c'))
				->get()[0]->c;

		//this is basic exception handling
		$transaction_id == null ? $transaction_id = 1000000 : '';

		//first insert transaction id
		DB::table('transactions')
			->insert(['transaction_id' => $transaction_id]);

		//then update the data according to transaction id
		DB::table('transactions')
			->where('transaction_id', $transaction_id)
			->update($req->transactions);

		return 'OK';
	}

	function UpdateTransactions(Request $request)
	{

		$affected = DB::table('transactions')
			->whereRaw(
			'transaction_id = (SELECT min(transaction_id) FROM `transactions` where invoice_number = ? ) ', [$request->invoice_number]
			)
			->update(  [ 'total_amount' => $request->transactions['total_amount']  ]);

		return response('OK', 200)
			   ->header('Content-Type', 'text/plain');

		// UPDATE transactions set total_amount = 10 WHERE transaction_id = ( SELECT min(transaction_id) FROM `transactions` where invoice_number = 10000 );

	}


	/*
	| get payment history against a invoice number
    */
	function payment_history_by_invoice_number(Request $req)
	{

		//check if this invoice number is for sell or puchase
		$isPurchaseOrSell =
			DB::table('purchase_or_sell')
				->select('status')
				->where('invoice_number', $req->invoice_number)
				->get()[0]->status;

		//make a decision on debit or credit
		$debit_or_credit = '';
		$isPurchaseOrSell == 'Received' ?  $debit_or_credit = 'debit' : $debit_or_credit = 'credit';

		//get the transaction history according to debit or credit
		$transaction_history =
			DB::table('transactions')
			->where([
				['invoice_number', '=',  $req->invoice_number],
				['debit_or_credit', '=',  $debit_or_credit],
			])
			->get();
		$transactions['transactions'] = $transaction_history;
		return $transactions;
	}
	/*
	| get payment history against a invoice number
    */
	function deleteTransaction(Request $req)
	{
		//check if this invoice number is for sell or puchase
		$affected =
			DB::table('transactions')
			->where('transaction_id', $req->transaction_id)
			->delete();
		return 'ok';
	}
	/*
	| get payment history against a invoice number
    */
	function get_invoice_info($invoice_number)
	{

		$h1 =  $this->invoice_trait($invoice_number);

		return $h1;
		// return $invoice_number;
	}
	/*
	| Print invoice
    */
	function download_inovice_pdf($invoice_number)
	{

		$data['users_info'] = $req->users_info;
		$pdf = PDF::loadView('user_print_pdf', $data);
		$pdf->save('storage/users_info.pdf');
		return $pdf->stream('users_info.pdf');
	}
}
