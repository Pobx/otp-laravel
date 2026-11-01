<?php

namespace Database\Factories\KeptKaya;

use App\Models\KeptKaya\KpTbankItems;
use Illuminate\Database\Eloquent\Factories\Factory;

class KpTbankItemsFactory extends Factory
{
    protected $model = KpTbankItems::class;

    public function definition(): array
    {
        return [
            'kp_itemscode' => fake()->unique()->numerify('ITEM-####'),
            'kp_itemsname' => fake()->word(),
            'org_id_fk' => 1,
            'unit_bank_idfk' => 1,
            'unit_kiosk_idfk' => 1,
            'kp_items_group_idfk' => 1,
            'status' => 'active',
            'deleted' => 0,
        ];
    }
}
