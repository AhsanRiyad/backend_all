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
Route::get('/getPrivacyData', 'privacy@getPrivacyData');


Route::get('/test_privacy', 'privacy@getPrivacyData');
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


//children
Route::post('/updateChildren', 'users_info@updateChildren');
Route::post('/getChildren', 'users_info@getChildren');


//forum
Route::post('/getFacebookAndForumMemeberShipInfo', 'users_info@getFacebookAndForumMemeberShipInfo');
Route::post('/updateForum', 'users_info@updateForum');


// Route::get('/test_PDF', 'users_info@test_PDF');
Route::post('/download_PDF', 'users_info@download_PDF');


Route::get('/export_user_data', 'users_info@export_user_data');
Route::post('/export_user_data', 'users_info@export_user_data');
Route::post('/import_user_data', 'users_info@import_user_data');

Route::post('/user_registration', 'users_info@user_registration');
Route::get('/test_users_info', 'users_info@test');

//reset password
Route::post('/reset_password', 'users_info@reset_password');


//upload file
Route::post('/photo_upload', 'file_uploads@photo_upload');
Route::get('/photo_upload', 'file_uploads@photo_upload');


Route::post('/detele_photo', 'file_uploads@detele_photo');






