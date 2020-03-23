<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use DB;
use PDF;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Crypt;

// use App;

class users_info extends Controller
{
    //

    function get_data_update_request_list(Request $req){

    	$request_list = 
    	DB::table('all_info_together')
    	->where([
    		['change_request' , '=' , 'requested']
    	])
    	->select(
    		DB::raw("concat(first_name, ' ' , last_name) as full_name"),
    		'email as Email',
    		'change_request_time',
    	)
    	->get();


    	return $request_list;

    }
    function get_new_user_request_list(Request $req){

        $new_user_list = 
        DB::table('all_info_together')
        ->where([
            ['status' , '=' , 'new']
        ])
        ->select(
            DB::raw("concat(first_name, ' ' , last_name) as full_name"),
            'email as Email',
            'registration_date',
        )
        ->get();


        return $new_user_list;

    }
    function get_info_of_a_particular_user_with_promise(Request $req){

        $users_info = 
        DB::table('all_info_together')
        ->where([
            ['email' , '=' , $req->email]
        ])
        ->select(

            "first_name as First Name" ,
            "last_name as Last Name" ,
            "name_bangla as Bangla Name" ,
            "institution_id as institution Id" ,
            "mobile as Mobile",
            "nid_or_passport as NID/Passport" ,
            "blood_group as Blood Group" ,
            "religion as Religion"  ,
            "date_of_birth as Date Of Birth",
            "fathers_name as Father's Name",
            "mother_name as Mother's Name" ,
            "spouse_name as Spouse's Name" ,
            "number_of_children as Number Of Children" ,
            "profession as Profession" ,
            "institution as Workplace" ,
            "designation as Designation" ,
            "present_line1 as Present Address Line 1" ,
            "present_post_office_name as Present Post Office Name" ,
            "present_post_code as Present Post Code" ,
            "present_police_station as Present Police Station" ,
            "present_district as Present District" ,
            "present_country as Present Country" ,  
            "parmanent_line1 as Permanent Address Line 1" ,
            "parmanent_post_office_name as Permanent Post Office Name" ,
            "parmanent_post_code as Permanent Post Code" ,
            "parmanent_police_station as Permanent Police Station" ,
            "parmanent_district as Permanent District" ,
            "parmanent_country as Permanent Country"

        )
        ->get();

        return $users_info;
    }

    function updateChildren(Request $req){


       /* $affected = DB::table('childrens_info')
        ->updateOrInsert(
            [ 'email' => 'riyad298@gmail.com' , 'no' => 2 ],
            [ 'name' => 'riyad' ]
        );
*/

        $req->purpose == 'updateOrInsert' ? 
        DB::table('childrens_info')
        ->updateOrInsert(
            ['email' => $req->email,  'no' => $req->no ],
            $req->childrensInfo
        ) : 
        DB::table('childrens_info')
        ->where([ 
            ['email' , '=' , $req->email ],
            [ 'no' , '='  , $req->no ]
        ])
        ->delete()
        ;



        // var_dump($req->childrensInfo);
        // return $req;
/*
        if( $req->purpose == 'insert' ){

            $insertOrNot = 
            DB::table('childrens_info')
            ->select(DB::raw('count(*) as c'))
            ->where([
                ['email', '=' , $req->childrensInfo['email'] ],
                ['no', '=' , $req->childrensInfo['no'] ],
            ])
            ->get();

            $insertOrNot[0]->c == 0 ? DB::table('childrens_info')->insert($req->childrensInfo) : '';            

        }else if( $req->purpose == 'update' ){

            DB::table('childrens_info')
            ->update()

        }


        return $insertOrNot[0]->c;*/
        // print_r($req->childrensInfo);

/*
        DB::table('childrens_info')->insert(
                $req->childrensInfo            
        );
*/

        // return $req->childrensInfo['email'];

    }
    function getChildren(Request $req){

        $children =
        DB::table('childrens_info')
        ->where('email' , '=' , $req->email)
        ->get();


        return $children; 
        // return 'okay'; 

    }

    function getFacebookAndForumMemeberShipInfo(Request $req){

        $facebook_personal =
        DB::table('social_network')
        ->where([
            ['email' , '=' , $req->email],
            ['type' , '=' , 'personal']
        ])
        ->get();

        $forum_info = 
        DB::table('social_network')
        ->where([
            ['email' , '=' , $req->email],
            ['type' , '=' , 'forum']
        ])
        ->get();


        $social_network_info['facebook_personal'] = $facebook_personal;
        $social_network_info['forum_info'] = $forum_info;


        return $social_network_info;

    }

    function updateForum(Request $req){


        $req->purpose == 'updateOrInsert' ? 
        DB::table('social_network')
        ->updateOrInsert(
            [
                'email' => $req->email,
                'media_name' => $req->media_name,
                'type' => $req->type,
            ],
            $req->forum_info
        ) : 
        DB::table('social_network')
        ->where([ 
            ['email' , '=' , $req->email ],
            [ 'media_name', '=' , $req->media_name ],
            [ 'type', '=' , $req->type ]
        ])
        ->delete()
        ;





    }

