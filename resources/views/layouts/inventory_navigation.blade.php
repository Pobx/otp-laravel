<ul class="navbar-nav w-100 p-0">
    <li class="nav-item mb-2">
        <a class="nav-link bg-light border text-primary font-weight-bold" href="{{ route('accessmenu') }}" style="border-radius: 10px;">
            <div class="icon icon-shape icon-sm bg-white shadow-sm text-center border-radius-md me-2 d-flex align-items-center justify-content-center text-primary">
                <i class="fas fa-th-large"></i>
            </div>
            <span class="nav-link-text">🏠 หน้าศูนย์รวมระบบงาน</span>
        </a>
    </li>

    <li class="nav-item mt-2">
        <h6 class="ps-3 ms-2 text-uppercase text-xs font-weight-bolder text-muted mb-1">
            📦 ระบบคลังพัสดุและการจัดซื้อ
        </h6>
    </li>

    <li class="nav-item">
        <a href="{{ route('inventory.dashboard') }}" class="nav-link {{ request()->routeIs('inventory.dashboard') ? 'active' : '' }}">
            <div class="icon icon-shape icon-sm shadow-sm border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center text-info">
                <i class="fas fa-chart-pie"></i>
            </div>
            <span class="nav-link-text">ภาพรวมคลัง (Dashboard)</span>
        </a>
    </li>

    <li class="nav-item">
        <a class="nav-link {{ request()->routeIs('inventory.items.*') ? 'active' : '' }}" href="{{ route('inventory.items.index') }}">
            <div class="icon icon-shape icon-sm shadow-sm border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center text-primary">
                <i class="fas fa-boxes"></i>
            </div>
            <span class="nav-link-text">1. บัญชีรายการพัสดุ (SKUs)</span>
        </a>
    </li>

    <li class="nav-item">
        <a class="nav-link {{ request()->routeIs('inventory.stock.expiring') ? 'active' : '' }}" href="{{ route('inventory.stock.expiring') }}">
            <div class="icon icon-shape icon-sm shadow-sm border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center text-warning">
                <i class="fas fa-exclamation-triangle"></i>
            </div>
            <span class="nav-link-text">2. ของใกล้หมดอายุ</span>
        </a>
    </li>

    <li class="nav-item">
        <a href="{{ route('inventory.history') }}" class="nav-link {{ request()->routeIs('inventory.history') ? 'active' : '' }}">
            <div class="icon icon-shape icon-sm shadow-sm border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center text-success">
                <i class="fas fa-history"></i>
            </div>
            <span class="nav-link-text">3. ประวัติการเบิกจ่าย</span>
        </a>
    </li>

    <li class="nav-item mt-3">
        <h6 class="ps-3 ms-2 text-uppercase text-xs font-weight-bolder text-muted mb-1">
            การตั้งค่าคลังพัสดุ
        </h6>
    </li>

    <li class="nav-item">
        <a href="{{ route('inventory.categories.index') }}" class="nav-link {{ request()->routeIs('inventory.categories.*') ? 'active' : '' }}">
            <div class="icon icon-shape icon-sm shadow-sm border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center text-secondary">
                <i class="fas fa-tags"></i>
            </div>
            <span class="nav-link-text">หมวดหมู่พัสดุ</span>
        </a>
    </li>

    <li class="nav-item">
        <a href="{{ route('inventory.units.index') }}" class="nav-link {{ request()->routeIs('inventory.units.*') ? 'active' : '' }}">
            <div class="icon icon-shape icon-sm shadow-sm border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center text-secondary">
                <i class="fas fa-balance-scale"></i>
            </div>
            <span class="nav-link-text">หน่วยนับ</span>
        </a>
    </li>

    <li class="nav-item">
        <a href="{{ route('inventory.locations.index') }}" class="nav-link {{ request()->routeIs('inventory.locations.*') ? 'active' : '' }}">
            <div class="icon icon-shape icon-sm shadow-sm border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center text-secondary">
                <i class="fas fa-map-marker-alt"></i>
            </div>
            <span class="nav-link-text">จุดจัดเก็บ (Locations)</span>
        </a>
    </li>

    <li class="nav-item">
        <a href="{{ route('admin.suppliers.index') }}" class="nav-link {{ request()->routeIs('admin.suppliers.*') ? 'active' : '' }}">
            <div class="icon icon-shape icon-sm shadow-sm border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center text-secondary">
                <i class="fas fa-truck"></i>
            </div>
            <span class="nav-link-text">ทะเบียนผู้จำหน่าย (Suppliers)</span>
        </a>
    </li>
</ul>
