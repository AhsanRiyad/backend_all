<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Transaction extends Model
{
    //
    // protected $table = 'purchase_or_sell';
    protected $primaryKey = 'transaction_id';
    // public $timestamps = true;
    // public $incrementing = false;

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

    public function invoice()
    {
        return $this->belongsTo('App\invoice', 'invoice_number', 'invoice_number');
    }

    public function people()
    {
        return $this->belongsTo('App\people', 'seller_or_customer_id', 'people_id');
    }

}
