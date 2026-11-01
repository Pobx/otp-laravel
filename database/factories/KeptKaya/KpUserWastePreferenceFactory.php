<?php

namespace Database\Factories\KeptKaya;

use App\Models\KeptKaya\KpUserWastePreference;
use Illuminate\Database\Eloquent\Factories\Factory;

class KpUserWastePreferenceFactory extends Factory
{
    protected $model = KpUserWastePreference::class;

    public function definition(): array
    {
        return [
            'org_id' => 1,
            'user_id' => 1,
            'is_annual_collection' => 1,
            'is_recycle_bank' => 1,
            'address' => fake()->address(),
            'zone_id' => 1,
            'subzone_id' => 1,
            'tambon_code' => 1,
            'district_code' => 1,
            'province_code' => 1,
        ];
    }
}
