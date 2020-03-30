<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use DB;
use Illuminate\Support\Facades\Storage;


class file_uploads extends Controller
{
    //
	function photo_upload(Request $req){


		// $path = $req->file('photo')->store('storage');

		// $path = Storage::putFile('storage/', $req->file('photo'));
		$path = '';
		$table_name = '';
		$old_file_name='';

	/*	$req->purpose == 'group' ? 
		( $path = 'storage/photo/group' , $table_name = 'user_photos' , $field_name = 'group_photo' ) :

		$req->purpose == 'recent' ? 
		( $path = 'storage/photo/recent' , $table_name = 'user_photos' , $field_name = 'recent_photo' ) :

		$req->purpose == 'old' ?
		( $path = 'storage/photo/old' , $table_name = 'user_photos' , $field_name = 'old_photo' )
*/

		// return $req->purpose;


		switch ($req->purpose) {
			
			case 'old':
				# code...
			$path = 'storage/photo/old' ;
			$table_name = 'user_uploads';
			$field_name = 'old_photo';
			
			//getting old photo name from db
			$old =
			DB::table($table_name)
			->where([
				[ 'email', '=', $req->email ]
			])
			->select($field_name)
			->get();
			
			$old_file_name = $old[0]->old_photo ; 
			
			Storage::disk('public')->delete($old_file_name);
			
			$path = $req->file('photo')->store(
				'storage/photo/'.$req->purpose /*path name*/  ,
				'public' /*disk name*/ 
			);

			DB::table($table_name)
			->where([
				[ 'email', '=', $req->email ]
			])
			->update([ $field_name => $path ]);

			break;
			
			case 'recent':
				# code...
			$path = 'storage/photo/recent' ;
			$table_name = 'user_uploads';
			$field_name = 'recent_photo';
			$old =
			DB::table($table_name)
			->where([
				[ 'email', '=', $req->email ]
			])
			->select($field_name)
			->get();
			$old_file_name = $old[0]->recent_photo ; 
			Storage::disk('public')->delete($old_file_name);

			$path = $req->file('photo')->store(
				'storage/photo/'.$req->purpose /*path name*/  ,
				'public' /*disk name*/ 
			);

			DB::table($table_name)
			->where([
				[ 'email', '=', $req->email ]
			])
			->update([ $field_name => $path ]);





			break;

			case 'group':
				# code...
			$path = 'storage/photo/group' ;
			$table_name = 'user_photos';
			$field_name = 'group_photo';

			$path = $req->file('photo')->store(
				'storage/photo/'.$req->purpose /*path name*/  ,
				'public' /*disk name*/ 
			);


			DB::table($table_name)
			->insert(
				[ 
					'email' =>  $req->email  , 
					$field_name => $path 
				]
			);


			break;

			default:
				# code...
			break;
		}




		// return $old[0]->recent_photo;
		// return $old_file_name;

		//get the extension
		// $extension = $req->file('photo')->extension();
		
		//save to the folder
	/*	$path = $req->file('photo')->store(
			'storage/photo/'.$req->purpose  ,
			'public' 
		);*/

		// $path ;
		// return asset( $path );
		// return $path;
		// $url = Storage::url($path); // working




		return 'success';

		// return $extension;





	}


	function detele_photo(Request $request){

		DB::table( 'user_photos' )->where( 'group_photo', '=', $request->photo_path )->delete();

		Storage::disk('public')->delete($request->photo_path);

		return 'success';

	}





}
