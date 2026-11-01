<?php

namespace App\Imports;

use App\Models\EmissionFactor;
use Illuminate\Database\Eloquent\Model;
use Maatwebsite\Excel\Concerns\ToModel;
use Maatwebsite\Excel\Concerns\WithHeadingRow;

class EFImport implements ToModel, WithHeadingRow
{
    /**
     * @return Model|null
     */
    public function model(array $row)
    {
        return new EmissionFactor([
            'material_name' => $row['material'],
            'unit' => 'kg',
            // แปลงค่าจาก Tonnes เป็น kg ทันที
            'ef_value' => $row['primary_material_production'] / 1000,
            'source' => 'DEFRA 2025',
        ]);
    }
}
