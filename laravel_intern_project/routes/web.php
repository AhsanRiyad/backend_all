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



Route::post('/getPrivacyData', 'privacy@getPrivacyData');
// Route::get('/getPrivacyData', 'privacy@getPrivacyData');

Route::post('/updatePrivacy', 'privacy@updatePrivacy');

Route::post('/getAllPeopleList', 'search@getAllPeopleList');


// Route::get('/getAllPeopleList', 'search@getAllPeopleList');


Route::post('/getPhotosForAll', 'photos@getPhotosForAll');
Route::get('/getPhotosForAll', 'photos@getPhotosForAll');
Route::post('/deletePhoto', 'photos@deletePhoto');



//auth
Route::get('/test', 'Authentications@test');
Route::post('/test', 'Authentications@test');



//users_info
Route::get('/get_data_update_request_list', 'users_info@get_data_update_request_list');
Route::post('/get_data_update_request_list', 'users_info@get_data_update_request_list');

Route::post('/get_new_user_request_list', 'users_info@get_new_user_request_list');

Route::post('/get_info_of_a_particular_user_with_promise', 'users_info@get_info_of_a_particular_user_with_promise');