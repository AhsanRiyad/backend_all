<?php 



    
        // pdf example without alias
        $pdf = \App::make('dompdf.wrapper');
        $pdf->loadHTML('<h1>Test</h1>');
        return $pdf->stream();


        // SELECT name FROM `files` WHERE TIME_TO_SEC( timediff( sysdate() , timestamp ) )/60 < 15
        
        //get the files to delete
        $file_names = 
        DB::table('files')
        ->select('name')
        ->where([
            [ DB::raw('TIME_TO_SEC( timediff( sysdate() , timestamp ) )/ 60') , '>' , 1 ]
        ])
        ->get();
       
        //delete file names from database
        DB::table('files')
        ->where([
            [ DB::raw('TIME_TO_SEC( timediff( sysdate() , timestamp ) )/ 60') , '>' , 1 ]
        ])
        ->delete();


        // making an array in php to delete from the server
        $filesToDelete;
        $i = 0;
        foreach ($file_names as $key => $value) {
            # code...

            $filesToDelete[$i++] = $value->name;

            // echo $value->name.'<br/>';

        }

        // checking the array
        print_r($filesToDelete);

        //deleting files from the server
        Storage::disk('public')->delete($filesToDelete);



        //save file to local storage and store the file name in the database
        $rand_number = rand(10000,99999);
        $name = $rand_number.'.pdf';
        $pdf = PDF::loadView('user_print_pdf');
        $pdf->save('storage/'.$name);


        DB::table('files')
        ->insert(['name' => $name , 'timestamp' => DB::raw('sysdate()')]);

        return 'Okay';


        // $field_name = 
        // DB::select("SELECT name FROM `files` WHERE TIME_TO_SEC( timediff( sysdate() , timestamp ) )/60 > 15");
        // print_r($field_name);

        // $url = Storage::url('users_info.pdf');

        // return $url;

        // echo asset('storage/users_info.pdf');

        // return Storage::download('storage\app/public/users_info.pdf');

        


        


        // return $req->users_info[0]['alias_field_name'];

        // return $req->users_info;


        // return $encrypted;

        // return storage_path('app/public');


        //get file download link , for public file
        echo asset('storage/users_info.pdf');

        //data tested for axios
        return $req->users_info[0]['alias_field_name'];

        // final working code //sending data to view
        $data['users_info'] = $req->users_info;
        $pdf = PDF::loadView('user_print_pdf' , $data );
        $pdf->save('storage/users_info.pdf');
        return $pdf->stream('users_info.pdf');
        
        //pdf download link/direct download
        return $pdf->download('users_info.pdf');

        //delete file from laravel storage
        Storage::disk('public')->delete('users_info.pdf');

        //encryption decryption examples
        $encrypted = Crypt::encryptString('Hello world.');
        $decrypted = Crypt::decryptString($encrypted);
        $pdf->save($encrypted.'.'.'pdf');

 ?>