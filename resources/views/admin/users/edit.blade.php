@extends('layouts.super-admin')
@section('title_page', 'แก้ไขข้อมูลสมาชิก')

@section('content')
<div class="container-fluid py-2">
    <!-- Header Card -->
    <div class="card border mb-4 shadow-sm" style="background: #ffffff; border-color: #e2e8f0; border-radius: 12px;">
        <div class="card-body p-4 d-flex flex-column flex-sm-row justify-content-between align-items-start align-items-sm-center gap-3">
            <div>
                <span class="badge bg-warning text-dark px-3 py-2 fs-6 mb-2">
                    <i class="fas fa-user-edit me-1"></i> แก้ไขข้อมูลสมาชิก
                </span>
                <h3 class="fw-bold text-dark mb-1" style="font-size: 26px;">
                    {{ $user->prefix }} {{ $user->firstname }} {{ $user->lastname }}
                </h3>
                <p class="text-secondary mb-0" style="font-size: 16px;">
                    รหัสสมาชิก: <strong>#{{ sprintf('%05d', $user->id) }}</strong> | บัญชีผู้ใช้: <strong>{{ $user->username }}</strong>
                </p>
            </div>
            <div>
                <a href="{{ route('admin.users.index') }}" class="btn btn-outline-secondary px-4 py-2 text-nowrap" style="font-size: 16px; border-radius: 8px;">
                    <i class="fas fa-arrow-left me-1"></i> <span>กลับหน้ารายชื่อสมาชิก</span>
                </a>
            </div>
        </div>
    </div>

    {{-- Single-Error Filter Banner: แสดงเฉพาะข้อผิดพลาดแรกสุดเสมอ --}}
    @if ($errors->any())
        <div class="alert alert-danger alert-dismissible fade show text-white shadow-sm mb-4" role="alert" style="border-radius: 10px; background-color: #dc2626;">
            <div class="d-flex align-items-center">
                <i class="fas fa-exclamation-triangle fa-2x me-3"></i>
                <div>
                    <h6 class="text-white fw-bold mb-0">ข้อมูลที่กรอกไม่ถูกต้อง [ERR-VAL-001]</h6>
                    <span class="text-white" style="font-size: 16px;">{{ $errors->all()[0] }}</span>
                </div>
            </div>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    @endif

    <form id="userEditForm" action="{{ route('admin.users.update', $user->id) }}" method="POST" novalidate>
        @csrf
        @method('PUT')
        <div class="row g-4">
            {{-- ฝั่งซ้าย: ข้อมูลผู้ใช้งาน --}}
            <div class="col-lg-8">
                <div class="card border shadow-sm mb-4" style="background: #ffffff; border-color: #e2e8f0; border-radius: 12px;">
                    <div class="card-header bg-white border-bottom p-4">
                        <h5 class="fw-bold text-dark mb-0" style="font-size: 20px;">
                            <i class="fas fa-id-card text-primary me-2"></i> ข้อมูลบัญชีและรายละเอียดส่วนบุคคล
                        </h5>
                    </div>
                    <div class="card-body p-4">
                        {{-- 1. บัญชีเข้าสู่ระบบ --}}
                        <h6 class="text-secondary fw-bold border-bottom pb-2 mb-3" style="font-size: 16px;">
                            <i class="fas fa-key text-primary me-1"></i> 1. บัญชีสำหรับเข้าสู่ระบบ
                        </h6>
                        <div class="row g-3 mb-4">
                            <div class="col-md-6">
                                <label for="username" class="form-label fw-bold text-dark" style="font-size: 16px;">
                                    ชื่อผู้ใช้งาน (Username) <span class="text-danger">*</span>
                                </label>
                                <input type="text" class="form-control @error('username') is-invalid @enderror" 
                                       id="username" name="username" value="{{ old('username', $user->username) }}"
                                       style="height: 48px; font-size: 16px;">
                                <div class="invalid-feedback fs-6"></div>
                                @error('username') <div class="invalid-feedback fs-6">{{ $message }}</div> @enderror
                            </div>
                            <div class="col-md-6">
                                <label for="password" class="form-label fw-bold text-dark" style="font-size: 16px;">
                                    รหัสผ่านใหม่ (ปล่อยว่างหากไม่ต้องการเปลี่ยน)
                                </label>
                                <input type="password" class="form-control @error('password') is-invalid @enderror" 
                                       id="password" name="password" placeholder="•••••••• (อย่างน้อย 6 ตัวอักษร)"
                                       style="height: 48px; font-size: 16px;">
                                <div class="invalid-feedback fs-6"></div>
                                @error('password') <div class="invalid-feedback fs-6">{{ $message }}</div> @enderror
                            </div>
                        </div>

                        {{-- 2. ข้อมูลส่วนบุคคล --}}
                        <h6 class="text-secondary fw-bold border-bottom pb-2 mb-3" style="font-size: 16px;">
                            <i class="fas fa-user text-primary me-1"></i> 2. รายละเอียดส่วนบุคคล
                        </h6>
                        <div class="row g-3 mb-4">
                            {{-- Prefix: สั้นกะทัดรัด (col-5 บนมือถือ ให้เห็นคำว่า นางสาว ได้พอดี, col-sm-3 บนแท็บเล็ต, col-md-2 บนจอใหญ่) --}}
                            <div class="col-5 col-sm-3 col-md-2">
                                <label for="prefix" class="form-label fw-bold text-dark" style="font-size: 16px;">คำนำหน้า</label>
                                <select class="form-select px-2" id="prefix" name="prefix" style="height: 48px; font-size: 15px;">
                                    <option value="นาย" {{ old('prefix', $user->prefix) == 'นาย' ? 'selected' : '' }}>นาย</option>
                                    <option value="นาง" {{ old('prefix', $user->prefix) == 'นาง' ? 'selected' : '' }}>นาง</option>
                                    <option value="นางสาว" {{ old('prefix', $user->prefix) == 'นางสาว' ? 'selected' : '' }}>นางสาว</option>
                                </select>
                            </div>
                            {{-- Firstname: สัดส่วนกว้างกว่าคำนำหน้า (col-7 บนมือถือวางคู่กับคำนำหน้า, col-sm-4 บนแท็บเล็ต, col-md-5 บนจอใหญ่) --}}
                            <div class="col-7 col-sm-4 col-md-5">
                                <label for="firstname" class="form-label fw-bold text-dark" style="font-size: 16px;">
                                    ชื่อจริง <span class="text-danger">*</span>
                                </label>
                                <input type="text" class="form-control @error('firstname') is-invalid @enderror" 
                                       id="firstname" name="firstname" value="{{ old('firstname', $user->firstname) }}"
                                       style="height: 48px; font-size: 16px;">
                                <div class="invalid-feedback fs-6"></div>
                                @error('firstname') <div class="invalid-feedback fs-6">{{ $message }}</div> @enderror
                            </div>
                            {{-- Lastname: เต็มบรรทัดบนมือถือ หรือแบ่งครึ่งบนจอใหญ่ (col-12 บนมือถือ, col-sm-5 บนแท็บเล็ต, col-md-5 บนจอใหญ่) --}}
                            <div class="col-12 col-sm-5 col-md-5">
                                <label for="lastname" class="form-label fw-bold text-dark" style="font-size: 16px;">
                                    นามสกุล <span class="text-danger">*</span>
                                </label>
                                <input type="text" class="form-control @error('lastname') is-invalid @enderror" 
                                       id="lastname" name="lastname" value="{{ old('lastname', $user->lastname) }}"
                                       style="height: 48px; font-size: 16px;">
                                <div class="invalid-feedback fs-6"></div>
                                @error('lastname') <div class="invalid-feedback fs-6">{{ $message }}</div> @enderror
                            </div>
                            <div class="col-12 col-md-6">
                                <label for="phone" class="form-label fw-bold text-dark" style="font-size: 16px;">
                                    <i class="fas fa-phone text-muted me-1"></i> เบอร์โทรศัพท์ (10 หลัก)
                                </label>
                                <input type="text" class="form-control @error('phone') is-invalid @enderror" 
                                       id="phone" name="phone" value="{{ old('phone', $user->phone) }}" maxlength="10"
                                       style="height: 48px; font-size: 16px;">
                                <div class="invalid-feedback fs-6"></div>
                                @error('phone') <div class="invalid-feedback fs-6">{{ $message }}</div> @enderror
                            </div>
                            <div class="col-12 col-md-6">
                                <label for="id_card" class="form-label fw-bold text-dark" style="font-size: 16px;">
                                    <i class="fas fa-address-card text-muted me-1"></i> เลขบัตรประชาชน (13 หลัก)
                                </label>
                                <input type="text" class="form-control @error('id_card') is-invalid @enderror" 
                                       id="id_card" name="id_card" value="{{ old('id_card', $user->id_card) }}" maxlength="13"
                                       style="height: 48px; font-size: 16px;">
                                <div class="invalid-feedback fs-6"></div>
                                @error('id_card') <div class="invalid-feedback fs-6">{{ $message }}</div> @enderror
                            </div>
                            {{-- วันเกิด: Thai Datepicker พ.ศ. --}}
                            <div class="col-12 col-md-6">
                                <label for="birthdate_display" class="form-label fw-bold text-dark" style="font-size: 16px;">
                                    <i class="fas fa-calendar-day text-muted me-1"></i> วัน/เดือน/ปีเกิด (พ.ศ.)
                                </label>
                                <div class="input-group">
                                    <input type="text" id="birthdate_display" class="form-control datepicker-thai" 
                                           placeholder="วว/ดด/ปปปป (พ.ศ.)" style="height: 48px; font-size: 16px;" autocomplete="off">
                                    <input type="hidden" name="birthdate" id="birthdate" value="{{ old('birthdate', $user->birthdate ?? '') }}">
                                    <span class="input-group-text bg-light"><i class="fas fa-calendar-alt text-primary"></i></span>
                                </div>
                                <small class="text-secondary">เลือกเป็น พ.ศ. ระบบแปลงเป็น ค.ศ. อัตโนมัติ</small>
                            </div>
                        </div>

                        {{-- 3. พื้นที่และที่อยู่ --}}
                        <h6 class="text-secondary fw-bold border-bottom pb-2 mb-3" style="font-size: 16px;">
                            <i class="fas fa-map-marker-alt text-primary me-1"></i> 3. ข้อมูลพื้นที่รับผิดชอบและที่อยู่
                        </h6>
                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label for="zone_id" class="form-label fw-bold text-dark" style="font-size: 16px;">
                                    โซน (Zone) <span class="text-danger">*</span>
                                </label>
                                <select class="form-select @error('zone_id') is-invalid @enderror" id="zone_id" name="zone_id" style="height: 48px; font-size: 16px;">
                                    @foreach($zones as $zone)
                                        <option value="{{ $zone->id }}" {{ old('zone_id', $user->zone_id) == $zone->id ? 'selected' : '' }}>
                                            {{ $zone->zone_name }}
                                        </option>
                                    @endforeach
                                </select>
                                <div class="invalid-feedback fs-6"></div>
                            </div>
                            <div class="col-md-6">
                                <label for="subzone_id" class="form-label fw-bold text-dark" style="font-size: 16px;">
                                    ซอย/ชุมชนย่อย (Subzone) <span class="text-danger">*</span>
                                </label>
                                <select class="form-select @error('subzone_id') is-invalid @enderror" id="subzone_id" name="subzone_id" style="height: 48px; font-size: 16px;">
                                    @foreach($subzones as $sub)
                                        <option value="{{ $sub->id }}" {{ old('subzone_id', $user->subzone_id) == $sub->id ? 'selected' : '' }}>
                                            {{ $sub->subzone_name }}
                                        </option>
                                    @endforeach
                                </select>
                                <div class="invalid-feedback fs-6"></div>
                            </div>
                            <div class="col-md-12">
                                <label for="address" class="form-label fw-bold text-dark" style="font-size: 16px;">
                                    เลขที่บ้าน / รายละเอียดที่อยู่เพิ่มเติม
                                </label>
                                <input type="text" class="form-control" id="address" name="address" 
                                       value="{{ old('address', $user->address) }}"
                                       style="height: 48px; font-size: 16px;">
                            </div>
                        </div>

                        <div class="row p-3 bg-light rounded-3 border">
                            <div class="col-12 col-sm-4 mb-2 mb-sm-0">
                                <small class="text-secondary fw-bold">ตำบล/แขวง</small>
                                <div class="fw-bold text-dark" style="font-size: 16px;">{{ $defaultAddress['district'] ?? '-' }}</div>
                            </div>
                            <div class="col-12 col-sm-4 mb-2 mb-sm-0">
                                <small class="text-secondary fw-bold">อำเภอ/เขต</small>
                                <div class="fw-bold text-dark" style="font-size: 16px;">{{ $defaultAddress['amphure'] ?? '-' }}</div>
                            </div>
                            <div class="col-12 col-sm-4">
                                <small class="text-secondary fw-bold">จังหวัด</small>
                                <div class="fw-bold text-dark" style="font-size: 16px;">{{ $defaultAddress['province'] ?? '-' }}</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            {{-- ฝั่งขวา: การจัดการบริการ --}}
            <div class="col-lg-4">
                <div class="card border shadow-sm sticky-top" style="top: 20px; background: #ffffff; border-color: #e2e8f0; border-radius: 12px;">
                    <div class="card-header bg-white border-bottom p-4">
                        <h5 class="fw-bold text-dark mb-0" style="font-size: 18px;">
                            <i class="fas fa-check-circle text-success me-2"></i> สถานะบริการในปัจจุบัน
                        </h5>
                    </div>
                    <div class="card-body p-4">
                        {{-- 1. ธนาคารขยะรีไซเคิล --}}
                        <div class="form-check form-switch mb-3 p-3 bg-light rounded-3 border-start border-success border-4">
                            <input class="form-check-input ms-0" type="checkbox" name="svc_recycle" id="svc_recycle" value="1" 
                                   {{ $user->recycleBankAccount ? 'checked' : '' }} 
                                   {{ auth()->user()->hasAnyRole(['Super Admin', 'Admin', 'Recycle Bank Staff']) ? '' : 'disabled' }}>
                            <label class="form-check-label fw-bold ms-4 text-dark" for="svc_recycle" style="font-size: 16px;">ธนาคารขยะรีไซเคิล</label>
                        </div>

                        {{-- 2. ธนาคารขยะเปียก --}}
                        <div class="form-check form-switch mb-3 p-3 bg-light rounded-3 border-start border-info border-4">
                            <input class="form-check-input ms-0" type="checkbox" name="svc_food_waste" id="svc_food_waste" value="1" 
                                   {{ $user->foodWasteBankAccount ? 'checked' : '' }} 
                                   {{ auth()->user()->hasAnyRole(['Super Admin', 'Admin', 'FoodWaste Staff']) ? '' : 'disabled' }}>
                            <label class="form-check-label fw-bold ms-4 text-dark" for="svc_food_waste" style="font-size: 16px;">ธนาคารขยะเปียก</label>
                        </div>

                        {{-- 3. จัดการขยะรายปี --}}
                        <div class="form-check form-switch mb-4 p-3 bg-light rounded-3 border-start border-warning border-4">
                            <input class="form-check-input ms-0" type="checkbox" name="svc_annual_trash" id="svc_annual_trash" value="1" 
                                   {{ $user->annualTrashSubscription ? 'checked' : '' }} 
                                   {{ auth()->user()->hasAnyRole(['Super Admin', 'Admin', 'Annual Trash Staff']) ? '' : 'disabled' }}>
                            <label class="form-check-label fw-bold ms-4 text-dark" for="svc_annual_trash" style="font-size: 16px;">ค่าขยะรายปี (เทศบาล)</label>
                        </div>

                        <div class="d-grid gap-2">
                            <button type="submit" id="btnUpdateUser" class="btn btn-primary py-3 fw-bold shadow-sm" style="font-size: 18px; border-radius: 8px;">
                                <i class="fas fa-save me-1"></i> อัปเดตข้อมูลสมาชิก
                            </button>
                            <a href="{{ route('admin.users.index') }}" class="btn btn-outline-secondary py-2" style="font-size: 16px; border-radius: 8px;">
                                <i class="fas fa-times me-1"></i> ยกเลิก
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>

    {{-- 💧 การ์ดแสดงรายการมิเตอร์น้ำประปาในครอบครอง --}}
    <div class="card border shadow-sm mt-4" style="background: #ffffff; border-color: #e2e8f0; border-radius: 12px;">
        <div class="card-header bg-white border-bottom p-4 d-flex justify-content-between align-items-center">
            <h5 class="fw-bold text-dark mb-0" style="font-size: 20px;">
                <i class="fas fa-tint text-info me-2"></i> มิเตอร์น้ำประปาในครอบครอง ({{ $user->usermeterinfos->count() }} เครื่อง)
            </h5>
            <button type="button" class="btn btn-outline-info fw-bold px-3 py-2" data-bs-toggle="modal" data-bs-target="#addMeterModal" style="border-radius: 8px;">
                <i class="fas fa-plus me-1"></i> ผูกมิเตอร์น้ำประปาใหม่
            </button>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table align-items-center table-hover mb-0" style="font-size: 16px;">
                    <thead class="bg-light">
                        <tr>
                            <th class="text-uppercase text-secondary text-sm font-weight-bolder ps-4 py-3">เลขมิเตอร์ / ชื่อระบุ</th>
                            <th class="text-uppercase text-secondary text-sm font-weight-bolder py-3">สถานที่ติดตั้ง / บ้านเลขที่</th>
                            <th class="text-uppercase text-secondary text-sm font-weight-bolder py-3">โซน / ซอย</th>
                            <th class="text-uppercase text-secondary text-sm font-weight-bolder py-3">ประเภทมิเตอร์</th>
                            <th class="text-center text-uppercase text-secondary text-sm font-weight-bolder py-3">สถานะ</th>
                            <th class="text-center text-uppercase text-secondary text-sm font-weight-bolder py-3">จัดการ</th>
                        </tr>
                    </thead>
                    <tbody>
                        @forelse($user->usermeterinfos as $meter)
                            <tr class="border-bottom">
                                <td class="ps-4 py-3">
                                    <div class="fw-bold text-dark" style="font-size: 17px;">{{ $meter->meternumber }}</div>
                                    <small class="text-secondary">{{ $meter->submeter_name ?? 'มิเตอร์หลัก' }}</small>
                                </td>
                                <td class="py-3 text-secondary">{{ $meter->location ?? '-' }}</td>
                                <td class="py-3">
                                    <span class="badge bg-light text-dark border">
                                        {{ $meter->undertake_zone->zone_name ?? '-' }} / {{ $meter->undertake_subzone->subzone_name ?? '-' }}
                                    </span>
                                </td>
                                <td class="py-3 text-secondary">{{ $meter->metertype->metertype_name ?? '-' }}</td>
                                <td class="text-center py-3">
                                    @if($meter->status == 1)
                                        <span class="badge bg-success text-white px-3 py-2">เปิดใช้งานปกติ</span>
                                    @else
                                        <span class="badge bg-danger text-white px-3 py-2">ระงับการใช้น้ำ</span>
                                    @endif
                                </td>
                                <td class="text-center py-3">
                                    <form action="{{ route('admin.users.delete_meter', $meter->id) }}" method="POST" class="d-inline form-delete-meter">
                                        @csrf
                                        @method('DELETE')
                                        <button type="button" class="btn btn-outline-danger btn-sm px-3 py-1 btn-delete-meter" style="border-radius: 6px;">
                                            <i class="fas fa-unlink me-1"></i> ยกเลิกผูก
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        @empty
                            <tr>
                                <td colspan="6" class="text-center py-4 text-muted">
                                    <i class="fas fa-tint-slash fa-2x mb-2 text-secondary"></i>
                                    <p class="mb-0 fs-6">ไม่มีมิเตอร์น้ำประปาผูกกับบัญชีนี้</p>
                                </td>
                            </tr>
                        @endforelse
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

