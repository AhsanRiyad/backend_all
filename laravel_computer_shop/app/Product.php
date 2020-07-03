<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Product extends Model
{
    //
    protected $table = 'products';
    protected $primaryKey = 'p_id';
    public $timestamps = true;
    public $incrementing = true;

    const CREATED_AT = 'createdAt';
    const UPDATED_AT = 'updatedAt';

    public function brand()
    {
        // return $this->belongsTo('App\Brand', 'brand_id', 'brand_id');
        return $this->hasOne('App\Brand', 'brand_id', 'brand_id');
    }

    public function category()
    {
        return $this->belongsTo('App\Category', 'category_id', 'category_id');
    }

    public function createdBy()
    {
        return $this->belongsTo('App\People', 'createdBy', 'people_id');
    }

    public function updatedBy()
    {
        return $this->belongsTo('App\People', 'updatedBy', 'people_id');
    }
}
