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

Route::get('/', function () {
    return view('welcome');
});


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


/******************** product *******************/
Route::post('/get_product', 'product@get_product');
Route::post('/get_category_brand_product_code', 'product@get_category_brand_product_code');
Route::post('/add_product', 'product@add_product');


/************ purchase ***********/
//initial function for purchase, for getting product list , supplier, brand , warehouse information
Route::post('/getData_add_purchase', 'purchase@getData_add_purchase');

//this is for adding/updating purchase, for submit button
Route::post('/add_purchase', 'purchase@add_purchase');

//this is getting inital data for editing purchase, for example existing data
Route::post('/edit_purchase', 'purchase@edit_purchase');

//this is the submit function for editing purchase information
Route::post('/update_purchase', 'purchase@update_purchase');

//this will send purchase list
Route::post('/purchase_list', 'purchase@purchase_list');


/*************** sell *****************/
//initial function for purchase, for getting product list , supplier, brand , warehouse information
Route::post('/getData_add_sell', 'sell@getData_add_sell');
//this is submit button work for add/edit sell
Route::post('/add_sell', 'sell@add_sell');
// sends intial data for list of sells
Route::post('/sells_list', 'sell@sells_list');
//sends a particular sells info
Route::post('/edit_sell', 'sell@edit_sell');














