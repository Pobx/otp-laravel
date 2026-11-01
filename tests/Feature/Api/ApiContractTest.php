<?php

namespace Tests\Feature\Api;

use Tests\TestCase;

class ApiContractTest extends TestCase
{
    public function test_api_health_check_contract(): void
    {
        $response = $this->getJson('/api/health-check');

        $response->assertStatus(200)
            ->assertJsonStructure([
                'status',
                'message',
                'timestamp',
            ])
            ->assertJson([
                'status' => 'online',
                'message' => 'AiroBact Server is ready',
            ]);
    }

    public function test_api_testget_contract(): void
    {
        $response = $this->getJson('/api/testget');

        $response->assertStatus(200)
            ->assertExactJson([
                'testget' => 2222,
            ]);
    }

    public function test_api_testpost_contract(): void
    {
        $response = $this->postJson('/api/testpost', [
            'sensor' => 'temperature_01',
        ]);

        $response->assertStatus(200)
            ->assertJson([
                'sensor' => 'temperature_01',
            ]);
    }
}
