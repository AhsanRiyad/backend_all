<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Brand extends Model
{
    //

    protected $table = 'brand';
    protected $primaryKey = 'brand_id';
    // protected $keyType = 'string';
    
    public $timestamps = false;
    // public $incrementing = true;

    // const CREATED_AT = 'createdAt';
    // const UPDATED_AT = 'updatedAt';

    /* public function products()
    {
        return $this->hasMany('App\Product', 'brand_id');
    }
 */


}
