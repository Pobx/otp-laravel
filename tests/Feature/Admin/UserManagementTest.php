<?php

namespace Tests\Feature\Admin;

use App\Models\Admin\Organization;
use App\Models\Admin\Subzone;
use App\Models\Admin\Zone;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Spatie\Permission\Models\Role;
use Tests\TestCase;

class UserManagementTest extends TestCase
{
    use RefreshDatabase;

    private User $admin;

    private Organization $org;

    private Zone $zone;

    private Subzone $subzone;

    protected function setUp(): void
    {
        parent::setUp();

        Role::firstOrCreate(['name' => 'Admin']);
        Role::firstOrCreate(['name' => 'User']);
        Role::firstOrCreate(['name' => 'Recycle Bank User']);
        Role::firstOrCreate(['name' => 'Food Waste User']);
        Role::firstOrCreate(['name' => 'Annual Trash User']);

        $this->org = Organization::factory()->create();

        $provinceId = 10;
        DB::table('provinces')->insert([
            'id' => $provinceId,
            'province_name' => 'Bangkok',
            'go_id' => 10,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $districtId = 1001;
        DB::table('districts')->insert([
            'id' => $districtId,
            'district_name' => 'Bang Rak',
            'province_id' => $provinceId,
            'go_id' => 1001,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $tambonId = 100101;
        DB::table('tambons')->insert([
            'id' => $tambonId,
            'tambon_name' => 'Silom',
            'district_id' => $districtId,
            'zipcode' => 10500,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $this->admin = User::factory()->create([
            'org_id_fk' => $this->org->id,
            'status' => 'active',
        ]);
        $this->admin->assignRole('Admin');

        $this->zone = Zone::create([
            'zone_name' => 'Zone 1',
            'location' => 'Zone 1 Location',
            'tambon_id' => $tambonId,
            'status' => 'active',
            'lat' => 13.75,
            'long' => 100.5,
            'org_id_fk' => $this->org->id,
        ]);

        $this->subzone = Subzone::create([
            'subzone_name' => 'Subzone 1',
            'zone_id' => $this->zone->id,
            'status' => 'active',
            'org_id_fk' => $this->org->id,
        ]);
    }

    public function test_admin_can_store_user_with_services(): void
    {
        $payload = [
            'username' => 'testuser001',
            'password' => 'secret123',
            'firstname' => 'Somchai',
            'lastname' => 'Jaidee',
            'phone' => '0812345678',
            'id_card' => '1234567890123',
            'address' => '123 Moo 4',
            'zone_id' => $this->zone->id,
            'subzone_id' => $this->subzone->id,
            'svc_recycle' => '1',
            'svc_food_waste' => '1',
        ];

        $response = $this->actingAs($this->admin)->post(route('admin.users.store'), $payload);

        $response->assertRedirect(route('admin.users.index'));
        $this->assertDatabaseHas('users', [
            'username' => 'testuser001',
            'firstname' => 'Somchai',
            'lastname' => 'Jaidee',
            'org_id_fk' => $this->org->id,
        ]);
    }

    public function test_admin_can_update_user(): void
    {
        $user = User::factory()->create([
            'org_id_fk' => $this->org->id,
            'zone_id' => $this->zone->id,
            'subzone_id' => $this->subzone->id,
        ]);

        $payload = [
            'username' => 'updateduser001',
            'firstname' => 'Somsri',
            'lastname' => 'Rukchat',
            'phone' => '0899999999',
            'id_card' => '9876543210987',
            'address' => '999 Moo 9',
            'zone_id' => $this->zone->id,
            'subzone_id' => $this->subzone->id,
        ];

        $response = $this->actingAs($this->admin)->put(route('admin.users.update', $user->id), $payload);

        $response->assertRedirect(route('admin.users.index'));
        $this->assertDatabaseHas('users', [
            'id' => $user->id,
            'username' => 'updateduser001',
            'firstname' => 'Somsri',
        ]);
    }
}
