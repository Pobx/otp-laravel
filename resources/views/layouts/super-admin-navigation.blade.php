@php
    $is = fn (string ...$routes) => request()->routeIs(...$routes);
    $currentUser = auth()->user();
@endphp

<div class="sidenav-header p-3">
    <a class="navbar-brand m-0 d-flex align-items-center gap-2" href="{{ route('admin.dashboard') }}">
        <img src="{{ asset('logo/ko_envsogo.png')}}" style="width: 36px; height: 36px;" alt="main_logo">
        <span class="font-weight-bold text-dark fs-6">ผู้ดูแลระบบกลาง (Super Admin)</span>
    </a>
</div>

<hr class="horizontal dark mt-0 mb-2">

<div class="collapse navbar-collapse w-auto" id="sidenav-collapse-main">
    <ul class="navbar-nav w-100 p-0">
        <!-- 🏠 กลับหน้าศูนย์รวมระบบงาน -->
        <li class="nav-item mb-2">
            <a class="nav-link bg-light border text-primary font-weight-bold" href="{{ route('accessmenu') }}" style="border-radius: 10px;">
                <div class="icon icon-shape icon-sm bg-white shadow-sm text-center border-radius-md me-2 d-flex align-items-center justify-content-center text-primary">
                    <i class="fas fa-th-large"></i>
                </div>
                <span class="nav-link-text">🏠 หน้าศูนย์รวมระบบงาน</span>
            </a>
        </li>

        @if($currentUser?->hasRole('Super Admin'))
        <!-- 🏛️ สลับหน่วยงาน/เทศบาล -->
        <li class="nav-item mb-2">
            <a class="nav-link bg-light border text-info font-weight-bold" href="{{ route('admin.org_selector') }}" style="border-radius: 10px;">
                <div class="icon icon-shape icon-sm bg-white shadow-sm text-center border-radius-md me-2 d-flex align-items-center justify-content-center text-info">
                    <i class="fas fa-building"></i>
                </div>
                <span class="nav-link-text">🏛️ สลับเทศบาล/อปท.</span>
            </a>
        </li>
        @endif

        <li class="nav-item">
            <a class="nav-link {{ $is('admin.dashboard') ? 'active' : '' }}" href="{{ route('admin.dashboard') }}">
                <div class="icon icon-shape icon-sm shadow-sm border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center text-info">
                    <i class="fas fa-tachometer-alt"></i>
                </div>
                <span class="nav-link-text">Dashboard ผู้บริหาร</span>
            </a>
        </li>

        <li class="nav-item mt-3">
            <h6 class="ps-3 ms-2 text-uppercase text-xs font-weight-bolder text-muted mb-1">
                การบริหารจัดการระบบกลาง
            </h6>
        </li>

        <li class="nav-item">
            <a class="nav-link {{ $is('admin.users.*') ? 'active' : '' }}" href="{{ route('admin.users.index') }}">
                <div class="icon icon-shape icon-sm shadow-sm border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center text-primary">
                    <i class="fas fa-users"></i>
                </div>
                <span class="nav-link-text">1. จัดการสมาชิก (ทุกบริการ)</span>
            </a>
        </li>

        <li class="nav-item">
            <a class="nav-link {{ $is('admin.zone.*') ? 'active' : '' }}" href="{{ route('admin.zone.index') }}">
                <div class="icon icon-shape icon-sm shadow-sm border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center text-success">
                    <i class="fas fa-map-pin"></i>
                </div>
                <span class="nav-link-text">2. โซนและพื้นที่รับผิดชอบ</span>
            </a>
        </li>

        <li class="nav-item">
            <a class="nav-link {{ $is('admin.roles.*') ? 'active' : '' }}" href="{{ route('admin.roles.index') }}">
                <div class="icon icon-shape icon-sm shadow-sm border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center text-warning">
                    <i class="fas fa-user-shield"></i>
                </div>
                <span class="nav-link-text">3. บทบาทผู้ใช้งาน (Roles)</span>
            </a>
        </li>

        <li class="nav-item">
            <a class="nav-link {{ $is('admin.permissions.*') ? 'active' : '' }}" href="{{ route('admin.permissions.index') }}">
                <div class="icon icon-shape icon-sm shadow-sm border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center text-info">
                    <i class="fas fa-key"></i>
                </div>
                <span class="nav-link-text">4. สิทธิ์การใช้งาน (Permissions)</span>
            </a>
        </li>

        <li class="nav-item">
            <a class="nav-link {{ request()->is('admin/welfare*') ? 'active' : '' }}" href="{{ route('admin.welfare.dashboard') }}">
                <div class="icon icon-shape icon-sm shadow-sm border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center text-danger">
                    <i class="fas fa-hand-holding-heart"></i>
                </div>
                <span class="nav-link-text">5. กองทุนสวัสดิการชุมชน</span>
            </a>
        </li>

        <li class="nav-item">
            <a class="nav-link {{ request()->is('admin/financial*') ? 'active' : '' }}" href="{{ url('/admin/financial') }}">
                <div class="icon icon-shape icon-sm shadow-sm border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center text-success">
                    <i class="fas fa-file-invoice-dollar"></i>
                </div>
                <span class="nav-link-text">6. รายงาน สรุป ทางบัญชี</span>
            </a>
        </li>

        <li class="nav-item">
            <a class="nav-link {{ $is('admin.suppliers.*') ? 'active' : '' }}" href="{{ route('admin.suppliers.index') }}">
                <div class="icon icon-shape icon-sm shadow-sm border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center text-secondary">
                    <i class="fas fa-truck"></i>
                </div>
                <span class="nav-link-text">7. ทะเบียนคู่ค้า (Suppliers)</span>
            </a>
        </li>

        <li class="nav-item mt-4 pt-2 border-top">
            <form method="POST" action="{{ route('logout') }}" class="m-0">
                @csrf
                <button type="submit" class="nav-link text-danger w-100 text-start bg-transparent border-0 d-flex align-items-center">
                    <div class="icon icon-shape icon-sm shadow-sm border-radius-md bg-light text-center me-2 d-flex align-items-center justify-content-center text-danger">
                        <i class="fas fa-sign-out-alt"></i>
                    </div>
                    <span class="nav-link-text font-weight-bold">ออกจากระบบ</span>
                </button>
            </form>
        </li>
    </ul>
</div>
