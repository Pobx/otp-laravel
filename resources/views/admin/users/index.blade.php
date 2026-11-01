@extends('layouts.super-admin')

@section('nav-header', 'สมาชิก')
@section('nav-current', 'ตารางสมาชิก')
@section('page-topic', 'ตารางสมาชิก')
@section('nav-keptkayas.users', 'active')

@section('styles')
    <style>
        .form-check-input {
            width: 1.5rem !important;
            height: 1.5rem !important;
            cursor: pointer;
        }
        .table td { vertical-align: middle !important; font-size: 16px; }
        .table th { font-size: 15px; }
    </style>
@endsection

@section('content')
<div class="container-fluid py-2">
    <!-- Header Card -->
    <div class="card border mb-4 shadow-sm" style="background: #ffffff; border-color: #e2e8f0; border-radius: 12px;">
        <div class="card-body p-4 d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center gap-3">
            <div>
                <span class="badge bg-primary text-white px-3 py-2 fs-6 mb-2">
                    <i class="fas fa-users me-1"></i> ทะเบียนสมาชิกกลาง
                </span>
                <h3 class="fw-bold text-dark mb-1" style="font-size: 26px;">
                    จัดการสมาชิกและสิทธิ์บริการ (Master User)
                </h3>
                <p class="text-secondary mb-0" style="font-size: 16px;">
                    ค้นหา แก้ไข และกำหนดสิทธิ์การเป็นสมาชิกในแต่ละบริการของเทศบาล
                </p>
            </div>
            <div class="d-flex flex-column flex-sm-row gap-2 w-100 w-md-auto">
                <button type="button" id="btnSaveBatch" class="btn btn-success fw-bold px-4 py-2 text-nowrap" style="font-size: 16px; border-radius: 8px;">
                    <i class="fas fa-save me-1"></i> <span>บันทึกสิทธิ์ที่เลือก</span>
                </button>
                <a href="{{ route('admin.users.create') }}" class="btn btn-primary fw-bold px-4 py-2 text-nowrap" style="font-size: 16px; border-radius: 8px;">
                    <i class="fas fa-user-plus me-1"></i> <span>เพิ่มผู้ใช้ใหม่</span>
                </a>
            </div>
        </div>
    </div>

    <!-- Filter Card: Form ค้นหาข้อมูลตามมาตรฐาน docs/UI_FORM_TABLE_STANDARDS.md -->
    <div class="card border mb-4 shadow-sm" style="background: #ffffff; border-color: #e2e8f0; border-radius: 12px;">
        <div class="card-header bg-white border-bottom p-3">
            <h5 class="fw-bold text-dark mb-0 d-flex align-items-center gap-2" style="font-size: 18px;">
                <i class="fas fa-filter text-primary"></i> ค้นหาและกรองข้อมูลสมาชิก
            </h5>
        </div>
        <div class="card-body p-4">
            <form action="{{ route('admin.users.index') }}" method="GET" class="row g-3" id="userFilterForm" novalidate>
                <div class="col-md-4">
                    <label class="form-label fw-bold text-dark" style="font-size: 16px;">คำค้นหา (ชื่อ / รหัสสมาชิก / เบอร์โทร)</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light"><i class="fas fa-search text-muted"></i></span>
                        <input type="text" name="search" class="form-control" 
                               placeholder="พิมพ์คำค้นหา..." value="{{ request('search') }}"
                               style="height: 48px; font-size: 16px;">
                    </div>
                </div>

                <div class="col-md-3">
                    <label class="form-label fw-bold text-dark" style="font-size: 16px;">โซนพื้นที่</label>
                    <select name="zone_id" class="form-select" style="height: 48px; font-size: 16px;">
                        <option value="">-- แสดงทุกโซน --</option>
                        @foreach($zones as $zone)
                            <option value="{{ $zone->id }}" {{ request('zone_id') == $zone->id ? 'selected' : '' }}>
                                {{ $zone->zone_name }}
                            </option>
                        @endforeach
                    </select>
                </div>

                <div class="col-md-3">
                    <label class="form-label fw-bold text-dark" style="font-size: 16px;">บริการที่สมัคร</label>
                    <select name="service_filter" class="form-select" style="height: 48px; font-size: 16px;">
                        <option value="">-- แสดงบริการทั้งหมด --</option>
                        <option value="recycle" {{ request('service_filter') == 'recycle' ? 'selected' : '' }}>ธนาคารขยะรีไซเคิล</option>
                        <option value="food_waste" {{ request('service_filter') == 'food_waste' ? 'selected' : '' }}>ธนาคารขยะเปียก</option>
                        <option value="annual_trash" {{ request('service_filter') == 'annual_trash' ? 'selected' : '' }}>จัดการขยะรายปี</option>
                    </select>
                </div>

                <div class="col-md-2 d-flex align-items-end gap-2">
                    <button type="submit" class="btn btn-primary w-100 fw-bold" style="height: 48px; font-size: 16px; border-radius: 8px;">
                        <i class="fas fa-search me-1"></i> ค้นหา
                    </button>
                    <a href="{{ route('admin.users.index') }}" class="btn btn-outline-secondary fw-bold d-flex align-items-center justify-content-center" style="height: 48px; width: 48px; border-radius: 8px;" title="ล้างค่าการค้นหา">
                        <i class="fas fa-redo"></i>
                    </a>
                </div>
            </form>
        </div>
    </div>

    <!-- Data Table Card -->
    <div class="card border shadow-sm" style="background: #ffffff; border-color: #e2e8f0; border-radius: 12px;">
        <div class="card-header bg-white border-bottom p-4 d-flex justify-content-between align-items-center">
            <h5 class="fw-bold text-dark mb-0" style="font-size: 20px;">
                <i class="fas fa-list text-primary me-2"></i> รายชื่อสมาชิกในระบบ
            </h5>
            <span class="badge bg-light text-secondary border px-3 py-2" style="font-size: 15px;">
                ทั้งหมด {{ $users->total() }} รายการ
            </span>
        </div>

        <form id="mainBatchForm" action="{{ route('admin.users.update_service') }}" method="POST">
            @csrf
            <div class="table-responsive">
                <table class="table align-items-center table-hover mb-0" style="font-size: 16px;">
                    <thead class="bg-light">
                        <tr>
                            <th class="text-uppercase text-secondary text-sm font-weight-bolder ps-4 py-3">รหัสสมาชิก</th>
                            <th class="text-uppercase text-secondary text-sm font-weight-bolder py-3">ชื่อ-นามสกุล / ข้อมูลติดต่อ</th>
                            <th class="text-uppercase text-secondary text-sm font-weight-bolder py-3">โซน / ชุมชนย่อย</th>
                            <th class="text-center text-uppercase text-secondary text-sm font-weight-bolder py-3" style="min-width: 260px;">สิทธิ์การเป็นสมาชิก</th>
                            <th class="text-center text-uppercase text-secondary text-sm font-weight-bolder py-3">จัดการ</th>
                        </tr>
                        <tr class="bg-white border-bottom">
                            <th colspan="3"></th>
                            <th class="text-center py-2 bg-light">
                                <div class="d-flex justify-content-center gap-4">
                                    <div class="d-flex flex-column align-items-center">
                                        <input class="form-check-input mb-1" type="checkbox" id="selectAllRecycle">
                                        <span class="fw-bold text-success" style="font-size: 13px;">รีไซเคิล</span>
                                    </div>
                                    <div class="d-flex flex-column align-items-center">
                                        <input class="form-check-input mb-1" type="checkbox" id="selectAllFood">
                                        <span class="fw-bold text-info" style="font-size: 13px;">ขยะเปียก</span>
                                    </div>
                                    <div class="d-flex flex-column align-items-center">
                                        <input class="form-check-input mb-1" type="checkbox" id="selectAllAnnual">
                                        <span class="fw-bold text-warning" style="font-size: 13px;">รายปี</span>
                                    </div>
                                </div>
                            </th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        @forelse($users as $user)
                            <tr class="border-bottom">
                                <td class="ps-4 fw-bold text-dark py-3">
                                    <span class="badge bg-light text-primary border">#{{ sprintf('%05d', $user->id) }}</span>
                                </td>
                                <td class="py-3">
                                    <div class="fw-bold text-dark" style="font-size: 17px;">
                                        {{ $user->prefix }} {{ $user->firstname }} {{ $user->lastname }}
                                    </div>
                                    <div class="text-secondary" style="font-size: 14px;">
                                        <i class="fas fa-phone-alt me-1 text-muted"></i> {{ $user->phone ?: '-' }} 
                                        <span class="mx-1">|</span> 
                                        <i class="fas fa-user text-muted me-1"></i> {{ $user->username }}
                                    </div>
                                </td>
                                <td class="py-3">
                                    <div class="fw-bold text-dark">
                                        <i class="fas fa-map-pin text-danger me-1"></i> {{ $user->kpUserPreference->user_pref_zone->zone_name ?? '-' }}
                                    </div>
                                    <div class="text-secondary small">
                                        ซอย: {{ $user->kpUserPreference->user_pref_subzone->subzone_name ?? '-' }}
                                    </div>
                                </td>
                                <td class="align-middle text-center py-3 bg-light">
                                    <div class="d-flex justify-content-center gap-4">
                                        {{-- 1. ธนาคารขยะรีไซเคิล --}}
                                        <div class="form-check mb-0">
                                            <input class="form-check-input chk-recycle" type="checkbox" 
                                                   name="services[{{$user->id}}][recycle]" value="1" 
                                                   {{ $user->recycleBankAccount ? 'checked' : '' }}
                                                   {{ auth()->user()->hasAnyRole(['Super Admin', 'Admin', 'Recycle Bank Staff']) ? '' : 'disabled' }}>
                                        </div>

                                        {{-- 2. ขยะเปียก --}}
                                        <div class="form-check mb-0">
                                            <input class="form-check-input chk-food" type="checkbox" 
                                                   name="services[{{$user->id}}][food_waste]" value="1" 
                                                   {{ $user->foodWasteBankAccount ? 'checked' : '' }}
                                                   {{ auth()->user()->hasAnyRole(['Super Admin', 'Admin', 'FoodWaste Staff']) ? '' : 'disabled' }}>
                                        </div>

                                        {{-- 3. ขยะรายปี --}}
                                        <div class="form-check mb-0">
                                            <input class="form-check-input chk-annual" type="checkbox" 
                                                   name="services[{{$user->id}}][annual_trash]" value="1" 
                                                   {{ $user->annualTrashSubscription ? 'checked' : '' }}
                                                   {{ auth()->user()->hasAnyRole(['Super Admin', 'Admin', 'Annual Trash Staff']) ? '' : 'disabled' }}>
                                        </div>
                                    </div>
                                </td>
                                <td class="text-center py-3">
                                    <a href="{{ route('admin.users.edit', $user->id) }}" class="btn btn-outline-primary btn-sm px-3 py-1 me-1" style="border-radius: 6px;">
                                        <i class="fas fa-edit me-1"></i> แก้ไข
                                    </a>
                                    <a href="{{ route('admin.users.show', $user->id) }}" class="btn btn-outline-info btn-sm px-3 py-1" style="border-radius: 6px;">
                                        <i class="fas fa-eye me-1"></i> ดูข้อมูล
                                    </a>
                                </td>
                            </tr>
                        @empty
                            <tr>
                                <td colspan="5" class="text-center py-5 text-muted">
                                    <i class="fas fa-users-slash fa-3x mb-3 text-secondary"></i>
                                    <p class="fs-5 mb-0">ไม่พบข้อมูลสมาชิกตามเงื่อนไขที่ค้นหา</p>
                                </td>
                            </tr>
                        @endforelse
                    </tbody>
                </table>
            </div>

            <div class="card-footer bg-white border-top p-4 d-flex flex-column flex-md-row justify-content-between align-items-center gap-3">
                <div class="text-secondary" style="font-size: 15px;">
                    แสดงรายการที่ <strong>{{ $users->firstItem() ?? 0 }}</strong> ถึง <strong>{{ $users->lastItem() ?? 0 }}</strong> จากทั้งหมด <strong>{{ $users->total() }}</strong> รายการ
                </div>
                <div>
                    {{ $users->appends(request()->query())->links() }}
                </div>
            </div>
        </form>
    </div>
</div>
@endsection

@section('script')
<script>
$(document).ready(function () {
    // Select All Handlers
    $('#selectAllRecycle').on('change', function () {
        $('.chk-recycle:not(:disabled)').prop('checked', $(this).is(':checked'));
    });
    $('#selectAllFood').on('change', function () {
        $('.chk-food:not(:disabled)').prop('checked', $(this).is(':checked'));
    });
    $('#selectAllAnnual').on('change', function () {
        $('.chk-annual:not(:disabled)').prop('checked', $(this).is(':checked'));
    });

    // Save batch with Two-Tier confirmation modal
    $('#btnSaveBatch').on('click', function () {
        AppNotification.confirm(
            'ยืนยันการบันทึกสิทธิ์สมาชิก?',
            'ระบบจะทำการอัปเดตสิทธิ์การใช้งานของสมาชิกตามที่ได้เลือกไว้',
            'บันทึกสิทธิ์',
            function () {
                $('#mainBatchForm').submit();
            }
        );
    });
});
</script>
@endsection
