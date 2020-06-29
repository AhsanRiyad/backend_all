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

    function getSupplier(){
        $suplier = 
        DB::table('people')
        ->where('type', 'supplier')
        ->get();

        return $suplier;
    }

    function getProducts(){
        $products = 
        DB::table('products')
        ->select(
            'p_id as id',
            'product_name as name',
            'product_code as code',
            'brand_id',
            'category_id',
            'product_unit as unit',
            'selling_quantity as quanitiy',
            'purchase_cost as price',
            'warranty_days as warranty',
            'having_serial'
        )
        ->get();
        return $products;
    }


}
