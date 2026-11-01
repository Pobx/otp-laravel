<?php

namespace Tests\Feature\E2E;

use App\Models\Admin\Organization;
use Database\Seeders\DatabaseSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class AuthAndLandingFlowE2ETest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();

        $this->seed(DatabaseSeeder::class);
    }

    public function test_super_admin_e2e_login_org_selection_and_accessmenu(): void
    {
        // 1. Visit Login screen
        $loginPage = $this->get('/login');
        $loginPage->assertOk();

        // 2. Submit credentials for Super Admin
        $loginResponse = $this->post('/login', [
            'username' => 'admin',
            'password' => 'password',
            'login_staff' => '0',
        ]);

        $this->assertAuthenticated();
        $loginResponse->assertRedirect(route('admin.org_selector'));

        // 3. Follow redirect to Organization Selector
        $orgSelectorPage = $this->get('/admin/select-organization');
        $orgSelectorPage->assertOk();

        // 4. Select Organization 1
        $org = Organization::first();
        $setContextResponse = $this->post(route('admin.set_org_context'), [
            'org_id' => $org->id,
        ]);
        $setContextResponse->assertRedirect(route('accessmenu'));

        // 5. Access main menu
        $accessMenuPage = $this->get('/accessmenu');
        $accessMenuPage->assertOk();
    }

    public function test_tabwater_staff_e2e_login_and_staff_accessmenu(): void
    {
        $loginResponse = $this->post('/login', [
            'username' => 'water_staff',
            'password' => 'password',
            'login_staff' => '1',
        ]);

        $this->assertAuthenticated();
        $loginResponse->assertRedirect(route('staff_accessmenu'));

        $staffPage = $this->get('/staff_accessmenu');
        $staffPage->assertOk();
    }

    public function test_recycle_bank_staff_e2e_login_and_accessmenu(): void
    {
        $loginResponse = $this->post('/login', [
            'username' => 'recycle_staff',
            'password' => 'password',
            'login_staff' => '0',
        ]);

        $this->assertAuthenticated();
        $loginResponse->assertRedirect(route('accessmenu'));

        $menuPage = $this->get('/accessmenu');
        $menuPage->assertOk();
    }

    public function test_citizen_user_e2e_login_and_logout(): void
    {
        $loginResponse = $this->post('/login', [
            'username' => 'citizen',
            'password' => 'password',
            'login_staff' => '0',
        ]);

        $this->assertAuthenticated();
        $loginResponse->assertRedirect(route('accessmenu'));

        $menuPage = $this->get('/accessmenu');
        $menuPage->assertOk();

        // Logout
        $logoutResponse = $this->post('/logout');
        $this->assertGuest();
        $logoutResponse->assertRedirect('/');
    }
}
