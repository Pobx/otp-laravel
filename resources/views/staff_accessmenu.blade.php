@php
    $currentUser = Auth::user();
    $orgLogo = $orgInfos['org_logo_img'] ?? 'ko_envsogo.png';
    $orgTypeName = $orgInfos['org_type_name'] ?? 'องค์กรปกครองส่วนท้องถิ่น';
    $orgName = $orgInfos['org_name'] ?? 'เทศบาล / อปท.';
    $displayName = trim(($currentUser?->firstname ?? '') . ' ' . ($currentUser?->lastname ?? '')) ?: ($currentUser?->username ?? 'เจ้าหน้าที่');
@endphp
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>พอร์ทัลเจ้าหน้าที่ประปา | {{ $orgName }}</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" />
    <link rel="stylesheet" href="{{ asset('css/senior-white-theme.css') }}" />

    <style>
        body {
            background-color: #F8FAFC !important;
            font-family: 'Sarabun', sans-serif !important;
        }

        .staff-header-card {
            background: #FFFFFF;
            border: 2px solid #E2E8F0;
            border-radius: 16px;
            box-shadow: 0 4px 16px rgba(15, 23, 42, 0.04);
            padding: 24px 30px;
            margin-bottom: 28px;
        }

        .staff-task-card {
            background: #FFFFFF;
            border: 2px solid #E2E8F0;
            border-radius: 16px;
            padding: 24px 28px;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
            text-decoration: none;
            color: #0F172A;
            transition: all 0.2s ease;
            box-shadow: 0 2px 8px rgba(15, 23, 42, 0.03);
        }

        .staff-task-card:hover {
            border-color: #0284C7;
            background-color: #F0F9FF;
            transform: translateX(4px);
            color: #0284C7;
        }

        .staff-icon {
            width: 64px;
            height: 64px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 30px;
            flex-shrink: 0;
        }
    </style>
</head>
<body class="py-4">

