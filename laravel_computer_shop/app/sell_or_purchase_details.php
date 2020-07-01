<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class sell_or_purchase_details extends Model
{
    //
    //
    //
    protected $table = 'sell_or_purchase_details';
    protected $primaryKey = 'spd_id';
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

    public function product()
    {
        return $this->belongsTo('App\Product', 'product_id', 'p_id');
    }

    public function purchase_or_sell()
    {
        return $this->belongsTo('App\purchase_or_sell', 'invoice_number', 'invoice_number');
    }

    
}
