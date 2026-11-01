<?php

namespace Tests\Unit;

use App\Models\User;
use App\Services\Navigation\RoleMenuService;
use PHPUnit\Framework\TestCase;

class RoleMenuServiceTest extends TestCase
{
    protected RoleMenuService $service;

    protected function setUp(): void
    {
        parent::setUp();
        $this->service = new RoleMenuService();
    }

    /**
     * Test that guest users receive the public/guest menu with login and hub links.
     */
    public function test_guest_user_receives_guest_menu_with_hub_link(): void
    {
        $menu = $this->service->getMenuForUser(null);

        $this->assertIsArray($menu);
        $this->assertNotEmpty($menu);

        // First item should always be the Hub link
        $firstItem = $menu[0];
        $this->assertEquals('ศูนย์รวมระบบงาน (Hub)', $firstItem['text']);
        $this->assertEquals('accessmenu', $firstItem['url']);
    }

    /**
     * Test that finance role receives financial and payment menus.
     */
    public function test_finance_role_receives_finance_specific_menu(): void
    {
        // Mock user with finance role
        $user = $this->createMock(User::class);
        $user->method('hasRole')->willReturnCallback(function ($role) {
            return $role === 'finance';
        });
        $user->method('hasAnyRole')->willReturnCallback(function ($roles) {
            $roles = (array) $roles;
            return in_array('finance', $roles, true);
        });

        $menu = $this->service->getMenuForUser($user);

        $menuTexts = array_column($menu, 'text');
        
        $this->assertContains('ศูนย์รวมระบบงาน (Hub)', $menuTexts);
        $this->assertContains('รับชำระค่าน้ำ (เคาน์เตอร์)', $menuTexts);
        $this->assertContains('ประวัติการรับชำระเงิน', $menuTexts);
        
        // Finance should not see server infrastructure or super admin menus
        $this->assertNotContains('สลับเทศบาล/อปท.', $menuTexts);
        $this->assertNotContains('สถานีผลิตน้ำ', $menuTexts);
    }

    /**
     * Test that tabwater role receives water meter and pipeline menus.
     */
    public function test_tabwater_role_receives_tabwater_specific_menu(): void
    {
        $user = $this->createMock(User::class);
        $user->method('hasRole')->willReturnCallback(function ($role) {
            return $role === 'tabwater';
        });
        $user->method('hasAnyRole')->willReturnCallback(function ($roles) {
            $roles = (array) $roles;
            return in_array('tabwater', $roles, true);
        });

        $menu = $this->service->getMenuForUser($user);
        $menuTexts = array_column($menu, 'text');

        $this->assertContains('ลงทะเบียนผู้ขอใช้น้ำ/มาตรวัด', $menuTexts);
        $this->assertContains('จัดการตัด/ต่อมาตรวัดน้ำ', $menuTexts);
        $this->assertContains('ผังแนวท่อประปาและโหนด', $menuTexts);
    }

    /**
     * Test that Super Admin receives all administrative sections.
     */
    public function test_super_admin_receives_superadmin_menu(): void
    {
        $user = $this->createMock(User::class);
        $user->method('hasRole')->willReturnCallback(function ($role) {
            return in_array($role, ['Super Admin', 'Admin'], true);
        });
        $user->method('hasAnyRole')->willReturnCallback(function ($roles) {
            $roles = (array) $roles;
            return in_array('Super Admin', $roles, true) || in_array('Admin', $roles, true);
        });

        $menu = $this->service->getMenuForUser($user);
        $menuTexts = array_column($menu, 'text');

        $this->assertContains('ศูนย์รวมระบบงาน (Hub)', $menuTexts);
        $this->assertContains('Dashboard ผู้บริหาร', $menuTexts);
        $this->assertContains('จัดการสมาชิกและผู้ใช้งาน', $menuTexts);
        $this->assertContains('กำหนดสิทธิ์และบทบาท (Roles)', $menuTexts);
    }
}
