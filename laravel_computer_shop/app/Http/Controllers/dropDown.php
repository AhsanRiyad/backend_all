<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use DB;
use App\Category;
use App\warehouse;
use App\brand;
use App\people;

class dropDown extends Controller
{
    //
    function getWarehouse(){
       /*  $categories = 
        DB::table('category')
        ->get(); */
        $warehouse = warehouse::all();
        return $warehouse;
    }

    function getBrands(){
       /*  $categories = 
        DB::table('category')
        ->get(); */
        $Brand = Brand::all();
        return $Brand;
    }

    function getCategories(){
        $categories = category::all();
        return $categories;
    }

    function getSupplier(){
        $suplier = 
        people::where('type', 'supplier')->get();
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
