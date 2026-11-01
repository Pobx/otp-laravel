<?php

namespace App\Models;

use App\Traits\BelongsToOrganization;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Kiosk extends Model
{
    use BelongsToOrganization;
    use HasFactory;

    // ระบุว่า id ไม่ใช่ auto-increment และเป็น string
    protected $primaryKey = 'id';

    public $incrementing = false;

    protected $keyType = 'string';

    protected $fillable = [
        'id',
        'org_id_fk',
        'name',
        'location',
        'lat',
        'lng',
        'status',
        'total_waste_count',
        'last_online_at',
    ];

    public function sensors()
    {
        return $this->hasMany(KioskSensor::class);
    }

    public function waste_types() {}
}
