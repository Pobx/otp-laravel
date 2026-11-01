<?php

namespace Database\Factories\KeptKaya;

use App\Models\KeptKaya\KpPurchaseTransaction;
use Illuminate\Database\Eloquent\Factories\Factory;

class KpPurchaseTransactionFactory extends Factory
{
    protected $model = KpPurchaseTransaction::class;

    public function definition(): array
    {
        return [
            'org_id_fk' => 1,
            'kp_u_trans_no' => 'TRX-'.fake()->unique()->numerify('######'),
            'user_id' => 1,
            'transaction_date' => now(),
            'total_weight' => 5.5,
            'total_amount' => 55.00,
            'total_points' => 55,
            'status' => 'completed',
            'cash_back' => 1,
        ];
    }
}
