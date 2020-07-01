<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use DB;
use App\People;
use App\Product;
use App\purchase_or_sell;
use App\sell_or_purchase_details;
use App\serial_number;
use App\invoice;

class test extends Controller
{
    function test()
    {
        // to gell all results
        $people = People::all();

        /* $people = People::where('name', 'riyad')
        ->take(10)
        ->get(); */

        // filters the null values
        /* $people = $people->reject(function ($p) {
            return $p->who_is_adding;
        }); */

        /*         People::chunk(2, function ($People) {
            foreach ($People as $P) {
                echo $P;
            }
        }); */

        /* foreach (People::cursor() as $People) {
            echo $People;
        } */

        $product = Product::all();
        // return $product;
        /* 
        $createdBy = Product::find(8)->createdBy;
        return $createdBy; */

        // $purchaseOrSell = purchase_or_sell::find(20)->invoice_number;
        // $purchaseOrSell = purchase_or_sell::find(20)->supplier;
        // $purchaseOrSell = purchase_or_sell::find(20)->supplier_id;
        // return $purchaseOrSell;
        /*         
        $purchaseOrSellDetails = sell_or_purchase_details::find(20)->product;
        return $purchaseOrSellDetails; */

        //hasMany exmaple
        // $invoice = invoice::find(10000)->serial_number;
        // return $invoice;

        //hasMany exmaple
        /* $invoice = invoice::find(10000)->transaction;
        return $invoice; */

        // $serial_number = serial_number::all();
        // great example
        // $serial_number = serial_number::find(20)->purchase->supplier; 
        // method name is important
        // return $serial_number;

        /* 
        $brand = Product::find(8)->brand_id;
        return $brand; */
        // return $t;

        // return $people;
    }
}
