@php
    $is = fn (string ...$routes) => request()->routeIs(...$routes);
@endphp

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
        <a class="nav-link {{ $is('foodwaste.executive_dashboard') ? 'active' : '' }}" href="{{ route('foodwaste.executive_dashboard') }}">
            <div class="icon icon-shape icon-sm shadow-sm border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center text-success">
                <i class="fas fa-chart-line"></i>
            </div>
            <span class="nav-link-text">ภาพรวมผู้บริหาร (Executive)</span>
        </a>
    </li>

    <li class="nav-item">
        <a class="nav-link {{ $is('foodwaste.dashboard', 'foodwaste.admin.fw_bank.dashboard') ? 'active' : '' }}" href="{{ route('foodwaste.dashboard') }}">
            <div class="icon icon-shape icon-sm shadow-sm border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center text-primary">
                <i class="fas fa-tachometer-alt"></i>
            </div>
            <span class="nav-link-text">แดชบอร์ดเจ้าหน้าที่ (Staff)</span>
        </a>
    </li>

    <li class="nav-item mt-3">
        <h6 class="ps-3 ms-2 text-uppercase text-xs font-weight-bolder text-muted mb-1">
            🌱 ระบบงานขยะอินทรีย์
        </h6>
    </li>

    <li class="nav-item">
        <a class="nav-link {{ $is('foodwaste.admin.issues.*') ? 'active' : '' }}" href="{{ route('foodwaste.admin.issues.index') }}">
            <div class="icon icon-shape icon-sm shadow-sm border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center text-danger">
                <i class="fas fa-exclamation-circle"></i>
            </div>
            <span class="nav-link-text">1. รายการแจ้งปัญหา/ข้อร้องเรียน</span>
        </a>
    </li>

    <li class="nav-item">
        <a class="nav-link {{ $is('foodwaste.admin.issue_types.*') ? 'active' : '' }}" href="{{ route('foodwaste.admin.issue_types.index') }}">
            <div class="icon icon-shape icon-sm shadow-sm border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center text-warning">
                <i class="fas fa-tags"></i>
            </div>
            <span class="nav-link-text">2. ประเภทปัญหาขยะ</span>
        </a>
    </li>

    <li class="nav-item">
        <a class="nav-link {{ $is('foodwaste.iotboxes.*') ? 'active' : '' }}" href="{{ route('foodwaste.iotboxes.index') }}">
            <div class="icon icon-shape icon-sm shadow-sm border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center text-info">
                <i class="fas fa-box"></i>
            </div>
            <span class="nav-link-text">3. กล่องรับขยะอัจฉริยะ (IoT)</span>
        </a>
    </li>

    <li class="nav-item">
        <a class="nav-link {{ $is('foodwaste.admin.local_foods.*') ? 'active' : '' }}" href="{{ route('foodwaste.admin.local_foods.index') }}">
            <div class="icon icon-shape icon-sm shadow-sm border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center text-primary">
                <i class="fas fa-utensils"></i>
            </div>
            <span class="nav-link-text">4. ข้อมูลอาหารท้องถิ่น</span>
        </a>
    </li>

    <li class="nav-item">
        <a class="nav-link {{ $is('foodwaste.admin.members_waste.*') ? 'active' : '' }}" href="{{ route('foodwaste.admin.members_waste.index') }}">
            <div class="icon icon-shape icon-sm shadow-sm border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center text-success">
                <i class="fas fa-history"></i>
            </div>
            <span class="nav-link-text">5. ประวัติการทิ้งขยะของสมาชิก</span>
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