    function download_PDF(Request $req){

/*
        $pdf = \App::make('dompdf.wrapper');
        $pdf->loadHTML('<h1>Test</h1>');
        return $pdf->stream();
*/

        // SELECT name FROM `files` WHERE TIME_TO_SEC( timediff( sysdate() , timestamp ) )/60 < 15
        
        //get the files to delete
       /* $file_names = 
        DB::table('files')
        ->select('name')
        ->where([
            [ DB::raw('TIME_TO_SEC( timediff( sysdate() , timestamp ) )/ 60') , '>' , 1 ]
        ])
        ->get();*/

        //delete file names from database
       /* DB::table('files')
        ->where([
            [ DB::raw('TIME_TO_SEC( timediff( sysdate() , timestamp ) )/ 60') , '>' , 1 ]
        ])
        ->delete();*/


        //making an array in php to delete from the server
        /*$filesToDelete;
        $i = 0;
        foreach ($file_names as $key => $value) {
            # code...

            $filesToDelete[$i++] = $value->name;

            // echo $value->name.'<br/>';

        }*/
        // print_r($filesToDelete);


        //deleting files from the server
        // Storage::disk('public')->delete($filesToDelete);



/*
        $rand_number = rand(10000,99999);
        $name = $rand_number.'.pdf';
        $pdf = PDF::loadView('user_print_pdf');
        $pdf->save('storage/'.$name);


        DB::table('files')
        ->insert(['name' => $name , 'timestamp' => DB::raw('sysdate()')]);

        return 'Okay';
*/

        // $field_name = 
        // DB::select("SELECT name FROM `files` WHERE TIME_TO_SEC( timediff( sysdate() , timestamp ) )/60 > 15");
        // print_r($field_name);

        // $url = Storage::url('users_info.pdf');

        // return $url;

        // echo asset('storage/users_info.pdf');

        // return Storage::download('storage\app/public/users_info.pdf');

        // $encrypted = Crypt::encryptString('Hello world.');

        // $decrypted = Crypt::decryptString($encrypted);
        

        // $pdf->save($encrypted.'.'.'pdf');



        $data['users_info'] = $req->users_info;
        $pdf = PDF::loadView('user_print_pdf' , $data );
        $pdf->save('storage/users_info.pdf');
        return $pdf->stream('users_info.pdf');
        
        

        // echo asset('storage/users_info.pdf');

        // return $req->users_info[0]['alias_field_name'];

        // return $req->users_info;

        // Storage::disk('public')->delete('users_info.pdf');

        // return $encrypted;

        // return $pdf->download('users_info.pdf');

        // return storage_path('app/public');


        // return 'got the result';

    }

    function export_user_data(Request $req){

        $users_info_export_import;
        $i=0;

        $email_list = 
        DB::table('users_registration')
        ->select('email')
        ->get();


        $registration_info = 
        DB::table('users_registration')
        ->where('email' , '=' , 'riyad298@gmail.com')
        ->get();
        
        // return $registration_info;
        

        // $email_list = json_decode($email_list0);     

        foreach ($email_list as $key => $value) {

            $users_info_export_import[$i]['email'] = $value->email ;

            // echo $value->email;


            $registration_info = 
            DB::table('users_registration')
            ->where('email' , '=' , $value->email)
            ->get();
            $users_info_export_import[$i]['users_registration'] = $registration_info ;

            $users_info = 
            DB::table('users_info')
            ->where('email' , '=' , $value->email)
            ->get();
            $users_info_export_import[$i]['users_info'] = $users_info ;


            $users_address = 
            DB::table('users_address')
            ->where('email' , '=' , $value->email)
            ->get();
            $users_info_export_import[$i]['users_address'] = $users_address ;

            $verification_info = 
            DB::table('verification_info')
            ->where('email' , '=' , $value->email)
            ->get();
            $users_info_export_import[$i]['verification_info'] = $verification_info ;

            $childrens_info = 
            DB::table('childrens_info')
            ->where('email' , '=' , $value->email)
            ->get();
            $users_info_export_import[$i]['childrens_info'] = $childrens_info ;

            $social_network = 
            DB::table('social_network')
            ->where('email' , '=' , $value->email)
            ->get();
            $users_info_export_import[$i]['social_network'] = $social_network ;


            ++$i;

        }


        $final_data = json_encode($users_info_export_import);
        Storage::disk('local')->put('public/file.json', json_encode($users_info_export_import) );

        return $users_info_export_import;

        $get_php_data = json_decode($final_data);

        // print_r($get_php_data[1]->users_registration[0]);

        // return $get_php_data[1]->users_registration;

        // return $email_list;

        // dd($get_php_data);

        DB::table('users_registration')
        ->delete();

        DB::table('users_info')
        ->delete();

        DB::table('users_address')
        ->delete();

        DB::table('verification_info')
        ->delete();


        DB::table('childrens_info')
        ->delete();

        DB::table('social_network')
        ->delete();


        foreach ($get_php_data as $key => $value) {
            # code...

            $array = (array) $value;

            // print_r($value);

            //working email
            // print_r($array['email']);

            
            //working users_registration
            // print_r( (array)  $array['users_registration'][0]);
            $insertToDB =  (array)  $array['users_registration'][0];
            DB::table('users_registration')
            ->insert(
             $insertToDB
         );


            //working users_info
            // print_r( (array)  $array['users_info'][0]);
            $insertToDB =  (array)  $array['users_info'][0];
            DB::table('users_info')
            ->insert(
             $insertToDB
         );



            //working users_address
            // print_r( (array)  $array['users_address'][0]);
            $insertToDB =  (array)  $array['users_address'][0];
            DB::table('users_address')
            ->insert(
             $insertToDB
         );




            //working verification_info
            // print_r( (array)  $array['verification_info'][0]);
            $insertToDB =  (array)  $array['verification_info'][0];
            DB::table('verification_info')
            ->insert(
             $insertToDB
         );





            foreach ($array['childrens_info'] as $key_chi => $value_chi) {
                # code...

                //working childrens_info
                print_r( (array) $value_chi );


                $insertToDB = (array) $value_chi ;
                DB::table('childrens_info')
                ->insert(
                 $insertToDB
             );


                echo '<br/><br/>';
            }



            foreach ($array['social_network'] as $key_chi => $value_chi) {
                # code...

              //working social_network
              print_r( (array) $value_chi );

              $insertToDB = (array) $value_chi ;
              DB::table('social_network')
              ->insert(
                 $insertToDB
             );

              echo '<br/><br/>';
          }


          echo '<br/><br/>';




      }




/*
        $array = (array) $get_php_data[0]->users_registration[0];
        DB::table('users_registration')
        ->delete();
        DB::table('users_registration')
        ->insert(
           $array
        );
        dd($array);*/

       /* foreach ( $get_php_data[1]->users_registration[0] as $key => $value ) {
            # code...


            echo $key. '=>' . $value ;
        }*/


    }


