<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Category extends Model
{
    //


    protected $table = 'category';
    protected $primaryKey = 'category_id';
    // protected $keyType = 'string';

    public $timestamps = false;
    // public $incrementing = true;

    // const CREATED_AT = 'createdAt';
    // const UPDATED_AT = 'updatedAt';

    /* public function products()
    {
        return $this->hasMany('App\Product', 'category_id');
    } */


}
