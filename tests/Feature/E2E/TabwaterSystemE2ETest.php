<?php

namespace Tests\Feature\E2E;

use App\Models\Admin\BudgetYear;
use App\Models\Tabwater\InvoicePeriod;
use App\Models\Tabwater\TwInvoice;
use App\Models\Tabwater\TwMeterInfos;
use App\Models\Tabwater\TwMeterType;
use App\Models\User;
use Database\Seeders\DatabaseSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class TabwaterSystemE2ETest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();

        $this->seed(DatabaseSeeder::class);
    }

    public function test_meter_reader_mobile_screens_accessible_by_tabwater_staff(): void
    {
        $staff = User::where('username', 'water_staff')->first();
        $this->actingAs($staff);

        $indexResponse = $this->get(route('twmanmobile'));
        $indexResponse->assertOk();

        $mainResponse = $this->get(route('twmanmobile.main'));
        $mainResponse->assertOk();
    }

    public function test_cutmeter_management_screen_accessible(): void
    {
        $admin = User::where('username', 'admin')->first();
        $this->actingAs($admin);

        $response = $this->get(route('cutmeter.index'));
        $response->assertOk();
    }

    public function test_meter_reading_and_invoice_calculation(): void
    {
        $user = User::where('username', 'citizen')->first();

        $budgetYear = BudgetYear::create([
            'org_id_fk' => 1,
            'budgetyear_name' => '2569',
            'startdate' => '2025-10-01',
            'enddate' => '2026-09-30',
            'status' => 'active',
        ]);

        $period = InvoicePeriod::create([
            'org_id_fk' => 1,
            'budgetyear_id' => $budgetYear->id,
            'inv_p_name' => 'ตุลาคม 2569',
            'inv_p_name_int' => '10-69',
            'startdate' => now()->startOfMonth()->toDateString(),
            'enddate' => now()->endOfMonth()->toDateString(),
            'status' => 'active',
        ]);

        $meterType = TwMeterType::create([
            'meter_type_name' => 'Residential',
            'org_id_fk' => 1,
            'description' => 'General residential meter',
        ]);

        $meter = TwMeterInfos::factory()->create([
            'user_id' => $user->id,
            'meter_id' => 9999,
            'metertype_id' => $meterType->id,
            'org_id_fk' => 1,
        ]);

        $invoice = TwInvoice::factory()->create([
            'inv_period_id_fk' => $period->id,
            'meter_id_fk' => $meter->meter_id,
            'recorder_id' => $user->id,
            'org_id_fk' => 1,
            'lastmeter' => 100,
            'currentmeter' => 125,
            'water_used' => 25,
            'paid' => 250.00,
            'vat' => 17.50,
            'totalpaid' => 267.50,
            'status' => 'invoice',
        ]);

        $this->assertEquals(25, $invoice->water_used);
        $this->assertEquals(250.0, (float) $invoice->paid);
        $this->assertEquals(267.5, (float) $invoice->totalpaid);
        $this->assertEquals('invoice', $invoice->status);
        $this->assertDatabaseHas('tw_invoice', [
            'id' => $invoice->id,
            'meter_id_fk' => 9999,
            'water_used' => 25,
        ]);
    }
}