    function import_user_data(Request $req){

        // return $req->file('user_import_data_file');


        $path = $req->file('user_import_data_file')->storeAs(
            'import_data' , 'user_import_data_file.json' );

        $contents = Storage::get('import_data/user_import_data_file.json');


        // return $contents;



        $get_php_data = json_decode($contents);

        // print_r($get_php_data[1]->users_registration[0]);

        // return $get_php_data[1]->users_registration;

        // return $email_list;

        // dd($get_php_data);

        DB::table('users_registration')
        ->delete();

        DB::table('users_info')
        ->delete();

        DB::table('users_address')
        ->delete();

        DB::table('verification_info')
        ->delete();


        DB::table('childrens_info')
        ->delete();

        DB::table('social_network')
        ->delete();

        DB::table('user_uploads')
        ->delete();



        DB::table('privacy')
        ->delete();



        DB::table('data_log')
        ->delete();




        foreach ($get_php_data as $key => $value) {
            # code...

            $array = (array) $value;

            // print_r($value);

            //working email
            // print_r($array['email']);

            DB::table('data_log')
            ->insert(
                
                [ 'email' =>  $array['email'] ]

                    );


            DB::table('privacy')
            ->insert(
                
                [ 'email' =>  $array['email'] ]

                    );


            DB::table('user_uploads')
            ->insert(
                
                [ 'email' =>  $array['email'] , 'recent_photo' => 'not_set' , 'old_photo' => 'not_set' ]

                    );


            //working users_registration
            // print_r( (array)  $array['users_registration'][0]);
            $insertToDB =  (array)  $array['users_registration'][0];
            DB::table('users_registration')
            ->insert(
             $insertToDB
         );


            //working users_info
            // print_r( (array)  $array['users_info'][0]);
            $insertToDB =  (array)  $array['users_info'][0];
            DB::table('users_info')
            ->insert(
             $insertToDB
         );



            //working users_address
            // print_r( (array)  $array['users_address'][0]);
            $insertToDB =  (array)  $array['users_address'][0];
            DB::table('users_address')
            ->insert(
             $insertToDB
         );




            //working verification_info
            // print_r( (array)  $array['verification_info'][0]);
            $insertToDB =  (array)  $array['verification_info'][0];
            DB::table('verification_info')
            ->insert(
             $insertToDB
         );





            foreach ($array['childrens_info'] as $key_chi => $value_chi) {
                # code...

                //working childrens_info
                // print_r( (array) $value_chi );


                $insertToDB = (array) $value_chi ;
                DB::table('childrens_info')
                ->insert(
                 $insertToDB
             );


                // echo '<br/><br/>';
            }



            foreach ($array['social_network'] as $key_chi => $value_chi) {
                # code...

              //working social_network
              // print_r( (array) $value_chi );

              $insertToDB = (array) $value_chi ;
              DB::table('social_network')
              ->insert(
                 $insertToDB
             );

              // echo '<br/><br/>';
          }


          // echo '<br/><br/>';



      }
      
      return 'successful';

  }

  function reset_password(Request $req){



    DB::table('all_info_together')
    ->where('email' , $req->email)
    ->update( ['password' => md5('123456') ]);



    return 'ok';






  }



}
