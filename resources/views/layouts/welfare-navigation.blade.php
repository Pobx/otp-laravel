@php
    $is = fn (string ...$routes) => request()->routeIs(...$routes);
@endphp

<div class="sidenav-header p-3">
    <a class="navbar-brand m-0 d-flex align-items-center gap-2" href="{{ route('admin.welfare.dashboard') }}">
        <img src="{{ asset('logo/ko_envsogo.png')}}" style="width: 36px; height: 36px;" alt="main_logo">
        <span class="font-weight-bold text-dark fs-6">กองทุนสวัสดิการชุมชน</span>
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

        <li class="nav-item">
            <a class="nav-link {{ $is('admin.welfare.dashboard') ? 'active' : '' }}" href="{{ route('admin.welfare.dashboard') }}">
                <div class="icon icon-shape icon-sm shadow-sm border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center text-danger">
                    <i class="fas fa-hand-holding-heart"></i>
                </div>
                <span class="nav-link-text">ภาพรวมกองทุนสวัสดิการ</span>
            </a>
        </li>

        <li class="nav-item">
            <a class="nav-link {{ $is('admin.welfare.members.*') ? 'active' : '' }}" href="{{ route('admin.welfare.members.index') }}">
                <div class="icon icon-shape icon-sm shadow-sm border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center text-primary">
                    <i class="fas fa-users"></i>
                </div>
                <span class="nav-link-text">1. ทะเบียนสมาชิกกองทุน</span>
            </a>
        </li>

        <li class="nav-item">
            <a class="nav-link {{ $is('admin.welfare.collections.*') ? 'active' : '' }}" href="{{ route('admin.welfare.collections.index') }}">
                <div class="icon icon-shape icon-sm shadow-sm border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center text-warning">
                    <i class="fas fa-coins"></i>
                </div>
                <span class="nav-link-text">2. จัดเก็บเงินสงเคราะห์</span>
            </a>
        </li>

        <li class="nav-item">
            <a class="nav-link {{ $is('admin.withdraws.*') ? 'active' : '' }}" href="{{ route('admin.withdraws.index') }}">
                <div class="icon icon-shape icon-sm shadow-sm border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center text-success">
                    <i class="fas fa-receipt"></i>
                </div>
                <span class="nav-link-text">3. การเบิกจ่ายเงินสงเคราะห์</span>
            </a>
        </li>

        <li class="nav-item">
            <a class="nav-link {{ $is('admin.welfare.config') ? 'active' : '' }}" href="{{ route('admin.welfare.config') }}">
                <div class="icon icon-shape icon-sm shadow-sm border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center text-secondary">
                    <i class="fas fa-sliders-h"></i>
                </div>
                <span class="nav-link-text">4. ตั้งค่าเกณฑ์สวัสดิการ</span>
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
