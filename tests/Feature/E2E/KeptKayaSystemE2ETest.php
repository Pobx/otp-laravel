<?php

namespace Tests\Feature\E2E;

use App\Models\KeptKaya\KpPurchaseTransaction;
use App\Models\KeptKaya\KpUserWastePreference;
use App\Models\KpBankAccount;
use App\Models\User;
use Database\Seeders\DatabaseSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class KeptKayaSystemE2ETest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();

        $this->seed(DatabaseSeeder::class);
    }

    public function test_keptkaya_dashboard_accessible_by_recycle_staff(): void
    {
        $staff = User::where('username', 'recycle_staff')->first();
        $this->actingAs($staff);

        $response = $this->get(route('keptkayas.dashboard'));
        $response->assertOk();
        $response->assertViewIs('keptkayas.dashboard_recycle');
    }

    public function test_korkor3_waste_report_and_export(): void
    {
        $admin = User::where('username', 'admin')->first();
        $this->actingAs($admin);

        $indexResponse = $this->get(route('keptkayas.korkor3.index'));
        $indexResponse->assertOk();
        $indexResponse->assertViewIs('keptkayas.korkor3.index');

        $exportResponse = $this->get(route('keptkayas.korkor3.export'));
        $exportResponse->assertOk();
    }

    public function test_member_shop_accessible_for_registered_user(): void
    {
        $user = User::where('username', 'citizen')->first();

        $pref = KpUserWastePreference::factory()->create([
            'user_id' => $user->id,
            'org_id' => 1,
            'is_recycle_bank' => 1,
        ]);

        $account = KpBankAccount::create([
            'user_id' => $user->id,
            'org_id_fk' => 1,
            'entity_type' => 'recycle_bank',
            'account_no' => 'RB-10001',
            'balance' => 150.00,
            'points' => 300,
            'status' => 'active',
        ]);

        $this->actingAs($user);

        $response = $this->get(route('keptkayas.shop.index'));
        $response->assertOk();
        $response->assertViewIs('keptkayas.shop.index');
    }

    public function test_tbank_waste_management_screens_accessible(): void
    {
        $staff = User::where('username', 'recycle_staff')->first();
        $this->actingAs($staff);

        $unitsResponse = $this->get(route('keptkayas.tbank.units.index'));
        $unitsResponse->assertOk();

        $pricesResponse = $this->get(route('keptkayas.tbank.prices.index'));
        $pricesResponse->assertOk();

        $groupsResponse = $this->get(route('keptkayas.tbank.items_group.index'));
        $groupsResponse->assertOk();
    }

    public function test_waste_purchase_transaction_and_points_flow(): void
    {
        $user = User::where('username', 'citizen')->first();

        $pref = KpUserWastePreference::factory()->create([
            'user_id' => $user->id,
            'org_id' => 1,
            'is_recycle_bank' => 1,
        ]);

        $account = KpBankAccount::create([
            'user_id' => $user->id,
            'org_id_fk' => 1,
            'entity_type' => 'recycle_bank',
            'account_no' => 'RB-10002',
            'balance' => 0.00,
            'points' => 0,
            'status' => 'active',
        ]);

        // Create transaction: 15.0 kg, total 150 THB, 30 points
        $tx = KpPurchaseTransaction::factory()->create([
            'org_id_fk' => 1,
            'user_id' => $user->id,
            'total_weight' => 15.0,
            'total_amount' => 150.00,
            'total_points' => 30,
            'status' => 'completed',
        ]);

        $account->increment('balance', $tx->total_amount);
        $account->increment('points', $tx->total_points);

        $this->assertEquals(150.00, (float) $account->fresh()->balance);
        $this->assertEquals(30, $account->fresh()->points);
        $this->assertDatabaseHas('kp_purchase_transactions', [
            'id' => $tx->id,
            'org_id_fk' => 1,
            'total_points' => 30,
        ]);
    }
}
