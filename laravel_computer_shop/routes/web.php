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







