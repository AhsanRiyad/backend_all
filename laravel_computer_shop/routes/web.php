<?php

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/


/****************brand***************/
Route::post('/edit_brand', 'brand@edit_brand');



/*******************category****************/
Route::post('/get_category', 'category@get_category');
Route::post('/get_category_details', 'category@get_category_details');
Route::post('/edit_category', 'category@edit_category');



/*************** people **************/
Route::post('/get_people', 'people@get_people');
Route::post('/get_people_details', 'people@get_people_details');
Route::post('/edit_people', 'people@edit_people');
Route::get('/edit_brand', 'brand@test');
//this function will register people
Route::post('/add_people', 'people@add_people');



/******************** product *******************/
Route::post('/get_product', 'product@get_product');
Route::post('/get_category_brand_product_code', 'product@get_category_brand_product_code');
Route::post('/add_product', 'product@add_product');





/************ purchase ***********/
//initial function for purchase, for getting product list , supplier, brand , warehouse information
Route::post('/getData_add_purchase', 'purchase@getData_add_purchase');
//this is for adding/updating purchase, for submit button
Route::post('/add_purchase', 'purchase@add_purchase');
Route::get('/add_purchase', 'purchase@add_purchase');
//this is getting inital data for editing purchase, for example existing data
Route::post('/edit_purchase', 'purchase@edit_purchase');
//this is the submit function for editing purchase information
Route::post('/update_purchase', 'purchase@update_purchase');
//this will send purchase list
Route::post('/purchase_list', 'purchase@purchase_list');
//this will delete a invoice of purchase
Route::post('/delete_invoice_purchase', 'purchase@delete_invoice_purchase');





/*************** sell *****************/
//initial function for purchase, for getting product list , supplier, brand , warehouse information
Route::post('/getData_add_sell', 'sell@getData_add_sell');
//this is submit button work for add/edit sell
Route::post('/add_sell', 'sell@add_sell');
// sends intial data for list of sells
Route::post('/sells_list', 'sell@sells_list');
Route::get('/sells_list', 'sell@sells_list');
//sends a particular sells info
Route::post('/edit_sell', 'sell@edit_sell');
//delete a invoice of sell
Route::post('/delete_invoice_sell', 'sell@delete_invoice_sell');




/*************** Payment *****************/
/*
| this route will send intial data for adding payment, for example people_list
*/
Route::post('/add_payment_get_initial_data', 'payment@add_payment_get_initial_data');
/*
| this route will add payment for general purpose
*/
Route::post('/add_payment_general', 'payment@add_payment_general');
//get payment history by inovice number
Route::post('/payment_history_by_invoice_number', 'payment@payment_history_by_invoice_number');
//this route will delete transaction
Route::post('/deleteTransaction', 'payment@deleteTransaction');
//get invoice details
Route::get('/get_invoice_info/{invoice_number}', 'payment@get_invoice_info');
//this route will send the invoice pdf file to download
Route::get('/download_inovice_pdf/{invoice_number}', 'payment@download_inovice_pdf');

