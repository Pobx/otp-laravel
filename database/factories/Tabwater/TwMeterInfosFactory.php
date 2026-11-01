<?php

namespace Database\Factories\Tabwater;

use App\Models\Tabwater\TwMeterInfos;
use Illuminate\Database\Eloquent\Factories\Factory;

class TwMeterInfosFactory extends Factory
{
    protected $model = TwMeterInfos::class;

    public function definition(): array
    {
        return [
            'meter_id' => fake()->unique()->numberBetween(1000, 99999),
            'org_id_fk' => 1,
            'meter_address' => fake()->address(),
            'user_id' => 1,
            'undertake_zone_id' => 1,
            'undertake_subzone_id' => 1,
            'acceptance_date' => now()->toDateString(),
            'recorder_id' => 1,
            'meternumber' => fake()->unique()->numerify('#####'),
            'metertype_id' => 1,
            'status' => 'active',
        ];
    }
}
