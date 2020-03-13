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


//auth
Route::get('/test', 'Authentications@test');


Route::post('/getPrivacyData', 'privacy@getPrivacyData');
// Route::get('/getPrivacyData', 'privacy@getPrivacyData');

Route::post('/updatePrivacy', 'privacy@updatePrivacy');

Route::post('/getAllPeopleList', 'search@getAllPeopleList');


// Route::get('/getAllPeopleList', 'search@getAllPeopleList');


Route::post('/getPhotosForAll', 'photos@getPhotosForAll');
Route::get('/getPhotosForAll', 'photos@getPhotosForAll');
Route::post('/deletePhoto', 'photos@deletePhoto');