{{-- Modal ผูกมิเตอร์ --}}
<div class="modal fade" id="addMeterModal" tabindex="-1" role="dialog" aria-labelledby="addMeterModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered" role="document">
        <div class="modal-content" style="border-radius: 12px;">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-bold text-dark" id="addMeterModalLabel">ผูกมิเตอร์น้ำประปาเข้ากับสมาชิก</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="{{ route('admin.users.add_meter', $user->id) }}" method="POST" novalidate>
                @csrf
                <div class="modal-body p-4">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-bold text-dark" style="font-size: 16px;">หมายเลขมิเตอร์ (Meternumber) <span class="text-danger">*</span></label>
                            <input type="text" name="meternumber" class="form-control" placeholder="เช่น 66-00123" required style="height: 48px;">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold text-dark" style="font-size: 16px;">ชื่อระบุมิเตอร์</label>
                            <input type="text" name="submeter_name" class="form-control" placeholder="เช่น บ้านพักอาศัย, ร้านค้า" style="height: 48px;">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold text-dark" style="font-size: 16px;">โซนรับผิดชอบ <span class="text-danger">*</span></label>
                            <select class="form-select" id="undertake_zone_id" name="undertake_zone_id" required style="height: 48px;">
                                @foreach($zones as $z)
                                    <option value="{{ $z->id }}" {{ $user->zone_id == $z->id ? 'selected' : '' }}>{{ $z->zone_name }}</option>
                                @endforeach
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold text-dark" style="font-size: 16px;">ซอย/ชุมชนย่อย <span class="text-danger">*</span></label>
                            <select class="form-select" id="modal_undertake_subzone_id" name="undertake_subzone_id" required style="height: 48px;">
                                <option value="">-- กรุณาเลือกโซนก่อน --</option>
                            </select>
                        </div>
                        <div class="col-md-12">
                            <label class="form-label fw-bold text-dark" style="font-size: 16px;">สถานที่ติดตั้งจริง</label>
                            <input type="text" name="location" class="form-control" value="{{ $user->address }}" style="height: 48px;">
                        </div>
                    </div>
                </div>
                <div class="modal-footer border-top">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal" style="min-height: 44px;">ยกเลิก</button>
                    <button type="submit" class="btn btn-info fw-bold px-4" style="min-height: 44px;">
                        <i class="fas fa-save me-1"></i> บันทึกผูกมิเตอร์
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
@endsection

