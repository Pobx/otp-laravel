<?php

namespace Database\Factories\Tabwater;

use App\Models\Tabwater\MeterTypeRateConfig;
use Illuminate\Database\Eloquent\Factories\Factory;

class MeterTypeRateConfigFactory extends Factory
{
    protected $model = MeterTypeRateConfig::class;

    public function definition(): array
    {
        return [
            'org_id_fk' => 1,
            'meter_type_id_fk' => 1,
            'pricing_type_id' => 1,
            'min_usage_charge' => 50.00,
            'charge_min_only_zero_use' => 0,
            'vat' => 7.00,
            'fixed_rate_per_unit' => 10.00,
            'effective_date' => now()->subMonth(),
            'is_active' => 1,
        ];
    }
}
