<?php

namespace App\Providers;

use App\Models\Admin\Organization;
use Illuminate\Cache\RateLimiting\Limit;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Http\Request;
use Illuminate\Pagination\Paginator;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\RateLimiter;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\URL;
use Illuminate\Support\Facades\View;
use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        if (env('APP_ENV') === 'local' && request()->server('HTTP_X_FORWARDED_PROTO') === 'https') {
            URL::forceScheme('https');
        }
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        Model::preventLazyLoading(! $this->app->isProduction());

        Schema::defaultStringLength(191);
        if (config('app.env') !== 'local') {
            URL::forceScheme('https');
        }

        RateLimiter::for('api', function (Request $request) {
            return Limit::perMinute(60)->by($request->user()?->id ?: $request->ip());
        });

        View::composer('layouts.admin1', function ($view) {
            $orgInfos = [];
            if (Auth::check()) {
                $user = Auth::user();
                $orgInfos = Organization::getOrgName($user->org_id_fk);
            }
            $view->with('orgInfos', $orgInfos);
        });

        View::composer('layouts.foodwaste', function ($view) {
            $orgInfos = [];
            if (Auth::check()) {
                $user = Auth::user();
                $orgInfos = Organization::getOrgName($user->org_id_fk);
            }
            $view->with('orgInfos', $orgInfos);
        });

        Paginator::useBootstrapFive();
    }
}
