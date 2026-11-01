<?php

namespace Database\Factories\Tabwater;

use App\Models\Tabwater\TwInvoice;
use Illuminate\Database\Eloquent\Factories\Factory;

class TwInvoiceFactory extends Factory
{
    protected $model = TwInvoice::class;

    public function definition(): array
    {
        return [
            'inv_no' => 'INV-'.fake()->unique()->numerify('######'),
            'org_id_fk' => 1,
            'inv_period_id_fk' => 1,
            'meter_id_fk' => 'MTR-0001',
            'lastmeter' => 100,
            'currentmeter' => 110,
            'water_used' => 10,
            'reserve_meter' => 0.00,
            'inv_type' => 'u',
            'paid' => 100.00,
            'vat' => 7.00,
            'totalpaid' => 107.00,
            'previous_balance' => 0.00,
            'status' => 'invoice',
            'recorder_id' => 1,
        ];
    }
}
