<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Invoice extends Model
{
    //
    protected $table = 'purchase_or_sell';
    protected $primaryKey = 'invoice_number';
    // public $timestamps = true;
    public $incrementing = false;

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

    public function serial_number_purchase()
    {
        return $this->hasMany('App\serial_number', 'invoice_number_purchase');
    }

    public function serial_number_sell()
    {
        return $this->hasMany('App\serial_number', 'invoice_number_sell');
    }

    public function transaction()
    {
        return $this->hasMany('App\transaction', 'invoice_number');
    }
}
