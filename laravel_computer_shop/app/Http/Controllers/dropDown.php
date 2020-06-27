<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use DB;

class dropDown extends Controller
{
    //
    function getWarehouse(){
        $wareHouse = 
        DB::table('warehouse')
        ->get();

        return $wareHouse;


    }


}
