<?php

namespace App\Models;

use App\Traits\BelongsToOrganization;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class InvUnit extends Model
{
    use BelongsToOrganization;
    use HasFactory;

    protected $table = 'inv_units';

    protected $fillable = ['org_id_fk', 'name'];
}
