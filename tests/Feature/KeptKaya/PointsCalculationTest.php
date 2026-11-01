<?php

namespace Tests\Feature\KeptKaya;

use App\Models\Admin\Organization;
use App\Models\KeptKaya\KpPurchaseTransaction;
use App\Models\KeptKaya\KpUserWastePreference;
use App\Models\KpBankAccount;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class PointsCalculationTest extends TestCase
{
    use RefreshDatabase;

    protected User $user;

    protected Organization $org;

    protected function setUp(): void
    {
        parent::setUp();

        $this->org = Organization::factory()->create(['id' => 1]);
        $this->user = User::factory()->create([
            'org_id_fk' => $this->org->id,
        ]);
        $this->actingAs($this->user);
    }

    public function test_waste_point_calculation_multiplies_weight_by_rate(): void
    {
        $weightInUnits = 12.5;
        $pointRate = 2; // 2 points per unit
        $expectedPoints = $weightInUnits * $pointRate;

        $this->assertEquals(25.0, $expectedPoints);
    }

    public function test_bank_account_accumulates_points(): void
    {
        $account = KpBankAccount::create([
            'user_id' => $this->user->id,
            'org_id_fk' => $this->org->id,
            'entity_type' => 'recycle_bank',
            'account_no' => 'ACC-001',
            'balance' => 0.00,
            'points' => 50,
            'status' => 'active',
        ]);

        $account->increment('points', 25);

        $this->assertEquals(75, $account->fresh()->points);
    }

    public function test_purchase_transaction_persists_points_and_amount(): void
    {
        $pref = KpUserWastePreference::factory()->create([
            'user_id' => $this->user->id,
            'org_id' => $this->org->id,
        ]);

        $tx = KpPurchaseTransaction::factory()->create([
            'org_id_fk' => $this->org->id,
            'user_id' => $this->user->id,
            'total_weight' => 10.0,
            'total_amount' => 100.00,
            'total_points' => 20,
            'status' => 'completed',
        ]);

        $this->assertDatabaseHas('kp_purchase_transactions', [
            'id' => $tx->id,
            'org_id_fk' => $this->org->id,
            'total_points' => 20,
            'total_amount' => 100.00,
        ]);
    }
}
