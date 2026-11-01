@php
    $currentUser = Auth::user();
    $orgLogo = $orgInfos['org_logo_img'] ?? 'ko_envsogo.png';
    $orgTypeName = $orgInfos['org_type_name'] ?? 'องค์กรปกครองส่วนท้องถิ่น';
    $orgName = $orgInfos['org_name'] ?? 'เทศบาล / อปท.';
    $tambon = $orgInfos['org_tambon'] ?? '';
    $district = $orgInfos['org_district'] ?? '';
    $province = $orgInfos['org_province'] ?? '';
    $userRole = $currentUser?->roles?->first()?->name ?? 'ผู้ใช้งาน';
    $displayName = trim(($currentUser?->firstname ?? '') . ' ' . ($currentUser?->lastname ?? '')) ?: ($currentUser?->username ?? 'ผู้ใช้งาน');
@endphp
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ศูนย์รวมระบบงานเทศบาล | {{ $orgName }}</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" />
    <link rel="stylesheet" href="{{ asset('css/senior-white-theme.css') }}" />

    <style>
        body {
            background-color: #F8FAFC !important;
            font-family: 'Sarabun', sans-serif !important;
            color: #0F172A;
        }

        .hub-banner-card {
            background: #FFFFFF;
            border: 2px solid #E2E8F0;
            border-radius: 16px;
            box-shadow: 0 4px 16px rgba(15, 23, 42, 0.04);
            padding: 24px 32px;
            margin-bottom: 32px;
        }

        .hub-org-logo {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            border: 2px solid #CBD5E1;
            padding: 4px;
            background: #FFFFFF;
            object-fit: contain;
        }

        .module-card {
            background: #FFFFFF;
            border: 2px solid #E2E8F0;
            border-radius: 16px;
            padding: 28px;
            height: 100%;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            box-shadow: 0 2px 8px rgba(15, 23, 42, 0.04);
            transition: all 0.25s ease;
        }

        .module-card:hover {
            border-color: #0284C7;
            transform: translateY(-4px);
            box-shadow: 0 12px 24px rgba(2, 132, 199, 0.1);
        }

        .module-card.disabled {
            opacity: 0.55;
            background-color: #F8FAFC;
            pointer-events: none;
            border-color: #E2E8F0;
        }

        .module-icon-box {
            width: 58px;
            height: 58px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
            margin-bottom: 18px;
        }

        .module-card-title {
            font-size: 21px !important;
            font-weight: 700 !important;
            color: #0F172A;
            margin-bottom: 8px;
        }

        .module-card-desc {
            font-size: 16px;
            color: #475569;
            line-height: 1.6;
            margin-bottom: 22px;
            min-height: 50px;
        }

        .module-btn {
            width: 100%;
            min-height: 48px;
            font-size: 16px;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            border-radius: 10px;
            text-decoration: none;
            transition: all 0.2s ease;
        }

        .badge-category {
            font-size: 13px;
            font-weight: 600;
            padding: 4px 10px;
            border-radius: 9999px;
            display: inline-block;
            margin-bottom: 12px;
        }
    </style>
</head>
<body class="py-4">

