<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class ZonesSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $zones = [
            'หมู่ 1', 'หมู่ 2', 'หมู่ 3', 'หมู่ 4', 'หมู่ 5', 'หมู่ 6', 'หมู่ 7', 'หมู่ 8', 'หมู่ 9', 'หมู่ 10',
            'หมู่ 11', 'หมู่ 12', 'หมู่ 13', 'หมู่ 14', 'หมู่ 15', 'หมู่ 16', 'หมู่ 17', 'หมู่ 18', 'หมู่ 19',
        ];

        foreach ($zones as $idx => $name) {
            DB::table('zones')->updateOrInsert(
                ['id' => $idx + 1],
                [
                    'org_id_fk' => 1,
                    'zone_name' => $name,
                    'location' => 'ตำบลห้องแซง อำเภอเลิงนกทา จังหวัดยโสธร',
                    'status' => 'active',
                    'tambon_id' => '350805',
                    'lat' => 0,
                    'long' => 0,
                ]
            );
        }
    }
}
