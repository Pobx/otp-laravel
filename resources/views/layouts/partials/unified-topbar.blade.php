@php
    $currentUser = Auth::user();
    $userRole = $currentUser?->roles?->first()?->name ?? 'ผู้ใช้งาน';
    $displayName = trim(($currentUser?->firstname ?? '') . ' ' . ($currentUser?->lastname ?? '')) ?: ($currentUser?->username ?? 'ผู้ใช้งาน');
    
    // ดึงชื่อเทศบาลจาก Session หรือ Org Relation
    $currentOrgName = session('active_org_name');
    if (!$currentOrgName && $currentUser?->organization) {
        $currentOrgName = trim(($currentUser->organization->org_short_type_name ?? '') . ($currentUser->organization->org_name ?? ''));
    }
    if (!$currentOrgName) {
        $currentOrgName = 'ระบบบริหารจัดการเทศบาล (Smart Municipality)';
    }

    // กำหนด URL ศูนย์รวมตามสิทธิ์
    $homeUrl = route('accessmenu');
    if ($userRole === 'Tabwater Staff' || $currentUser?->hasRole('Tabwater Staff')) {
        $homeUrl = route('staff_accessmenu');
    }
@endphp

<header class="otp-unified-topbar">
    <div class="otp-topbar-left">
        <!-- ปุ่มกลับหน้าศูนย์รวมหลัก -->
        <a href="{{ $homeUrl }}" class="otp-nav-pill-btn" title="กลับสู่หน้าศูนย์รวมระบบงาน">
            <i class="fas fa-th-large text-primary"></i>
            <span>🏠 หน้าศูนย์รวม</span>
        </a>

        <!-- ดรอปดาวน์สลับระบบงานด่วน -->
        <div class="dropdown d-inline-block">
            <button class="otp-nav-pill-btn dropdown-toggle" type="button" id="quickModuleSwitch" data-bs-toggle="dropdown" aria-expanded="false">
                <i class="fas fa-exchange-alt text-success"></i>
                <span>สลับระบบงาน</span>
            </button>
            <ul class="dropdown-menu shadow border-0 p-2" aria-labelledby="quickModuleSwitch" style="min-width: 280px; border-radius: 10px;">
                <li><h6 class="dropdown-header text-muted font-weight-bold">เลือกระบบงานที่ต้องการ</h6></li>
                
                @if($currentUser?->can('access tabwater') || $currentUser?->hasRole('Super Admin|Admin|Tabwater Staff'))
                <li>
                    <a class="dropdown-item py-2 d-flex align-items-center gap-2 rounded" href="{{ url('/twmanmobile/main') }}">
                        <span class="fs-5">💧</span>
                        <div>
                            <div class="font-weight-bold text-dark">ระบบประปาและการจดมิเตอร์</div>
                            <small class="text-muted">จดเลขมิเตอร์, บิลค่าน้ำ, ตัดมิเตอร์</small>
                        </div>
                    </a>
                </li>
                @endif

                @if($currentUser?->can('access recycle bank') || $currentUser?->hasRole('Super Admin|Admin|Recycle Bank Staff'))
                <li>
                    <a class="dropdown-item py-2 d-flex align-items-center gap-2 rounded" href="{{ route('keptkayas.dashboard', 'recycle') }}">
                        <span class="fs-5">♻️</span>
                        <div>
                            <div class="font-weight-bold text-dark">ธนาคารขยะรีไซเคิล</div>
                            <small class="text-muted">รับซื้อขยะ, สะสมแต้ม, รายงาน กก.3</small>
                        </div>
                    </a>
                </li>
                @endif

                @if($currentUser?->can('access food waste') || $currentUser?->hasRole('Super Admin|Admin|FoodWaste Staff'))
                <li>
                    <a class="dropdown-item py-2 d-flex align-items-center gap-2 rounded" href="{{ route('foodwaste.executive_dashboard') }}">
                        <span class="fs-5">🌱</span>
                        <div>
                            <div class="font-weight-bold text-dark">ระบบขยะอินทรีย์และอาหาร</div>
                            <small class="text-muted">กล่อง IoT, สถิติขยะเปียก, แก้ปัญหา</small>
                        </div>
                    </a>
                </li>
                @endif

                @if($currentUser?->can('access tabwater') || $currentUser?->hasRole('Super Admin|Admin'))
                <li>
                    <a class="dropdown-item py-2 d-flex align-items-center gap-2 rounded" href="{{ route('inventory.dashboard') }}">
                        <span class="fs-5">📦</span>
                        <div>
                            <div class="font-weight-bold text-dark">ระบบคลังพัสดุและจัดซื้อ</div>
                            <small class="text-muted">รายการพัสดุ (SKUs), รับเข้า-เบิกจ่าย</small>
                        </div>
                    </a>
                </li>
                @endif

                @if($currentUser?->hasRole('Super Admin|Admin'))
                <li><hr class="dropdown-divider my-1"></li>
                <li>
                    <a class="dropdown-item py-2 d-flex align-items-center gap-2 rounded" href="{{ route('admin.users.index') }}">
                        <span class="fs-5">⚙️</span>
                        <div>
                            <div class="font-weight-bold text-dark">ระบบบริหารจัดการและสวัสดิการ</div>
                            <small class="text-muted">จัดการผู้ใช้, โซนพื้นที่, สวัสดิการชุมชน</small>
                        </div>
                    </a>
                </li>
                @endif

                @if($currentUser?->hasRole('Super Admin'))
                <li>
                    <a class="dropdown-item py-2 d-flex align-items-center gap-2 rounded text-primary" href="{{ route('admin.org_selector') }}">
                        <span class="fs-5">🏛️</span>
                        <div>
                            <div class="font-weight-bold">สลับหน่วยงาน/เทศบาล</div>
                            <small class="text-muted">เปลี่ยนองค์กรที่กำลังดูแล</small>
                        </div>
                    </a>
                </li>
                @endif
            </ul>
        </div>
    </div>

    <!-- ส่วนกลาง: ชื่อเทศบาลปัจจุบัน -->
    <div class="d-none d-lg-flex align-items-center gap-2 px-3 py-1 bg-light rounded-pill border">
        <span class="text-primary fs-5">🏛️</span>
        <span class="font-weight-bold text-dark fs-6">{{ $currentOrgName }}</span>
    </div>

    <!-- ส่วนขวา: ข้อมูลผู้ใช้และออกจากระบบ -->
    <div class="otp-topbar-right">
        <div class="otp-user-badge">
            <i class="fas fa-user-circle text-primary fs-5"></i>
            <span>{{ $displayName }}</span>
            <span class="badge bg-secondary text-white font-weight-normal px-2 py-1" style="font-size: 13px;">{{ $userRole }}</span>
        </div>

        <form method="POST" action="{{ route('logout') }}" class="m-0 d-inline">
            @csrf
            <button type="submit" class="btn btn-outline-danger btn-sm" title="ออกจากระบบ">
                <i class="fas fa-sign-out-alt"></i>
                <span class="d-none d-md-inline">ออกจากระบบ</span>
            </button>
        </form>
    </div>
</header>
