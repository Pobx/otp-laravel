<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Console\Scheduling\Schedule;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\RateLimiter;
use Tests\TestCase;

class BootstrapTest extends TestCase
{
    use RefreshDatabase;

    public function test_guest_is_redirected_to_login(): void
    {
        $response = $this->get('/accessmenu');
        $response->assertRedirect('/login');
    }

    public function test_authenticated_user_accessing_login_is_redirected_to_accessmenu(): void
    {
        $user = User::factory()->create();

        $response = $this->actingAs($user)->get('/login');
        $response->assertRedirect('/accessmenu');
    }

    public function test_permission_middleware_aliases_are_registered(): void
    {
        $router = app('router');
        $middleware = $router->getMiddleware();

        $this->assertArrayHasKey('role', $middleware);
        $this->assertArrayHasKey('permission', $middleware);
        $this->assertArrayHasKey('role_or_permission', $middleware);
    }

    public function test_api_rate_limiter_is_configured(): void
    {
        $limiter = RateLimiter::limiter('api');
        $this->assertNotNull($limiter);
    }

    public function test_scheduled_tasks_are_registered(): void
    {
        $schedule = app(Schedule::class);
        $events = collect($schedule->events());

        $hasArchive = $events->contains(function ($event) {
            return str_contains($event->command ?? '', 'invoice:archive');
        });

        $hasCheckWaive = $events->contains(function ($event) {
            return str_contains($event->command ?? '', 'recycle:check-waive');
        });

        $this->assertTrue($hasArchive, 'invoice:archive command should be scheduled');
        $this->assertTrue($hasCheckWaive, 'recycle:check-waive command should be scheduled');
    }
}
