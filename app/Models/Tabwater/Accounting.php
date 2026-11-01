<?php

namespace App\Models\Tabwater;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Accounting extends Model
{
    protected $guarded = ['id'];

    use HasFactory;

    protected $table = 'accounting';
}
