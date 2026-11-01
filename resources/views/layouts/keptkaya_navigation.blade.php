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
        <a class="nav-link {{ $is('keptkayas.dashboard*') ? 'active' : '' }}" href="{{ route('keptkayas.dashboard') }}">
            <div class="icon icon-shape icon-sm shadow-sm border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center text-success">
                <i class="fas fa-chart-pie"></i>
            </div>
            <span class="nav-link-text">ภาพรวมธนาคารขยะ (Dashboard)</span>
        </a>
    </li>

    <li class="nav-item mt-2">
        <h6 class="ps-3 ms-2 text-uppercase text-xs font-weight-bolder text-muted mb-1">
            ♻️ ขั้นตอนงานธนาคารขยะ
        </h6>
    </li>

    <li class="nav-item">
        <a class="nav-link {{ $is('keptkayas.purchase*') ? 'active' : '' }}" href="{{ route('keptkayas.purchase.select_route') }}">
            <div class="icon icon-shape icon-sm shadow-sm border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center text-primary">
                <i class="fas fa-cart-plus"></i>
            </div>
            <span class="nav-link-text">1. รับซื้อขยะรีไซเคิล</span>
        </a>
    </li>

    <li class="nav-item">
        <a class="nav-link {{ $is('keptkayas.recycle-bank.members*') ? 'active' : '' }}" href="{{ route('keptkayas.recycle-bank.members') }}">
            <div class="icon icon-shape icon-sm shadow-sm border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center text-info">
                <i class="fas fa-users"></i>
            </div>
            <span class="nav-link-text">2. รายชื่อสมาชิกธนาคารขยะ</span>
        </a>
    </li>

    <li class="nav-item">
        <a class="nav-link {{ $is('keptkayas.sell.*') ? 'active' : '' }}" href="{{ route('keptkayas.sell.form') }}">
            <div class="icon icon-shape icon-sm shadow-sm border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center text-warning">
                <i class="fas fa-truck"></i>
            </div>
            <span class="nav-link-text">3. บันทึกขายให้ร้านรับซื้อ</span>
        </a>
    </li>

    <li class="nav-item">
        <a class="nav-link {{ $is('keptkayas.withdraw.*', 'keptkayas.batches.*') ? 'active' : '' }}" href="{{ route('keptkayas.withdraw.create') }}">
            <div class="icon icon-shape icon-sm shadow-sm border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center text-danger">
                <i class="fas fa-wallet"></i>
            </div>
            <span class="nav-link-text">4. ถอนเงินสะสมสมาชิก</span>
        </a>
    </li>

    <li class="nav-item">
        <a class="nav-link {{ $is('annual_trash.*') ? 'active' : '' }}" href="{{ route('annual_trash.index') }}">
            <div class="icon icon-shape icon-sm shadow-sm border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center text-secondary">
                <i class="fas fa-calendar-alt"></i>
            </div>
            <span class="nav-link-text">5. ค่าจัดการถังขยะรายปี</span>
        </a>
    </li>

    <li class="nav-item">
        <a class="nav-link {{ request()->is('keptkayas/korkor3*') ? 'active' : '' }}" href="{{ url('/keptkayas/korkor3') }}">
            <div class="icon icon-shape icon-sm shadow-sm border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center text-success">
                <i class="fas fa-file-invoice"></i>
            </div>
            <span class="nav-link-text">6. รายงานสรุปแบบ กก.3</span>
        </a>
    </li>

    <!-- หมวดการตั้งค่าราคาขยะ -->
    <li class="nav-item mt-3">
        <h6 class="ps-3 ms-2 text-uppercase text-xs font-weight-bolder text-muted mb-1">
            ⚙️ ตั้งค่าราคาและสินค้าขยะ
        </h6>
    </li>

    <li class="nav-item">
        <a class="nav-link {{ $is('keptkayas.tbank.items.*') ? 'active' : '' }}" href="{{ route('keptkayas.tbank.items.index') }}">
            <div class="icon icon-shape icon-sm shadow-sm border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center text-primary">
                <i class="fas fa-boxes"></i>
            </div>
            <span class="nav-link-text">รายการสินค้าและขยะ</span>
        </a>
    </li>

    <li class="nav-item">
        <a class="nav-link {{ $is('keptkayas.tbank.prices.*') ? 'active' : '' }}" href="{{ route('keptkayas.tbank.prices.index') }}">
            <div class="icon icon-shape icon-sm shadow-sm border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center text-warning">
                <i class="fas fa-tags"></i>
            </div>
            <span class="nav-link-text">ราคารับซื้อประจำวัน</span>
        </a>
    </li>

    <li class="nav-item">
        <a class="nav-link {{ $is('keptkayas.tbank.units.*') ? 'active' : '' }}" href="{{ route('keptkayas.tbank.units.index') }}">
            <div class="icon icon-shape icon-sm shadow-sm border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center text-info">
                <i class="fas fa-weight-hanging"></i>
            </div>
            <span class="nav-link-text">หน่วยนับ (กก./ชิ้น/ขวด)</span>
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
