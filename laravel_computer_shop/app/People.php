<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class People extends Model
{
    //
    protected $table = 'people';
    protected $primaryKey = 'people_id';
    public $timestamps = true;
    public $incrementing = true;

    const CREATED_AT = 'createdAt';
    const UPDATED_AT = 'updatedAt';

    /* public function products()
    {
        return $this->hasMany('App\Product', 'createdBy');
    } */

    public function createdBy()
    {
        return $this->belongsTo('App\People', 'createdBy', 'people_id');
    }

    public function updatedBy()
    {
        return $this->belongsTo('App\People', 'updatedBy', 'people_id');
    }

    public function transaction()
    {
        return $this->hasMany('App\transaction', 'seller_or_customer_id');
    }


}
