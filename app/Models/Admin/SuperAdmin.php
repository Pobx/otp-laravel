<?php

namespace App\Models\Admin;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;
use Spatie\Permission\Traits\HasRoles;

class SuperAdmin extends Authenticatable
{
    use HasApiTokens, HasFactory, HasRoles, Notifiable; // เพิ่ม HasRoles ตรงนี้
    use Notifiable;

    protected $table = 'super_admin'; // ระบุชื่อตาราง

    protected $fillable = [
        'username',
        'password',
    ];

    protected $hidden = [
        'password',
        'remember_token',
    ];
}