@section('script')
<script>
$(document).ready(function() {
    function loadSubzones(zoneId, $targetSelect, selectedSubzoneId = null) {
        if (!zoneId) return;
        $targetSelect.empty().append('<option value="">-- กำลังโหลด... --</option>');

        $.ajax({
            url: `{{ url('admin/subzone') }}/${zoneId}/getSubzone`,
            type: "GET",
            success: function(data) {
                $targetSelect.empty().append('<option value="">-- เลือกซอย/ชุมชนย่อย --</option>');
                $.each(data, function(key, value) {
                    var isSelected = (value.id == selectedSubzoneId) ? 'selected' : '';
                    $targetSelect.append(`<option value="${value.id}" ${isSelected}>${value.subzone_name}</option>`);
                });
            },
            error: function (xhr) {
                AppNotification.handleAjaxError(xhr);
            }
        });
    }

    $('#zone_id').on('change', function() {
        loadSubzones($(this).val(), $('#subzone_id'));
    });

    $('#undertake_zone_id').on('change', function() {
        loadSubzones($(this).val(), $('#modal_undertake_subzone_id'));
    });

    var currentModalZone = $('#undertake_zone_id').val();
    var currentModalSubzone = "{{ old('undertake_subzone_id', $user->subzone_id) }}";
    if (currentModalZone) {
        loadSubzones(currentModalZone, $('#modal_undertake_subzone_id'), currentModalSubzone);
    }

    // Delete meter confirmation with Two-Tier modal
    $('.btn-delete-meter').on('click', function () {
        const form = $(this).closest('.form-delete-meter');
        AppNotification.confirm(
            'ยืนยันการยกเลิกการผูกมิเตอร์น้ำ?',
            'มิเตอร์นี้จะถูกปลดออกจากการครอบครองของสมาชิกท่านนี้',
            'ยกเลิกผูกมิเตอร์',
            function () {
                form.submit();
            }
        );
    });

    // Client-side Validation with Single-Error Filter
    initFormValidation('#userEditForm', {
        username: { required: true, minlength: 3 },
        firstname: { required: true },
        lastname: { required: true },
        zone_id: { required: true },
        subzone_id: { required: true }
    }, {
        username: { required: "กรุณาระบุชื่อผู้ใช้งาน", minlength: "ชื่อผู้ใช้งานต้องมีความยาวอย่างน้อย 3 ตัวอักษร" },
        firstname: { required: "กรุณาระบุชื่อจริงของสมาชิก" },
        lastname: { required: "กรุณาระบุนามสกุลของสมาชิก" },
        zone_id: { required: "กรุณาเลือกโซนพื้นที่รับผิดชอบ" },
        subzone_id: { required: "กรุณาเลือกซอยหรือชุมชนย่อย" }
    }, function (form) {
        AppNotification.confirm(
            'ยืนยันการบันทึกการแก้ไขข้อมูล?',
            'กรุณาตรวจสอบความถูกต้องของข้อมูลก่อนยืนยัน',
            'อัปเดตข้อมูล',
            function () {
                form.submit();
            }
        );
    });
});
</script>
@endsection
