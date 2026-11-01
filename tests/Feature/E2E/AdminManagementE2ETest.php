<?php

namespace Tests\Feature\E2E;

use App\Models\Admin\Organization;
use App\Models\User;
use Database\Seeders\DatabaseSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class AdminManagementE2ETest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();

        $this->seed(DatabaseSeeder::class);
    }

    public function test_super_admin_can_switch_organization_context(): void
    {
        $admin = User::where('username', 'admin')->first();
        $this->actingAs($admin);

        $org = Organization::where('id', 2)->first() ?? Organization::first();

        $response = $this->post(route('admin.set_org_context'), [
            'org_id' => $org->id,
        ]);

        $response->assertRedirect(route('accessmenu'));
        $this->assertEquals($org->id, $admin->fresh()->org_id_fk);
        $this->assertEquals($org->org_name, session('active_org_name'));
    }

    public function test_admin_can_manage_users_crud(): void
    {
        $admin = User::where('username', 'admin')->first();
        $this->actingAs($admin);

        // 1. View User Index
        $indexResponse = $this->get(route('admin.users.index'));
        $indexResponse->assertOk();

        // 2. View Create Form
        $createFormResponse = $this->get(route('admin.users.create'));
        $createFormResponse->assertOk();

        // 3. Store new user
        $storeResponse = $this->post(route('admin.users.store'), [
            'prefix' => 'นาย',
            'firstname' => 'กิตติ',
            'lastname' => 'ทดสอบระบบ',
            'username' => 'kitti_test',
            'password' => 'secret1234',
            'phone' => '0891112233',
            'id_card' => '1999900001111',
            'address' => '99/1 หมู่ 1',
            'zone_id' => 1,
            'subzone_id' => 1,
            'svc_recycle' => '1',
            'svc_annual_trash' => '1',
            'role' => 'User',
        ]);

        $storeResponse->assertRedirect();

        $newUser = User::where('username', 'kitti_test')->first();
        $this->assertNotNull($newUser);
        $this->assertEquals('กิตติ', $newUser->firstname);

        // 4. Update user
        $updateResponse = $this->put(route('admin.users.update', $newUser->id), [
            'username' => 'kitti_test',
            'prefix' => 'นาย',
            'firstname' => 'กิตติพงษ์',
            'lastname' => 'ทดสอบระบบอัปเดต',
            'phone' => '0899998877',
            'id_card' => '1999900001111',
            'address' => '99/2 หมู่ 1',
            'zone_id' => 1,
            'subzone_id' => 1,
            'status' => 'active',
        ]);

        $updateResponse->assertRedirect();
        $this->assertEquals('กิตติพงษ์', $newUser->fresh()->firstname);

        // 5. Assign role
        $roleResponse = $this->post(route('admin.users.roles', $newUser->id), [
            'role' => 'Recycle Bank Staff',
        ]);
        $roleResponse->assertRedirect();
        $this->assertTrue($newUser->fresh()->hasRole('Recycle Bank Staff'));
    }

    public function test_admin_can_view_zones_and_subzones(): void
    {
        $admin = User::where('username', 'admin')->first();
        $this->actingAs($admin);

        $zonesResponse = $this->get(route('admin.zone.index'));
        $zonesResponse->assertOk();

        $subzoneResponse = $this->get(route('admin.super_admin.subzone.edit', 1));
        $subzoneResponse->assertOk();
    }
}
