<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Spatie\Permission\Models\Role;

class RolesSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $roles = [
            'Super Admin',
            'Admin',
            'Staff',
            'Tabwater Header',
            'Tabwater Staff',
            'Finance Header',
            'Finance Staff',
            'User',
            'Recycle Bank Staff',
            'Annual Staff',
            'Annual Fee Staff',
            'Annual Trash Staff',
            'Food Waste Staff',
            'FoodWaste Staff',
            'Recycle Bank User',
            'Tabwater User',
            'Annual Fee User',
            'Food Waste User',
        ];
        foreach ($roles as $role) {
            Role::firstOrCreate(['name' => $role, 'guard_name' => 'web']);
        }
    }
}
