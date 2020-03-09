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


//brand
Route::post('/edit_brand', 'brand@edit_brand');


//category
Route::post('/get_category', 'category@get_category');

Route::post('/get_category_details', 'category@get_category_details');
Route::post('/edit_category', 'category@edit_category');


//people
Route::post('/get_people', 'people@get_people');
Route::post('/get_people_details', 'people@get_people_details');

Route::post('/edit_people', 'people@edit_people');

Route::get('/edit_brand', 'brand@test');


//product
Route::post('/get_product', 'product@get_product');


// purchase
Route::post('/get_supplier', 'purchase@get_supplier');
Route::post('/add_purchase', 'purchase@add_purchase');
Route::post('/purchase_list', 'purchase@purchase_list');
Route::post('/edit_purchase', 'purchase@edit_purchase');



Route::get('/test', 'purchase@test');






