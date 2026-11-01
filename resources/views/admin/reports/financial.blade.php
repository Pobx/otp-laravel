@extends('layouts.super-admin')

@section('content')
<div class="container-fluid py-2">
    <!-- Header Card -->
    <div class="card border mb-4 shadow-sm" style="background: #ffffff; border-color: #e2e8f0; border-radius: 12px;">
        <div class="card-body p-4 d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3">
            <div>
                <span class="badge bg-primary text-white px-3 py-2 fs-6 mb-2">
                    <i class="fas fa-file-invoice-dollar me-1"></i> รายงานการเงิน
                </span>
                <h3 class="fw-bold text-dark mb-1" style="font-size: 26px;">
                    สรุปสถานะการเงินและการจัดเก็บค่าธรรมเนียม
                </h3>
                <p class="text-secondary mb-0" style="font-size: 16px;">
                    ประจำเดือน {{ $month }}/{{ $year }} (คำนวณจากระบบค่าธรรมเนียมขยะรายปีและสวัสดิการชุมชน)
                </p>
            </div>
            <div>
                <a href="{{ route('admin.dashboard') }}" class="btn btn-outline-secondary px-4 py-2" style="font-size: 16px; border-radius: 8px;">
                    <i class="fas fa-arrow-left me-1"></i> กลับหน้าหลักผู้ดูแล
                </a>
            </div>
        </div>
    </div>

    <!-- 3 Summary Stat Cards in Senior White Design -->
    <div class="row g-4 mb-4">
        <!-- 1. รายได้ที่คาดการณ์ -->
        <div class="col-md-4">
            <div class="card border h-100 shadow-sm" style="background: #ffffff; border-color: #cbd5e1; border-radius: 12px; border-left: 6px solid #0284c7 !important;">
                <div class="card-body p-4">
                    <div class="d-flex align-items-center justify-content-between mb-2">
                        <span class="text-secondary fw-bold" style="font-size: 16px;">
                            <i class="fas fa-chart-line text-info me-1"></i> ประมาณการรายได้ทั้งหมด
                        </span>
                        <span class="badge bg-light text-info border px-2 py-1">รวมทุกหลังคาเรือน</span>
                    </div>
                    <h2 class="fw-bold mb-1" style="color: #0284c7; font-size: 32px;">
                        ฿{{ number_format($totalPotentialIncome, 2) }}
                    </h2>
                    <p class="text-muted mb-0" style="font-size: 14px;">
                        คำนวณจากสมาชิกที่ลงทะเบียนทั้งหมด
                    </p>
                </div>
            </div>
        </div>

        <!-- 2. มูลค่าสวัสดิการ -->
        <div class="col-md-4">
            <div class="card border h-100 shadow-sm" style="background: #ffffff; border-color: #cbd5e1; border-radius: 12px; border-left: 6px solid #16a34a !important;">
                <div class="card-body p-4">
                    <div class="d-flex align-items-center justify-content-between mb-2">
                        <span class="text-secondary fw-bold" style="font-size: 16px;">
                            <i class="fas fa-hand-holding-heart text-success me-1"></i> มูลค่าสวัสดิการยกเว้น
                        </span>
                        <span class="badge bg-light text-success border px-2 py-1">คืนกำไรชุมชน</span>
                    </div>
                    <h2 class="fw-bold mb-1" style="color: #16a34a; font-size: 32px;">
                        ฿{{ number_format($totalWaivedValue, 2) }}
                    </h2>
                    <p class="text-muted mb-0" style="font-size: 14px;">
                        ส่วนลดสำหรับสมาชิกที่ร่วมคัดแยกขยะ
                    </p>
                </div>
            </div>
        </div>

        <!-- 3. ยอดต้องจัดเก็บจริง -->
        <div class="col-md-4">
            <div class="card border h-100 shadow-sm" style="background: #ffffff; border-color: #cbd5e1; border-radius: 12px; border-left: 6px solid #ea580c !important;">
                <div class="card-body p-4">
                    <div class="d-flex align-items-center justify-content-between mb-2">
                        <span class="text-secondary fw-bold" style="font-size: 16px;">
                            <i class="fas fa-wallet text-warning me-1"></i> ยอดที่ต้องจัดเก็บจริง
                        </span>
                        <span class="badge bg-light text-warning border px-2 py-1">เป้าหมายเงินสด</span>
                    </div>
                    <h2 class="fw-bold mb-1" style="color: #ea580c; font-size: 32px;">
                        ฿{{ number_format($expectedCash, 2) }}
                    </h2>
                    <p class="text-muted mb-0" style="font-size: 14px;">
                        ยอดเรียกเก็บสุทธิในรอบเดือนนี้
                    </p>
                </div>
            </div>
        </div>
    </div>

    <!-- Status Breakdown Table -->
    <div class="card border shadow-sm" style="background: #ffffff; border-color: #e2e8f0; border-radius: 12px;">
        <div class="card-header bg-white border-bottom p-4">
            <h5 class="fw-bold text-dark mb-0" style="font-size: 20px;">
                <i class="fas fa-list-alt text-primary me-2"></i> สรุปจำนวนสมาชิกจำแนกตามสถานะ
            </h5>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table align-items-center mb-0" style="font-size: 16px;">
                    <thead class="bg-light">
                        <tr>
                            <th class="text-uppercase text-secondary text-sm font-weight-bolder ps-4 py-3">สถานะ</th>
                            <th class="text-uppercase text-secondary text-sm font-weight-bolder py-3 text-center">จำนวน (ราย)</th>
                            <th class="text-uppercase text-secondary text-sm font-weight-bolder py-3 text-center">คำอธิบาย</th>
                        </tr>
                    </thead>
                    <tbody>
                        @forelse($statusSummary as $item)
                        <tr class="border-bottom">
                            <td class="ps-4 py-3">
                                @if($item->status == 'paid')
                                    <span class="badge bg-success text-white px-3 py-2 fs-6">ชำระแล้ว (Paid)</span>
                                @elseif($item->status == 'pending')
                                    <span class="badge bg-warning text-dark px-3 py-2 fs-6">รอชำระ (Pending)</span>
                                @elseif($item->status == 'waived')
                                    <span class="badge bg-info text-white px-3 py-2 fs-6">ได้รับยกเว้นสวัสดิการ (Waived)</span>
                                @else
                                    <span class="badge bg-secondary text-white px-3 py-2 fs-6">{{ $item->status }}</span>
                                @endif
                            </td>
                            <td class="text-center py-3 fw-bold fs-5 text-dark">
                                {{ number_format($item->total) }}
                            </td>
                            <td class="text-center py-3 text-secondary">
                                @if($item->status == 'paid')
                                    จัดเก็บค่าธรรมเนียมเรียบร้อยแล้ว
                                @elseif($item->status == 'pending')
                                    อยู่ระหว่างติดตามการชำระเงิน
                                @elseif($item->status == 'waived')
                                    ได้รับสิทธิ์ยกเว้นเนื่องจากแยกขยะสม่ำเสมอ
                                @else
                                    -
                                @endif
                            </td>
                        </tr>
                        @empty
                        <tr>
                            <td colspan="3" class="text-center py-5 text-muted">
                                <i class="fas fa-inbox fa-3x mb-3 text-secondary"></i>
                                <p class="mb-0 fs-6">ยังไม่มีข้อมูลการลงทะเบียนในระบบ</p>
                            </td>
                        </tr>
                        @endforelse
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
@endsection
