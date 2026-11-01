<?php

namespace Tests\Feature\E2E;

use App\Models\FoodWaste\FoodWasteLog;
use App\Models\FoodWaste\FoodWasteTransaction;
use App\Models\FoodWaste\FoodWasteUserPreference;
use App\Models\User;
use Database\Seeders\DatabaseSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class FoodWasteSystemE2ETest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();

        $this->seed(DatabaseSeeder::class);
    }

    public function test_executive_dashboard_accessible(): void
    {
        $staff = User::where('username', 'food_staff')->first();
        $this->actingAs($staff);

        $response = $this->get(route('foodwaste.executive_dashboard'));
        $response->assertOk();
        $response->assertViewIs('foodwaste.executive_dashboard');
    }

    public function test_foodwaste_staff_dashboard_accessible(): void
    {
        $staff = User::where('username', 'food_staff')->first();
        $this->actingAs($staff);

        $response = $this->get(route('foodwaste.dashboard'));
        $response->assertOk();
        $response->assertViewIs('foodwaste.dashboard');
    }

    public function test_foodwaste_admin_issues_accessible(): void
    {
        $staff = User::where('username', 'food_staff')->first();
        $this->actingAs($staff);

        $issuesResponse = $this->get(route('foodwaste.admin.issues.index'));
        $issuesResponse->assertOk();

        $issueTypesResponse = $this->get(route('foodwaste.admin.issue_types.index'));
        $issueTypesResponse->assertOk();
    }

    public function test_foodwaste_iot_boxes_management_accessible(): void
    {
        $staff = User::where('username', 'food_staff')->first();
        $this->actingAs($staff);

        $indexResponse = $this->get(route('foodwaste.iotboxes.index'));
        $indexResponse->assertOk();

        $createResponse = $this->get(route('foodwaste.iotboxes.create'));
        $createResponse->assertOk();
    }

    public function test_foodwaste_log_and_transaction_persistence(): void
    {
        $user = User::where('username', 'citizen')->first();
        $staff = User::where('username', 'food_staff')->first();

        $pref = FoodWasteUserPreference::create([
            'user_id' => $user->id,
        ]);

        $log = FoodWasteLog::create([
            'user_id' => $user->id,
            'weight_kg' => 5.25,
            'estimated_weight' => 5.00,
            'moisture' => 'good',
            'carbon_saved_kg' => 5.25 * 0.5,
        ]);

        $tx = FoodWasteTransaction::create([
            'fw_pref_id_fk' => $pref->id,
            'transaction_type' => 'earn_waste',
            'points' => 10,
            'amount' => 0.00,
            'staff_id' => $staff->id,
        ]);

        $this->assertDatabaseHas('foodwaste_user_preferences', [
            'id' => $pref->id,
            'user_id' => $user->id,
        ]);

        $this->assertDatabaseHas('foodwaste_waste_logs', [
            'id' => $log->id,
            'user_id' => $user->id,
            'weight_kg' => 5.25,
        ]);

        $this->assertDatabaseHas('foodwaste_transactions', [
            'id' => $tx->id,
            'fw_pref_id_fk' => $pref->id,
            'points' => 10,
            'staff_id' => $staff->id,
        ]);
    }
}
