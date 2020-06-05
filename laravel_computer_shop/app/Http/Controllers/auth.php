<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use DB;

class auth extends Controller
{
    //
    function signin(Request $request){

        $isUserExists = 
        DB::table('users_registration')
        ->where([ ['email' , '=' , $request->email] , ['password', '=',  md5($request->password) ]  ])
        ->count();
        


        if($isUserExists == 1){
            return DB::table('users_registration')
            ->where([ ['email', '=', $request->email] ])
            ->get();
        }

        // return $isUserExists;
        abort(404, 'Not Found');
    }


}
