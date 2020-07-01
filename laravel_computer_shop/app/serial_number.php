<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class serial_number extends Model
{
    //
    protected $table = 'serial_number';
    protected $primaryKey = 'serial_id';
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

    public function purchase()
    {
        return $this->belongsTo('App\Invoice', 'invoice_number_purchase', 'invoice_number');
    }

    public function sell()
    {
        return $this->belongsTo('App\Invoice', 'invoice_number_sell', 'invoice_number');
    }

    
}
