@extends('layouts.super-admin')

@section('content')
<div class="container-fluid py-4">
    <div class="row">
        <div class="col-12">
            <div class="card shadow-sm border-0 mb-4" style="border-radius: 14px;">
                <div class="card-header bg-white border-bottom p-4">
                    <div class="d-flex flex-wrap align-items-center justify-content-between gap-3">
                        <div>
                            <h4 class="font-weight-bold text-dark m-0 d-flex align-items-center gap-2">
                                <span class="fs-3">🏛️</span>
                                <span>เลือกองค์กรปกครองส่วนท้องถิ่นที่ต้องการบริหารจัดการ</span>
                            </h4>
                            <p class="text-muted mt-1 mb-0 fs-6">
                                กรุณาเลือกเทศบาล หรือ อบต. ที่ท่านต้องการเข้าไปตรวจสอบข้อมูลหรือปฏิบัติงานในระบบ
                            </p>
                        </div>
                        <div style="min-width: 280px;">
                            <form action="{{ route('admin.org_selector') }}" method="GET" class="m-0">
                                <label for="org_type_filter" class="form-label text-dark font-weight-bold mb-1">
                                    <i class="fas fa-filter text-primary me-1"></i> กรองตามประเภทหน่วยงาน:
                                </label>
                                <select id="org_type_filter" name="org_type" class="form-select" onchange="this.form.submit()" style="height: 48px; font-size: 16px;">
                                    <option value="">--- แสดงทุกประเภทหน่วยงาน ---</option>
                                    @foreach($orgTypes as $type)
                                        <option value="{{ $type->id }}" {{ request('org_type') == $type->id ? 'selected' : '' }}>
                                            {{ $type->name }}
                                        </option>
                                    @endforeach
                                </select>
                            </form>
                        </div>
                    </div>
                </div>

                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-items-center mb-0">
                            <thead>
                                <tr>
                                    <th style="width: 40%;">ชื่อองค์กร / เทศบาล</th>
                                    <th style="width: 30%;">พื้นที่รับผิดชอบ (ตำบล / อำเภอ / จังหวัด)</th>
                                    <th class="text-center" style="width: 15%;">สถานะระบบ</th>
                                    <th class="text-center" style="width: 15%;">การเข้าจัดการ</th>
                                </tr>
                            </thead>
                            <tbody>
                                @forelse($organizations as $org)
                                <tr>
                                    <td>
                                        <div class="d-flex align-items-center px-2 py-2">
                                            <div class="me-3">
                                                <img src="{{ asset('logo/'.$org->org_logo_img) }}" class="rounded-circle border" style="width: 48px; height: 48px; object-fit: contain; background: #FFF;">
                                            </div>
                                            <div>
                                                <div class="font-weight-bold text-dark fs-5">{{ $org->org_name }}</div>
                                                <span class="badge bg-light text-primary border font-weight-normal mt-1" style="font-size: 13px;">
                                                    รหัสองค์กร: #{{ $org->id }}
                                                </span>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="text-dark font-weight-bold fs-6">
                                            ตำบล{{ $org->tambon_name ?: '-' }} อำเภอ{{ $org->district_name ?: '-' }}
                                        </div>
                                        <small class="text-muted">
                                            รหัสไปรษณีย์: {{ $org->zipcode ?: '-' }}
                                        </small>
                                    </td>
                                    <td class="text-center">
                                        <span class="badge bg-success-light text-success px-3 py-2 rounded-pill font-weight-bold" style="font-size: 14px; background-color: #DCFCE7; color: #15803D !important;">
                                            <i class="fas fa-check-circle me-1"></i> พร้อมใช้งาน
                                        </span>
                                    </td>
                                    <td class="text-center">
                                        <form action="{{ route('admin.set_org_context') }}" method="POST" class="m-0 d-inline">
                                            @csrf
                                            <input type="hidden" name="org_id" value="{{ $org->id }}">
                                            <button type="submit" class="btn btn-primary" style="min-height: 44px; padding: 8px 18px; font-size: 15px;">
                                                <span>เข้าจัดการระบบ</span>
                                                <i class="fas fa-arrow-right ms-1"></i>
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                                @empty
                                <tr>
                                    <td colspan="4" class="text-center py-5 text-muted fs-5">
                                        <i class="fas fa-folder-open fs-1 d-block mb-3 text-secondary"></i>
                                        ไม่พบข้อมูลองค์กรตามประเภทที่เลือก
                                    </td>
                                </tr>
                                @endforelse
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
