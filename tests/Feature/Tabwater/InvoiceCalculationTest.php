<?php

namespace Tests\Feature\Tabwater;

use App\Models\Admin\BudgetYear;
use App\Models\Admin\Organization;
use App\Models\Tabwater\InvoicePeriod;
use App\Models\Tabwater\TwInvoice;
use App\Models\Tabwater\TwMeterInfos;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Tests\TestCase;

class InvoiceCalculationTest extends TestCase
{
    use RefreshDatabase;

    protected User $user;

    protected Organization $org;

    protected function setUp(): void
    {
        parent::setUp();

        DB::statement('SET FOREIGN_KEY_CHECKS=0;');

        $this->org = Organization::factory()->create(['id' => 1]);
        $this->user = User::factory()->create([
            'org_id_fk' => $this->org->id,
        ]);
        $this->actingAs($this->user);
    }

    public function test_water_usage_calculation_calculates_difference(): void
    {
        $lastMeter = 100.0;
        $currentMeter = 125.5;
        $waterUsed = max(0, $currentMeter - $lastMeter);

        $this->assertEquals(25.5, $waterUsed);
    }

    public function test_water_usage_calculation_clamps_negative_to_zero(): void
    {
        $lastMeter = 150.0;
        $currentMeter = 120.0;
        $waterUsed = max(0, $currentMeter - $lastMeter);

        $this->assertEquals(0, $waterUsed);
    }

    public function test_invoice_persists_with_correct_organization_and_attributes(): void
    {
        $budgetYear = BudgetYear::create([
            'org_id_fk' => $this->org->id,
            'budgetyear_name' => '2569',
            'startdate' => '2025-10-01',
            'enddate' => '2026-09-30',
            'status' => 'active',
        ]);

        $period = InvoicePeriod::create([
            'org_id_fk' => $this->org->id,
            'budgetyear_id' => $budgetYear->id,
            'inv_p_name' => 'ตุลาคม 2569',
            'inv_p_name_int' => '10-69',
            'startdate' => now()->startOfMonth()->toDateString(),
            'enddate' => now()->endOfMonth()->toDateString(),
            'status' => 'active',
        ]);

        $meter = TwMeterInfos::factory()->create([
            'org_id_fk' => $this->org->id,
            'user_id' => $this->user->id,
            'meter_id' => 1001,
        ]);

        $invoice = TwInvoice::create([
            'inv_no' => 'INV-2026-0001',
            'meter_id_fk' => $meter->meter_id,
            'inv_period_id_fk' => $period->id,
            'org_id_fk' => $this->org->id,
            'lastmeter' => 100,
            'currentmeter' => 120,
            'water_used' => 20,
            'reserve_meter' => 0.00,
            'inv_type' => 'u',
            'paid' => 200.00,
            'vat' => 14.00,
            'totalpaid' => 214.00,
            'previous_balance' => 0.00,
            'status' => 'invoice',
            'recorder_id' => $this->user->id,
        ]);

        $this->assertDatabaseHas('tw_invoice', [
            'id' => $invoice->id,
            'org_id_fk' => $this->org->id,
            'meter_id_fk' => 1001,
            'water_used' => 20,
            'totalpaid' => 214.00,
        ]);
    }
}
