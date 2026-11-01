<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use Spatie\Permission\Models\Role;

class TestUsersSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $users = [
            [
                'username' => 'admin',
                'password' => Hash::make('password'),
                'prefix' => 'นาย',
                'firstname' => 'ผู้ดูแลระบบ',
                'lastname' => 'ระบบหลัก',
                'email' => 'admin@otp2025.local',
                'id_card' => '1000000000001',
                'phone' => '0800000001',
                'role' => 'Super Admin',
            ],
            [
                'username' => 'admin1',
                'password' => Hash::make('999999999'),
                'prefix' => 'นางสาว',
                'firstname' => 'Admin 1',
                'lastname' => 'ระบบเทศบาล',
                'email' => 'admin1@otp2025.local',
                'id_card' => '1000000000007',
                'phone' => '0800000007',
                'role' => 'Super Admin',
            ],
            [
                'username' => 'super admin',
                'password' => Hash::make('password'),
                'prefix' => 'นาย',
                'firstname' => 'Super',
                'lastname' => 'Admin',
                'email' => 'admin@gmail.com',
                'id_card' => '111111111',
                'phone' => '0999999999',
                'role' => 'Super Admin',
            ],
            [
                'username' => 'water_staff',
                'password' => Hash::make('password'),
                'prefix' => 'นาย',
                'firstname' => 'เจ้าหน้าที่',
                'lastname' => 'ประปา',
                'email' => 'water_staff@otp2025.local',
                'id_card' => '1000000000002',
                'phone' => '0800000002',
                'role' => 'Tabwater Staff',
            ],
            [
                'username' => 'recycle_staff',
                'password' => Hash::make('password'),
                'prefix' => 'นางสาว',
                'firstname' => 'เจ้าหน้าที่',
                'lastname' => 'ธนาคารขยะ',
                'email' => 'recycle_staff@otp2025.local',
                'id_card' => '1000000000003',
                'phone' => '0800000003',
                'role' => 'Recycle Bank Staff',
            ],
            [
                'username' => 'finance_staff',
                'password' => Hash::make('password'),
                'prefix' => 'นาง',
                'firstname' => 'เจ้าหน้าที่',
                'lastname' => 'การเงิน',
                'email' => 'finance_staff@otp2025.local',
                'id_card' => '1000000000004',
                'phone' => '0800000004',
                'role' => 'Finance Staff',
            ],
            [
                'username' => 'food_staff',
                'password' => Hash::make('password'),
                'prefix' => 'นาย',
                'firstname' => 'เจ้าหน้าที่',
                'lastname' => 'ขยะอินทรีย์',
                'email' => 'food_staff@otp2025.local',
                'id_card' => '1000000000006',
                'phone' => '0800000006',
                'role' => 'FoodWaste Staff',
            ],
            [
                'username' => 'citizen',
                'password' => Hash::make('password'),
                'prefix' => 'นาย',
                'firstname' => 'สมชาย',
                'lastname' => 'รักชุมชน',
                'email' => 'citizen@otp2025.local',
                'id_card' => '1000000000005',
                'phone' => '0800000005',
                'role' => 'User',
            ],
        ];

        foreach ($users as $userData) {
            $roleName = $userData['role'];
            unset($userData['role']);

            $user = User::updateOrCreate(
                ['username' => $userData['username']],
                array_merge($userData, [
                    'org_id_fk' => 1,
                    'gender' => 'm',
                    'address' => 'เทศบาลตำบลตัวอย่าง',
                    'zone_id' => 1,
                    'subzone_id' => 1,
                    'tambon_code' => 350805,
                    'district_code' => 3508,
                    'province_code' => 35,
                    'status' => 'active',
                    'email_verified_at' => now(),
                ])
            );

            if (Role::where('name', $roleName)->exists()) {
                $user->syncRoles([$roleName]);
            }
        }
    }
}
