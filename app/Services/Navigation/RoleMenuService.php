<?php

namespace App\Services\Navigation;

use App\Models\User;

class RoleMenuService
{
    /**
     * Permanent Hub link to return to the application dashboard/portal switcher.
     *
     * @return array<string, mixed>
     */
    public function getHubItem(): array
    {
        return [
            'text' => 'ศูนย์รวมระบบงาน (Hub)',
            'url' => 'accessmenu',
            'icon' => 'bi bi-grid-3x3-gap-fill',
            'classes' => 'hub-return-link text-primary fw-bold',
        ];
    }

    /**
     * Get the complete navigation menu for a specific user based on their roles.
     *
     * @param  User|null  $user
     * @return array<int, array<string, mixed>>
     */
    public function getMenuForUser(?User $user): array
    {
        $menu = [];
        $menu[] = $this->getHubItem();

        if (! $user) {
            $menu[] = ['header' => 'บัญชีผู้ใช้งาน'];
            $menu[] = [
                'text' => 'เข้าสู่ระบบ (Login)',
                'url' => 'login',
                'icon' => 'bi bi-box-arrow-in-right',
            ];

            return $menu;
        }

        $isSuperAdmin = $user->hasRole('Super Admin') || $user->hasRole('Admin');
        $isFinance = $user->hasRole('finance');
        $isTabwater = $user->hasRole('tabwater');
        $isKeptkaya = $user->hasRole('keptkaya') || $user->hasRole('keptkayas');
        $isInventory = $user->hasRole('inventory');
        $isStaff = $user->hasRole('staff');

        // 1. Super Admin / Admin Portal
        if ($isSuperAdmin) {
            $menu[] = ['header' => 'ผู้ดูแลระบบกลาง (SUPER ADMIN)'];
            $menu[] = [
                'text' => 'Dashboard ผู้บริหาร',
                'url' => 'admin',
                'icon' => 'bi bi-speedometer2',
            ];
            $menu[] = [
                'text' => 'สลับเทศบาล/อปท.',
                'url' => 'admin/org-admins',
                'icon' => 'bi bi-building',
            ];
            $menu[] = [
                'text' => 'จัดการสมาชิกและผู้ใช้งาน',
                'url' => 'admin/users',
                'icon' => 'bi bi-people',
            ];
            $menu[] = [
                'text' => 'กำหนดสิทธิ์และบทบาท (Roles)',
                'url' => 'admin/roles',
                'icon' => 'bi bi-shield-lock',
            ];
            $menu[] = [
                'text' => 'จัดการสิทธิ์รายฟังก์ชัน (Permissions)',
                'url' => 'admin/permissions',
                'icon' => 'bi bi-key',
            ];
            $menu[] = [
                'text' => 'ตั้งค่า Workflow การอนุมัติ',
                'url' => 'admin/workflows',
                'icon' => 'bi bi-diagram-3',
            ];
            $menu[] = [
                'text' => 'โซนและพื้นที่จัดเก็บ (Zones)',
                'url' => 'admin/zone',
                'icon' => 'bi bi-geo-alt',
            ];
            $menu[] = [
                'text' => 'ตั้งค่าอัตราค่าน้ำประปา',
                'url' => 'admin/meter_rates',
                'icon' => 'bi bi-sliders',
            ];
        }

        // 2. Finance Portal
        if ($isFinance || $isSuperAdmin) {
            $menu[] = ['header' => 'ระบบงานการเงินและรับชำระ'];
            $menu[] = [
                'text' => 'รับชำระค่าน้ำ (เคาน์เตอร์)',
                'url' => 'payment',
                'icon' => 'bi bi-cash-coin',
            ];
            $menu[] = [
                'text' => 'ประวัติการรับชำระเงิน',
                'url' => 'payment/search',
                'icon' => 'bi bi-clock-history',
            ];
            $menu[] = [
                'text' => 'รอบบิลและการออกใบแจ้งหนี้',
                'url' => 'admin/invoice_period',
                'icon' => 'bi bi-receipt-cutoff',
            ];
            $menu[] = [
                'text' => 'หนังสือแจ้งเตือนค้างชำระ',
                'url' => 'admin/owepaper/index',
                'icon' => 'bi bi-exclamation-octagon',
            ];
            $menu[] = [
                'text' => 'รายงานรับชำระรายวัน (พ.17)',
                'url' => 'reports/p17',
                'icon' => 'bi bi-file-earmark-bar-graph',
            ];
            $menu[] = [
                'text' => 'รายงานลูกหนี้ค้างชำระ',
                'url' => 'reports/owe',
                'icon' => 'bi bi-wallet2',
            ];
        }

        // 3. Tabwater Portal
        if ($isTabwater || $isSuperAdmin) {
            $menu[] = ['header' => 'ระบบจัดการน้ำประปา'];
            $menu[] = [
                'text' => 'ลงทะเบียนผู้ขอใช้น้ำ/มาตรวัด',
                'url' => 'admin/users/create',
                'icon' => 'bi bi-person-plus',
            ];
            $menu[] = [
                'text' => 'จัดการตัด/ต่อมาตรวัดน้ำ',
                'url' => 'cutmeter',
                'icon' => 'bi bi-scissors',
            ];
            $menu[] = [
                'text' => 'มอบหมายเจ้าหน้าที่จดมาตร',
                'url' => 'admin/undertaker_subzone',
                'icon' => 'bi bi-person-check',
            ];
            $menu[] = [
                'text' => 'สถานีผลิตน้ำ',
                'url' => 'tabwater/settings/stations',
                'icon' => 'bi bi-water',
            ];
            $menu[] = [
                'text' => 'ผังแนวท่อประปาและโหนด',
                'url' => 'tabwater/settings/pipe-nodes',
                'icon' => 'bi bi-bezier2',
            ];
        }

        // 4. Keptkaya (Waste & Environment) Portal
        if ($isKeptkaya || $isSuperAdmin) {
            $menu[] = ['header' => 'ระบบจัดการขยะและสิ่งแวดล้อม'];
            $menu[] = [
                'text' => 'บันทึกรับซื้อขยะรีไซเคิล',
                'url' => 'keptkaya',
                'icon' => 'bi bi-recycle',
            ];
            $menu[] = [
                'text' => 'จัดการเจ้าหน้าที่จัดเก็บขยะ',
                'url' => 'staffs',
                'icon' => 'bi bi-truck',
            ];
            $menu[] = [
                'text' => 'คำนวณการลดก๊าซเรือนกระจก (EF)',
                'url' => 'admin/ef',
                'icon' => 'bi bi-tree',
            ];
        }

        // 5. Inventory Portal
        if ($isInventory || $isSuperAdmin) {
            $menu[] = ['header' => 'ระบบคลังพัสดุ'];
            $menu[] = [
                'text' => 'Dashboard คลังพัสดุ',
                'url' => 'inventory/dashboard',
                'icon' => 'bi bi-box-seam',
            ];
            $menu[] = [
                'text' => 'รายการพัสดุทั้งหมด',
                'url' => 'inventory/items/index',
                'icon' => 'bi bi-list-check',
            ];
            $menu[] = [
                'text' => 'เบิกจ่ายพัสดุหลายรายการ',
                'url' => 'inventory/withdraw/multiple',
                'icon' => 'bi bi-cart-check',
            ];
            $menu[] = [
                'text' => 'พัสดุใกล้หมดอายุ',
                'url' => 'inventory/stock/expiring',
                'icon' => 'bi bi-hourglass-split',
            ];
        }

        // 6. General Staff Mobile / Actions
        if ($isStaff && ! $isSuperAdmin) {
            $menu[] = ['header' => 'เมนูเจ้าหน้าที่ภาคสนาม'];
            $menu[] = [
                'text' => 'Dashboard รับงานซ่อม/บริการ',
                'url' => 'staff/dashboard',
                'icon' => 'bi bi-wrench-adjustable',
            ];
            $menu[] = [
                'text' => 'ระบบจดมิเตอร์น้ำเคลื่อนที่',
                'url' => 'twmanmobile',
                'icon' => 'bi bi-phone',
            ];
        }

        // 7. General Member / Citizen Portal
        if (! $isSuperAdmin && ! $isFinance && ! $isTabwater && ! $isKeptkaya && ! $isInventory && ! $isStaff) {
            $menu[] = ['header' => 'บริการประชาชนออนไลน์'];
            $menu[] = [
                'text' => 'ข้อมูลผู้ใช้น้ำของฉัน',
                'url' => 'dashboard',
                'icon' => 'bi bi-house-heart',
            ];
            $menu[] = [
                'text' => 'แจ้งเหตุน้ำประปาขัดข้อง/ท่อแตก',
                'url' => 'tabwater/notify/create',
                'icon' => 'bi bi-exclamation-triangle',
            ];
        }

        return $menu;
    }
}
