<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class purchase_or_sell extends Model
{
    //
    //
    protected $table = 'purchase_or_sell';
    // protected $primaryKey = 'people_id';
    // public $timestamps = true;
    // public $incrementing = true;

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

    public function warehouse()
    {
        return $this->belongsTo('App\Warehouse', 'warehouse_id', 'id');
    }


    public function customer()
    {
        return $this->belongsTo('App\People', 'customer_id', 'people_id');
    }

    public function supplier()
    {
        return $this->belongsTo('App\People', 'supplier_id', 'people_id');
    }

    public function biller()
    {
        return $this->belongsTo('App\People', 'biller_id', 'people_id');
    }






}
