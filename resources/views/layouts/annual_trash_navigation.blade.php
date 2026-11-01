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
        <a class="nav-link {{ $is('annual_trash.*') ? 'active' : '' }}" href="{{ route('annual_trash.index') }}">
            <div class="icon icon-shape icon-sm shadow-sm border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center text-warning">
                <i class="fas fa-tachometer-alt"></i>
            </div>
            <span class="nav-link-text">ภาพรวมค่าขยะรายปี</span>
        </a>
    </li>

    <li class="nav-item mt-3">
        <h6 class="ps-3 ms-2 text-uppercase text-xs font-weight-bolder text-muted mb-1">
            🗑️ ขั้นตอนการจัดเก็บค่าขยะ
        </h6>
    </li>

    <li class="nav-item">
        <a class="nav-link {{ $is('keptkayas.annual_payments.index') ? 'active' : '' }}" href="{{ route('keptkayas.annual_payments.index') }}">
            <div class="icon icon-shape icon-sm shadow-sm border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center text-success">
                <i class="fas fa-cash-register"></i>
            </div>
            <span class="nav-link-text">1. รับชำระค่าขยะรายครัวเรือน</span>
        </a>
    </li>

    <li class="nav-item">
        <a class="nav-link {{ $is('keptkayas.annual_payments.invoice') ? 'active' : '' }}" href="{{ route('keptkayas.annual_payments.invoice') }}">
            <div class="icon icon-shape icon-sm shadow-sm border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center text-primary">
                <i class="fas fa-file-invoice"></i>
            </div>
            <span class="nav-link-text">2. ออกใบแจ้งหนี้ค่าขยะ</span>
        </a>
    </li>

    <li class="nav-item">
        <a class="nav-link {{ $is('keptkayas.waste_bins.viewmap') ? 'active' : '' }}" href="{{ route('keptkayas.waste_bins.viewmap') }}">
            <div class="icon icon-shape icon-sm shadow-sm border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center text-info">
                <i class="fas fa-map-marked-alt"></i>
            </div>
            <span class="nav-link-text">3. แผนที่ถังขยะชุมชน</span>
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
