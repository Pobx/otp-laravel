<?php

namespace Database\Factories\Admin;

use App\Models\Admin\Organization;
use Illuminate\Database\Eloquent\Factories\Factory;

class OrganizationFactory extends Factory
{
    protected $model = Organization::class;

    public function definition(): array
    {
        return [
            'org_code' => fake()->unique()->numerify('ORG-####'),
            'org_name' => fake()->company(),
            'org_address' => fake()->address(),
            'org_phone' => fake()->phoneNumber(),
            'org_database' => 'envsogo_main',
            'vat' => 7.00,
            'lat' => '13.7563',
            'long' => '100.5018',
        ];
    }
}
