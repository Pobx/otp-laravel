@php
    $sidebarClasses = config('adminlte.classes_sidebar', 'bg-white border-end shadow-sm');
    $currentPath = request()->path();
@endphp

<aside class="app-sidebar {{ $sidebarClasses }}" data-bs-theme="light" style="background-color: #FFFFFF !important; width: 280px;">
    {{-- Brand --}}
    <div class="sidebar-brand bg-white border-bottom p-3 d-flex align-items-center">
        <a href="{{ route('accessmenu') }}" class="brand-link d-flex align-items-center gap-2 text-decoration-none">
            <img src="{{ asset('logo/ko_envsogo.png') }}"
                 alt="Envsogo Logo"
                 class="brand-image rounded shadow-sm"
                 style="width: 38px; height: 38px;">
            <div class="d-flex flex-column">
                <span class="brand-text fw-bold text-primary" style="font-size: 1.15rem; line-height: 1.2;">Envsogo</span>
                <small class="text-secondary" style="font-size: 0.8rem;">เทศบาลดิจิทัล</small>
            </div>
        </a>
    </div>

    {{-- Menu Wrapper --}}
    <div class="sidebar-wrapper p-2" style="overflow-y: auto;">
        <nav class="mt-1" aria-label="Main Navigation">
            @if(View::hasSection('sidebar_navigation'))
                @yield('sidebar_navigation')
            @elseif(request()->is('foodwaste*'))
                @include('layouts.foodwaste_navigation')
            @elseif(request()->is('keptkayas/annual-payments*') || request()->is('*annual_trash*') || request()->is('*wbin*'))
                @include('layouts.annual_trash_navigation')
            @elseif(request()->is('keptkayas*') || request()->is('tbank*') || request()->is('recycle*'))
                @include('layouts.keptkaya_navigation')
            @elseif(request()->is('inventory*') || request()->is('admin/suppliers*'))
                @include('layouts.inventory_navigation')
            @elseif(request()->is('admin/welfare*'))
                @include('layouts.welfare-navigation')
            @elseif(request()->is('twmanmobile*') || request()->is('cutmeter*') || request()->is('tabwater*') || request()->is('*invoice_period*') || request()->is('payment*'))
                @include('layouts.admin1_navigation')
            @else
                @include('layouts.super-admin-navigation')
            @endif
        </nav>
    </div>
</aside>
