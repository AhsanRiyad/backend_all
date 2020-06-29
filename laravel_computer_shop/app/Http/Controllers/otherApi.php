<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use DB;

class otherApi extends Controller
{
    //
    function getAllSerials()
    {
        $serials = DB::table('serial_number')->get();
        return $serials;
    }
}