<div class="container-lg">
    <!-- Header Card -->
    <div class="staff-header-card">
        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3">
            <div class="d-flex align-items-center gap-3">
                <img src="{{ asset('logo/' . $orgLogo) }}" style="width: 70px; height: 70px; object-fit: contain; border-radius: 50%; border: 2px solid #E2E8F0;" alt="Logo">
                <div>
                    <span class="badge bg-primary text-white px-2 py-1" style="font-size: 13px;">{{ $orgTypeName }}</span>
                    <h2 class="font-weight-bold text-dark mt-1 mb-0" style="font-size: 24px;">{{ $orgName }}</h2>
                    <p class="text-muted m-0 fs-6">พอร์ทัลเจ้าหน้าที่ปฏิบัติงานภาคสนาม (Field Staff Portal)</p>
                </div>
            </div>

            <div class="d-flex align-items-center gap-3">
                <div class="text-end">
                    <div class="font-weight-bold text-dark fs-6">{{ $displayName }}</div>
                    <span class="badge bg-info text-white font-weight-normal px-2 py-1">เจ้าหน้าที่กิจการประปา</span>
                </div>
                <form method="POST" action="{{ route('logout') }}" class="m-0">
                    @csrf
                    <button type="submit" class="btn btn-outline-danger btn-sm" style="min-height: 40px;">
                        <i class="fas fa-sign-out-alt"></i> ออกจากระบบ
                    </button>
                </form>
            </div>
        </div>
    </div>

    <!-- Section Title -->
    <div class="mb-4">
        <h4 class="font-weight-bold text-dark m-0 d-flex align-items-center gap-2">
            <span>💧 เมนูงานประจำวัน (Daily Tasks)</span>
        </h4>
        <p class="text-muted m-0 fs-6">กดเลือกเมนูที่ต้องการเพื่อเริ่มบันทึกข้อมูล</p>
    </div>

    <!-- Task Cards List -->
    <div class="row g-3">
        <!-- 1. จดมิเตอร์น้ำผ่านมือถือ -->
        <div class="col-12">
            <a href="{{ url('/twmanmobile/main') }}" class="staff-task-card">
                <div class="d-flex align-items-center gap-4">
                    <div class="staff-icon" style="background-color: #E0F2FE; color: #0284C7;">
                        📱
                    </div>
                    <div>
                        <div class="fs-4 font-weight-bold text-dark">1. จดเลขมิเตอร์น้ำประจำเดือน (Mobile Meter Reader)</div>
                        <div class="text-muted fs-6">เลือกเส้นทางเดินจดมิเตอร์ และบันทึกเลขมิเตอร์น้ำของแต่ละครัวเรือน</div>
                    </div>
                </div>
                <div class="btn btn-primary btn-lg" style="min-width: 170px;">
                    <span>เปิดระบบจดมิเตอร์</span>
                    <i class="fas fa-arrow-right ms-2"></i>
                </div>
            </a>
        </div>

        <!-- 2. จัดการรอบบิลค่าน้ำ -->
        <div class="col-12">
            <a href="{{ url('/admin/invoice_period') }}" class="staff-task-card">
                <div class="d-flex align-items-center gap-4">
                    <div class="staff-icon" style="background-color: #DCFCE7; color: #15803D;">
                        📑
                    </div>
                    <div>
                        <div class="fs-4 font-weight-bold text-dark">2. จัดการงวดบิลและใบแจ้งหนี้ค่าน้ำ</div>
                        <div class="text-muted fs-6">เปิดรอบบิลประจำเดือน, ตรวจสอบรายการใช้น้ำ และคำนวณค่าน้ำ</div>
                    </div>
                </div>
                <div class="btn btn-success btn-lg" style="min-width: 170px; background-color: #15803D; border-color: #15803D;">
                    <span>เปิดรอบบิล</span>
                    <i class="fas fa-arrow-right ms-2"></i>
                </div>
            </a>
        </div>

        <!-- 3. รายการแจ้งตัดมิเตอร์น้ำ -->
        <div class="col-12">
            <a href="{{ url('/cutmeter') }}" class="staff-task-card">
                <div class="d-flex align-items-center gap-4">
                    <div class="staff-icon" style="background-color: #FEE2E2; color: #B91C1C;">
                        ✂️
                    </div>
                    <div>
                        <div class="fs-4 font-weight-bold text-dark">3. รายการแจ้งตัดมิเตอร์น้ำ / ระงับการจ่ายน้ำ</div>
                        <div class="text-muted fs-6">ตรวจสอบผู้ใช้น้ำที่ค้างชำระเกินกำหนด และบันทึกผลการตัด-ต่อมิเตอร์</div>
                    </div>
                </div>
                <div class="btn btn-danger btn-lg" style="min-width: 170px; background-color: #B91C1C; border-color: #B91C1C;">
                    <span>ดูรายการตัดมิเตอร์</span>
                    <i class="fas fa-arrow-right ms-2"></i>
                </div>
            </a>
        </div>

        <!-- 4. ผังสถานีและแนวท่อส่งน้ำ -->
        <div class="col-12">
            <a href="{{ url('/tabwater/settings/stations') }}" class="staff-task-card">
                <div class="d-flex align-items-center gap-4">
                    <div class="staff-icon" style="background-color: #FEF3C7; color: #B45309;">
                        🗺️
                    </div>
                    <div>
                        <div class="fs-4 font-weight-bold text-dark">4. ข้อมูลสถานีผลิตน้ำและแนวท่อส่งน้ำ</div>
                        <div class="text-muted fs-6">ดูแผนที่สถานีผลิตน้ำประปา พิกัดจุดจ่ายน้ำ และผังแนวท่อประปา</div>
                    </div>
                </div>
                <div class="btn btn-warning btn-lg" style="min-width: 170px; background-color: #B45309; border-color: #B45309; color: #FFFFFF;">
                    <span>ดูผังแนวท่อ</span>
                    <i class="fas fa-arrow-right ms-2"></i>
                </div>
            </a>
        </div>

        <!-- 5. หน้าศูนย์รวมระบบงานเทศบาล -->
        <div class="col-12 mt-2">
            <a href="{{ route('accessmenu') }}" class="staff-task-card" style="border: 1.5px dashed #CBD5E1;">
                <div class="d-flex align-items-center gap-4">
                    <div class="staff-icon" style="background-color: #F1F5F9; color: #475569;">
                        🏠
                    </div>
                    <div>
                        <div class="fs-5 font-weight-bold text-dark">กลับไปยังหน้าศูนย์รวมระบบงานเทศบาล</div>
                        <div class="text-muted">เข้าสู่ระบบงานอื่นๆ เช่น ธนาคารขยะ ขยะเปียก หรือคลังพัสดุ</div>
                    </div>
                </div>
                <div class="btn btn-outline-secondary" style="min-width: 170px;">
                    <span>ไปหน้าศูนย์รวม</span>
                    <i class="fas fa-home ms-2"></i>
                </div>
            </a>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