<div class="container-xl">
    <!-- 1. Header Banner -->
    <div class="hub-banner-card">
        <div class="row align-items-center">
            <div class="col-lg-8 col-md-7 d-flex align-items-center gap-3">
                <img src="{{ asset('logo/' . $orgLogo) }}" class="hub-org-logo" alt="Logo">
                <div>
                    <div class="d-flex align-items-center gap-2">
                        <span class="badge bg-primary text-white px-2 py-1" style="font-size: 13px;">{{ $orgTypeName }}</span>
                        @if($currentUser?->hasRole('Super Admin'))
                            <a href="{{ route('admin.org_selector') }}" class="btn btn-sm btn-outline-primary py-0 px-2" style="font-size: 12px; min-height: 28px;">
                                <i class="fas fa-exchange-alt"></i> สลับเทศบาล
                            </a>
                        @endif
                    </div>
                    <h2 class="font-weight-bold text-dark mt-1 mb-0" style="font-size: 26px;">
                        {{ $orgName }}
                    </h2>
                    <p class="text-muted m-0 fs-6">
                        @if($tambon || $district || $province)
                            ตำบล{{ $tambon }} อำเภอ{{ $district }} จังหวัด{{ $province }}
                        @else
                            ระบบสารสนเทศและการบริหารจัดการงานเทศบาลอัจฉริยะ (Smart Municipality Hub)
                        @endif
                    </p>
                </div>
            </div>

            <div class="col-lg-4 col-md-5 text-md-end mt-3 mt-md-0">
                <div class="d-inline-flex align-items-center gap-2 px-3 py-2 bg-light rounded-pill border mb-2">
                    <i class="fas fa-user-circle text-primary fs-5"></i>
                    <div class="text-start">
                        <div class="font-weight-bold text-dark text-truncate" style="max-width: 160px; font-size: 14px;">{{ $displayName }}</div>
                        <small class="text-muted" style="font-size: 12px;">{{ $userRole }}</small>
                    </div>
                </div>
                <div>
                    <form method="POST" action="{{ route('logout') }}" class="d-inline">
                        @csrf
                        <button type="submit" class="btn btn-outline-danger btn-sm" style="min-height: 38px;">
                            <i class="fas fa-sign-out-alt me-1"></i> ออกจากระบบ
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Section Heading -->
    <div class="mb-4 d-flex align-items-center justify-content-between">
        <div>
            <h4 class="font-weight-bold text-dark m-0 d-flex align-items-center gap-2">
                <span>📁 ศูนย์รวมระบบงานเทศบาล</span>
            </h4>
            <p class="text-muted m-0 fs-6">กรุณาเลือกระบบงานที่ท่านต้องการปฏิบัติงาน</p>
        </div>
    </div>

    <!-- 2. Grid of Module Cards -->
    <div class="row g-4">
        <!-- Module 1: ระบบประปา -->
        @php
            $canTabwater = $currentUser?->can('access tabwater') || $currentUser?->hasRole('Super Admin|Admin|Tabwater Staff');
        @endphp
        <div class="col-lg-4 col-md-6">
            <div class="module-card {{ $canTabwater ? '' : 'disabled' }}">
                <div>
                    <div class="d-flex justify-content-between align-items-start">
                        <div class="module-icon-box" style="background-color: #E0F2FE; color: #0284C7;">
                            💧
                        </div>
                        <span class="badge-category" style="background-color: #E0F2FE; color: #0284C7;">ฝ่ายกิจการประปา</span>
                    </div>
                    <div class="module-card-title">ระบบประปาและการจดมิเตอร์</div>
                    <div class="module-card-desc">
                        จดเลขมิเตอร์น้ำตามเส้นทาง, ออกบิลแจ้งหนี้ประจำเดือน, รับชำระค่าน้ำ และระบบสั่งตัด-ต่อมิเตอร์
                    </div>
                </div>
                <div>
                    <a href="{{ $canTabwater ? route('dashboard') : 'javascript:void(0)' }}" class="module-btn btn btn-primary">
                        <span>เข้าสู่ระบบงานประปา</span>
                        <i class="fas fa-arrow-right"></i>
                    </a>
                </div>
            </div>
        </div>

        <!-- Module 2: ธนาคารขยะรีไซเคิล -->
        @php
            $canRecycle = $currentUser?->can('access recycle bank') || $currentUser?->hasRole('Super Admin|Admin|Recycle Bank Staff');
        @endphp
        <div class="col-lg-4 col-md-6">
            <div class="module-card {{ $canRecycle ? '' : 'disabled' }}">
                <div>
                    <div class="d-flex justify-content-between align-items-start">
                        <div class="module-icon-box" style="background-color: #DCFCE7; color: #15803D;">
                            ♻️
                        </div>
                        <span class="badge-category" style="background-color: #DCFCE7; color: #15803D;">ฝ่ายสิ่งแวดล้อม</span>
                    </div>
                    <div class="module-card-title">ธนาคารขยะรีไซเคิล</div>
                    <div class="module-card-desc">
                        รับซื้อขยะรีไซเคิลจากสมาชิก, สะสมแต้ม, กำหนดราคารับซื้อประจำวัน และออกรายงานสรุปแบบ กก.3
                    </div>
                </div>
                <div>
                    <a href="{{ $canRecycle ? route('keptkayas.dashboard', 'recycle') : 'javascript:void(0)' }}" class="module-btn btn btn-success" style="background-color: #15803D; border-color: #15803D;">
                        <span>เข้าสู่ระบบธนาคารขยะ</span>
                        <i class="fas fa-arrow-right"></i>
                    </a>
                </div>
            </div>
        </div>

        <!-- Module 3: ค่าจัดการถังขยะรายปี -->
        @php
            $canAnnual = $currentUser?->can('access recycle bank') || $currentUser?->hasRole('Super Admin|Admin|Annual Trash Staff|Recycle Bank Staff');
        @endphp
        <div class="col-lg-4 col-md-6">
            <div class="module-card {{ $canAnnual ? '' : 'disabled' }}">
                <div>
                    <div class="d-flex justify-content-between align-items-start">
                        <div class="module-icon-box" style="background-color: #FEF3C7; color: #B45309;">
                            🗑️
                        </div>
                        <span class="badge-category" style="background-color: #FEF3C7; color: #B45309;">งานจัดเก็บรายได้</span>
                    </div>
                    <div class="module-card-title">ค่าจัดการถังขยะรายปี</div>
                    <div class="module-card-desc">
                        บันทึกการจัดเก็บค่าธรรมเนียมขยะรายครัวเรือนประจำปี, พิมพ์ใบเสร็จรับเงิน และติดตามยอดคงค้าง
                    </div>
                </div>
                <div>
                    <a href="{{ $canAnnual ? route('annual_trash.index') : 'javascript:void(0)' }}" class="module-btn btn btn-warning" style="background-color: #B45309; border-color: #B45309; color: #FFFFFF;">
                        <span>จัดการค่าขยะรายปี</span>
                        <i class="fas fa-arrow-right"></i>
                    </a>
                </div>
            </div>
        </div>

        <!-- Module 4: ขยะอินทรีย์และอาหาร -->
        @php
            $canFoodwaste = $currentUser?->can('access food waste') || $currentUser?->hasRole('Super Admin|Admin|FoodWaste Staff');
        @endphp
        <div class="col-lg-4 col-md-6">
            <div class="module-card {{ $canFoodwaste ? '' : 'disabled' }}">
                <div>
                    <div class="d-flex justify-content-between align-items-start">
                        <div class="module-icon-box" style="background-color: #D1FAE5; color: #047857;">
                            🌱
                        </div>
                        <span class="badge-category" style="background-color: #D1FAE5; color: #047857;">Smart Community</span>
                    </div>
                    <div class="module-card-title">ระบบขยะอินทรีย์และเศษอาหาร</div>
                    <div class="module-card-desc">
                        ติดตามสถานะกล่องรับขยะ IoT, สถิติการลดขยะเปียก, การลดก๊าซเรือนกระจก และจัดการข้อร้องเรียน
                    </div>
                </div>
                <div>
                    <a href="{{ $canFoodwaste ? route('foodwaste.executive_dashboard') : 'javascript:void(0)' }}" class="module-btn btn btn-primary" style="background-color: #047857; border-color: #047857;">
                        <span>เข้าสู่ระบบขยะอินทรีย์</span>
                        <i class="fas fa-arrow-right"></i>
                    </a>
                </div>
            </div>
        </div>

        <!-- Module 5: คลังพัสดุและจัดซื้อ -->
        @php
            $canInv = $currentUser?->can('access tabwater') || $currentUser?->hasRole('Super Admin|Admin');
        @endphp
        <div class="col-lg-4 col-md-6">
            <div class="module-card {{ $canInv ? '' : 'disabled' }}">
                <div>
                    <div class="d-flex justify-content-between align-items-start">
                        <div class="module-icon-box" style="background-color: #EDE9FE; color: #6D28D9;">
                            📦
                        </div>
                        <span class="badge-category" style="background-color: #EDE9FE; color: #6D28D9;">งานพัสดุและสินทรัพย์</span>
                    </div>
                    <div class="module-card-title">ระบบคลังพัสดุและจัดซื้อ</div>
                    <div class="module-card-desc">
                        บัญชีรายการพัสดุในคลัง (SKUs), รับพัสดุเข้าคลัง, ทำรายการเบิกจ่าย และเตือนพัสดุใกล้หมดอายุ
                    </div>
                </div>
                <div>
                    <a href="{{ $canInv ? route('inventory.dashboard') : 'javascript:void(0)' }}" class="module-btn btn btn-primary" style="background-color: #6D28D9; border-color: #6D28D9;">
                        <span>เข้าสู่ระบบคลังพัสดุ</span>
                        <i class="fas fa-arrow-right"></i>
                    </a>
                </div>
            </div>
        </div>

        <!-- Module 6: กองทุนสวัสดิการชุมชน -->
        <div class="col-lg-4 col-md-6">
            <div class="module-card">
                <div>
                    <div class="d-flex justify-content-between align-items-start">
                        <div class="module-icon-box" style="background-color: #FCE7F3; color: #BE185D;">
                            🤝
                        </div>
                        <span class="badge-category" style="background-color: #FCE7F3; color: #BE185D;">กองทุนสวัสดิการ</span>
                    </div>
                    <div class="module-card-title">กองทุนสวัสดิการชุมชน</div>
                    <div class="module-card-desc">
                        สวัสดิการขยะและฌาปนกิจสงเคราะห์, ตรวจสอบสิทธิสมาชิก และอนุมัติการจ่ายเงินสงเคราะห์
                    </div>
                </div>
                <div>
                    <a href="{{ route('admin.welfare.dashboard') }}" class="module-btn btn btn-primary" style="background-color: #BE185D; border-color: #BE185D;">
                        <span>เข้าสู่ระบบสวัสดิการ</span>
                        <i class="fas fa-arrow-right"></i>
                    </a>
                </div>
            </div>
        </div>

        <!-- Module 7: ผู้ดูแลระบบส่วนกลาง (Admin / Super Admin) -->
        @if($currentUser?->hasRole('Super Admin|Admin'))
        <div class="col-lg-4 col-md-6">
            <div class="module-card" style="border: 2px dashed #0284C7;">
                <div>
                    <div class="d-flex justify-content-between align-items-start">
                        <div class="module-icon-box" style="background-color: #F1F5F9; color: #0F172A;">
                            ⚙️
                        </div>
                        <span class="badge-category" style="background-color: #0F172A; color: #FFFFFF;">ผู้ดูแลระบบ (Admin)</span>
                    </div>
                    <div class="module-card-title">การบริหารจัดการระบบกลาง</div>
                    <div class="module-card-desc">
                        จัดการบัญชีผู้ใช้งาน, กำหนดบทบาทและสิทธิ์, โซนพื้นที่รับผิดชอบ และรายงานการเงินรวม
                    </div>
                </div>
                <div>
                    <a href="{{ route('admin.users.index') }}" class="module-btn btn btn-dark">
                        <span>จัดการระบบผู้ดูแล</span>
                        <i class="fas fa-arrow-right"></i>
                    </a>
                </div>
            </div>
        </div>
        @endif

        <!-- Module 8: ตู้คืนขวดอัตโนมัติ RVM -->
        <div class="col-lg-4 col-md-6">
            <div class="module-card">
                <div>
                    <div class="d-flex justify-content-between align-items-start">
                        <div class="module-icon-box" style="background-color: #CFFAFE; color: #0891B2;">
                            🍾
                        </div>
                        <span class="badge-category" style="background-color: #CFFAFE; color: #0891B2;">นวัตกรรมรีไซเคิล</span>
                    </div>
                    <div class="module-card-title">ตู้คืนขวดอัตโนมัติ (RVM)</div>
                    <div class="module-card-desc">
                        ตรวจสอบสถานะตู้รับคืนขวดพลาสติกอัตโนมัติ, ปริมาณขวดสะสม และประวัติการใช้งาน
                    </div>
                </div>
                <div>
                    <a href="{{ route('keptkayas.kiosks.dashboard') }}" class="module-btn btn btn-outline-primary">
                        <span>ตรวจสอบตู้คืนขวด</span>
                        <i class="fas fa-arrow-right"></i>
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
