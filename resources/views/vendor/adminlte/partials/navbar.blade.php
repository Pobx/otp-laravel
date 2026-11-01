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

<nav class="app-header navbar navbar-expand bg-white border-bottom shadow-sm px-3" style="min-height: 64px;">
    <div class="container-fluid d-flex align-items-center justify-content-between p-0">
        {{-- Left side --}}
        <div class="d-flex align-items-center gap-2">
            <!-- ปุ่มพับ/กางแถบข้าง -->
            <button class="btn btn-outline-secondary btn-sm d-flex align-items-center justify-content-center p-2" 
                    data-lte-toggle="sidebar" 
                    type="button" 
                    style="width: 42px; height: 42px; border-radius: 8px;"
                    aria-label="{{ __('Toggle sidebar') }}">
                <i class="fas fa-bars fs-5"></i>
            </button>

            <!-- 🏠 ปุ่มกลับหน้าศูนย์รวมหลัก -->
            <a href="{{ $homeUrl }}" class="btn btn-primary d-flex align-items-center gap-2 px-3 py-2" style="font-size: 16px; border-radius: 8px;">
                <i class="fas fa-th-large"></i>
                <span class="d-none d-sm-inline font-weight-bold">🏠 หน้าศูนย์รวม</span>
            </a>

            <!-- สลับระบบงานด่วน (Quick Switcher) -->
            <div class="dropdown d-inline-block">
                <button class="btn btn-outline-primary dropdown-toggle d-flex align-items-center gap-2 px-3 py-2" 
                        type="button" 
                        id="quickModuleSwitch" 
                        data-bs-toggle="dropdown" 
                        aria-expanded="false"
                        style="font-size: 16px; border-radius: 8px;">
                    <i class="fas fa-exchange-alt text-success"></i>
                    <span class="d-none d-md-inline">สลับระบบงาน</span>
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
                        <a class="dropdown-item py-2 d-flex align-items-center gap-2 rounded" href="{{ url('/admin/select-organization') }}">
                            <span class="fs-5">🏢</span>
                            <div>
                                <div class="font-weight-bold text-dark">สลับหน่วยงาน/เทศบาล</div>
                                <small class="text-muted">เลือกทำงานในเทศบาลอื่น</small>
                            </div>
                        </a>
                    </li>
                    @endif
                </ul>
            </div>

            <!-- ป้ายชื่อหน่วยงาน -->
            <div class="d-none d-lg-flex align-items-center px-3 py-1 bg-light border rounded-pill ms-2">
                <i class="fas fa-building text-primary me-2"></i>
                <span class="fw-bold text-dark" style="font-size: 15px;">{{ $currentOrgName }}</span>
            </div>
        </div>

        {{-- Right side --}}
        <div class="d-flex align-items-center gap-3">
            <!-- ข้อมูลผู้ใช้งาน -->
            <div class="text-end d-none d-md-block">
                <div class="fw-bold text-dark" style="font-size: 16px;">
                    <i class="fas fa-user-circle text-primary me-1"></i> {{ $displayName }}
                </div>
                <div class="text-muted" style="font-size: 13px;">
                    <span class="badge bg-light text-secondary border">{{ $userRole }}</span>
                </div>
            </div>

            <!-- ปุ่มออกจากระบบ -->
            <form method="POST" action="{{ route('logout') }}" class="m-0">
                @csrf
                <button type="submit" class="btn btn-outline-danger btn-sm px-3 py-2 d-flex align-items-center gap-2" 
                        title="ออกจากระบบ" 
                        style="font-size: 15px; border-radius: 8px;">
                    <i class="fas fa-sign-out-alt"></i>
                    <span class="d-none d-sm-inline">ออกจากระบบ</span>
                </button>
            </form>
        </div>
    </div>
</nav>
