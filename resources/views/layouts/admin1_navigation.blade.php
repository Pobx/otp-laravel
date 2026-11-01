@php
    $is = fn (string ...$routes) => request()->routeIs(...$routes);
    $currentUser = auth()->user();
    $canTabwater = $currentUser?->can('access tabwater') || $currentUser?->hasRole('Super Admin|Admin|Tabwater Staff');
    $isAdmin = $currentUser?->hasRole('Super Admin|Admin');
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

    @if($canTabwater)
    <!-- หมวดที่ 1: กิจการประปา -->
    <li class="nav-item mt-2">
        <h6 class="ps-3 ms-2 text-uppercase text-xs font-weight-bolder text-muted mb-1">
            💧 ระบบงานกิจการประปา
        </h6>
    </li>

    <li class="nav-item">
        <a class="nav-link {{ $is('dashboard') ? 'active' : '' }}" href="{{ route('dashboard') }}">
            <div class="icon icon-shape icon-sm shadow-sm border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center text-info">
                <i class="fas fa-tachometer-alt"></i>
            </div>
            <span class="nav-link-text">ภาพรวมประปา (Dashboard)</span>
        </a>
    </li>

    <li class="nav-item">
        <a class="nav-link {{ $is('admin.invoice_period.*') ? 'active' : '' }}" href="{{ route('admin.invoice_period.index') }}">
            <div class="icon icon-shape icon-sm shadow-sm border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center text-success">
                <i class="fas fa-calendar-check"></i>
            </div>
            <span class="nav-link-text">1. เปิดงวดบิลประจำเดือน</span>
        </a>
    </li>

    <li class="nav-item">
        <a class="nav-link {{ request()->is('twmanmobile*') || $is('invoice.*') ? 'active' : '' }}" href="{{ url('/twmanmobile/main') }}">
            <div class="icon icon-shape icon-sm shadow-sm border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center text-primary">
                <i class="fas fa-mobile-alt"></i>
            </div>
            <span class="nav-link-text">2. จดเลขมิเตอร์น้ำ</span>
        </a>
    </li>

    <li class="nav-item">
        <a class="nav-link {{ $is('payment.*') ? 'active' : '' }}" href="{{ route('payment.index') }}">
            <div class="icon icon-shape icon-sm shadow-sm border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center text-warning">
                <i class="fas fa-money-bill-wave"></i>
            </div>
            <span class="nav-link-text">3. รับชำระค่าน้ำประปา</span>
        </a>
    </li>

    <li class="nav-item">
        <a class="nav-link {{ $is('admin.owepaper.*') ? 'active' : '' }}" href="{{ route('admin.owepaper.index') }}">
            <div class="icon icon-shape icon-sm shadow-sm border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center text-danger">
                <i class="fas fa-exclamation-triangle"></i>
            </div>
            <span class="nav-link-text">4. ออกใบเตือนค้างชำระ</span>
        </a>
    </li>

    <li class="nav-item">
        <a class="nav-link {{ request()->is('cutmeter*') ? 'active' : '' }}" href="{{ url('/cutmeter') }}">
            <div class="icon icon-shape icon-sm shadow-sm border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center text-danger">
                <i class="fas fa-cut"></i>
            </div>
            <span class="nav-link-text">5. แจ้งตัด-ระงับมิเตอร์</span>
        </a>
    </li>

    <!-- เมนูย่อย: ผังสถานีและแนวท่อ -->
    <li class="nav-item">
        <a data-bs-toggle="collapse" href="#pipeMenu" class="nav-link {{ request()->is('tabwater/settings*') ? '' : 'collapsed' }}" aria-controls="pipeMenu" role="button" aria-expanded="{{ request()->is('tabwater/settings*') ? 'true' : 'false' }}">
            <div class="icon icon-shape icon-sm shadow-sm border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center text-info">
                <i class="fas fa-map-marked-alt"></i>
            </div>
            <span class="nav-link-text">สถานีและผังแนวท่อ</span>
        </a>
        <div class="collapse {{ request()->is('tabwater/settings*') ? 'show' : '' }}" id="pipeMenu">
            <ul class="nav ms-4 ps-2">
                <li class="nav-item">
                    <a class="nav-link {{ $is('tabwater.settings.stations.*') ? 'active' : '' }}" href="{{ route('tabwater.settings.stations.index') }}">
                        <i class="fas fa-water text-xs me-2"></i>
                        <span class="sidenav-normal">สถานีผลิตน้ำประปา</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link {{ $is('tabwater.settings.pipelines.*') ? 'active' : '' }}" href="{{ route('tabwater.settings.pipelines.index') }}">
                        <i class="fas fa-project-diagram text-xs me-2"></i>
                        <span class="sidenav-normal">ผังเส้นท่อประปา</span>
                    </a>
                </li>
            </ul>
        </div>
    </li>
    @endif

    @if($isAdmin)
    <!-- หมวดที่ 2: การบริหารจัดการกลาง -->
    <li class="nav-item mt-3">
        <h6 class="ps-3 ms-2 text-uppercase text-xs font-weight-bolder text-muted mb-1">
            ⚙️ การบริหารจัดการกลาง
        </h6>
    </li>

    <li class="nav-item">
        <a class="nav-link {{ $is('admin.users.*') ? 'active' : '' }}" href="{{ route('admin.users.index') }}">
            <div class="icon icon-shape icon-sm shadow-sm border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center text-primary">
                <i class="fas fa-users"></i>
            </div>
            <span class="nav-link-text">ทะเบียนผู้ใช้งานในระบบ</span>
        </a>
    </li>

    <li class="nav-item">
        <a class="nav-link {{ $is('admin.zone.*') ? 'active' : '' }}" href="{{ route('admin.zone.index') }}">
            <div class="icon icon-shape icon-sm shadow-sm border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center text-success">
                <i class="fas fa-map-pin"></i>
            </div>
            <span class="nav-link-text">โซนและพื้นที่รับผิดชอบ</span>
        </a>
    </li>

    <li class="nav-item">
        <a class="nav-link {{ $is('admin.roles.*') ? 'active' : '' }}" href="{{ route('admin.roles.index') }}">
            <div class="icon icon-shape icon-sm shadow-sm border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center text-warning">
                <i class="fas fa-user-shield"></i>
            </div>
            <span class="nav-link-text">บทบาทผู้ใช้งาน (Roles)</span>
        </a>
    </li>

    <li class="nav-item">
        <a class="nav-link {{ $is('admin.permissions.*') ? 'active' : '' }}" href="{{ route('admin.permissions.index') }}">
            <div class="icon icon-shape icon-sm shadow-sm border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center text-info">
                <i class="fas fa-key"></i>
            </div>
            <span class="nav-link-text">สิทธิ์การใช้งาน (Permissions)</span>
        </a>
    </li>

    <li class="nav-item">
        <a class="nav-link {{ request()->is('admin/welfare*') ? 'active' : '' }}" href="{{ route('admin.welfare.dashboard') }}">
            <div class="icon icon-shape icon-sm shadow-sm border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center text-danger">
                <i class="fas fa-hand-holding-heart"></i>
            </div>
            <span class="nav-link-text">กองทุนสวัสดิการชุมชน</span>
        </a>
    </li>

    <li class="nav-item">
        <a class="nav-link {{ request()->is('admin/financial*') ? 'active' : '' }}" href="{{ url('/admin/financial') }}">
            <div class="icon icon-shape icon-sm shadow-sm border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center text-success">
                <i class="fas fa-chart-pie"></i>
            </div>
            <span class="nav-link-text">รายงานการเงินรวม</span>
        </a>
    </li>
    @endif

    <!-- ปุ่มออกจากระบบ -->
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
