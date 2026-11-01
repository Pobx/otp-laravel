<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     *
     * @return void
     */
    public function run()
    {
        $this->call(ProvincesSeeder::class);
        $this->call(DistrictsSeeder::class);
        $this->call(TambonsSeeder::class);
        $this->call(Organizations1TypeSeeder::class);
        $this->call(OrganizationsSeeder::class);
        $this->call(ZonesSeeder::class);
        $this->call(SubzonesSeeder::class);

        $this->call(RolesSeeder::class);
        $this->call(PermissionsSeeder::class);
        $this->call(AdminSeeder::class);
        $this->call(TestUsersSeeder::class);
    }
}
