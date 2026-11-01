@extends('layouts.super-admin')
@section('title_page', 'เพิ่มผู้ใช้งานใหม่')

@section('content')
<div class="container-fluid py-2">
    <!-- Header Card: Fully Responsive & Mobile-Optimized -->
    <div class="card border mb-4 shadow-sm" style="background: #ffffff; border-color: #e2e8f0; border-radius: 12px;">
        <div class="card-body p-3 p-md-4">
            <div class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center gap-3">
                <div>
                    <span class="badge bg-primary text-white px-3 py-2 fs-6 mb-2">
                        <i class="fas fa-user-plus me-1"></i> ทะเบียนสมาชิก
                    </span>
                    <h3 class="fw-bold text-dark mb-1" style="font-size: 24px;">
                        เพิ่มผู้ใช้งานใหม่และกำหนดสิทธิ์บริการ
                    </h3>
                    <p class="text-secondary mb-0" style="font-size: 15px;">
                        กรอกข้อมูลสมาชิกใหม่เพื่อเปิดสิทธิ์การใช้งานระบบประปา, ธนาคารขยะ, หรือขยะรายปี
                    </p>
                </div>
                <div class="d-flex flex-column flex-sm-row gap-2 w-100 w-md-auto justify-content-md-end">
                    <button type="button" class="btn btn-outline-success fw-bold px-3 py-2 text-nowrap d-inline-flex align-items-center justify-content-center" data-bs-toggle="modal" data-bs-target="#importUserModal" style="min-height: 44px; font-size: 15px; border-radius: 8px;">
                        <i class="fas fa-file-excel me-2 flex-shrink-0"></i>
                        <span>นำเข้าข้อมูลด้วย Excel</span>
                    </button>
                    <a href="{{ route('admin.users.download_template') }}" class="btn btn-outline-info fw-bold px-3 py-2 text-nowrap d-inline-flex align-items-center justify-content-center" style="min-height: 44px; font-size: 15px; border-radius: 8px;">
                        <i class="fas fa-file-download me-2 flex-shrink-0"></i>
                        <span>ดาวน์โหลดตัวอย่าง (.xlsx)</span>
                    </a>
                </div>
            </div>
        </div>
    </div>

    {{-- Single-Error Filter Banner: แสดงเฉพาะข้อผิดพลาดแรกสุดเสมอ เพื่อลดความสับสน --}}
    @if ($errors->any())
        <div class="alert alert-danger alert-dismissible fade show text-white shadow-sm mb-4" role="alert" style="border-radius: 10px; background-color: #dc2626;">
            <div class="d-flex align-items-center">
                <i class="fas fa-exclamation-triangle fa-2x me-3 flex-shrink-0"></i>
                <div>
                    <h6 class="text-white fw-bold mb-0">ข้อมูลที่กรอกไม่ถูกต้อง [ERR-VAL-001]</h6>
                    <span class="text-white" style="font-size: 15px;">{{ $errors->all()[0] }}</span>
                </div>
            </div>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    @endif

    {{-- Form บันทึกข้อมูล: ปิด HTML5 Native Validation ด้วย novalidate --}}
    <form id="userCreateForm" action="{{ route('admin.users.store') }}" method="POST" novalidate>
        @csrf
        <div class="row g-4">
            {{-- ฝั่งซ้าย: ข้อมูลผู้ใช้งาน --}}
            <div class="col-12 col-lg-8">
                <div class="card border shadow-sm mb-4" style="background: #ffffff; border-color: #e2e8f0; border-radius: 12px;">
                    <div class="card-header bg-white border-bottom p-3 p-md-4">
                        <h5 class="fw-bold text-dark mb-0" style="font-size: 19px;">
                            <i class="fas fa-id-card text-primary me-2"></i> ข้อมูลบัญชีและรายละเอียดส่วนบุคคล
                        </h5>
                        <small class="text-muted" style="font-size: 14px;">ช่องที่มีเครื่องหมาย (<span class="text-danger fw-bold">*</span>) จำเป็นต้องกรอกข้อมูลให้ครบถ้วน</small>
                    </div>
                    <div class="card-body p-3 p-md-4">
                        {{-- 1. บัญชีเข้าสู่ระบบ --}}
                        <h6 class="text-secondary fw-bold border-bottom pb-2 mb-3" style="font-size: 16px;">
                            <i class="fas fa-key text-primary me-1"></i> 1. บัญชีสำหรับเข้าสู่ระบบ
                        </h6>
                        <div class="row g-3 mb-4">
                            <div class="col-12 col-md-6">
                                <label for="username" class="form-label fw-bold text-dark" style="font-size: 16px;">
                                    ชื่อผู้ใช้งาน (Username) <span class="text-danger">*</span>
                                </label>
                                <input type="text" class="form-control @error('username') is-invalid @enderror" 
                                       id="username" name="username" placeholder="เช่น somchai2025" value="{{ old('username') }}"
                                       style="height: 48px; font-size: 16px;">
                                <div class="invalid-feedback fs-6"></div>
                                @error('username') <div class="invalid-feedback fs-6">{{ $message }}</div> @enderror
                            </div>
                            <div class="col-12 col-md-6">
                                <label for="password" class="form-label fw-bold text-dark" style="font-size: 16px;">
                                    รหัสผ่าน (Password) <span class="text-danger">*</span>
                                </label>
                                <input type="password" class="form-control @error('password') is-invalid @enderror" 
                                       id="password" name="password" placeholder="ความยาวอย่างน้อย 6 ตัวอักษร"
                                       style="height: 48px; font-size: 16px;">
                                <div class="invalid-feedback fs-6"></div>
                                @error('password') <div class="invalid-feedback fs-6">{{ $message }}</div> @enderror
                            </div>
                        </div>

                        {{-- 2. ข้อมูลส่วนบุคคล (Proportional Grid for Mobile & Desktop) --}}
                        <h6 class="text-secondary fw-bold border-bottom pb-2 mb-3" style="font-size: 16px;">
                            <i class="fas fa-user text-primary me-1"></i> 2. รายละเอียดส่วนบุคคล
                        </h6>
                        <div class="row g-3 mb-4">
                            {{-- แถวชื่อ: คำนำหน้าสั้น (col-5 col-sm-3 col-md-2) คู่กับชื่อจริง (col-7 col-sm-4 col-md-5) และนามสกุล (col-12 col-sm-5 col-md-5) --}}
                            <div class="col-5 col-sm-3 col-md-2">
                                <label for="prefix" class="form-label fw-bold text-dark text-nowrap" style="font-size: 16px;">คำนำหน้า</label>
                                <select class="form-select px-2" id="prefix" name="prefix" style="height: 48px; font-size: 15px;">
                                    <option value="นาย" {{ old('prefix', 'นาย') == 'นาย' ? 'selected' : '' }}>นาย</option>
                                    <option value="นาง" {{ old('prefix', 'นาง') == 'นาง' ? 'selected' : '' }}>นาง</option>
                                    <option value="นางสาว" {{ old('prefix', 'นางสาว') == 'นางสาว' ? 'selected' : '' }}>นางสาว</option>
                                </select>
                            </div>
                            <div class="col-7 col-sm-4 col-md-5">
                                <label for="firstname" class="form-label fw-bold text-dark text-nowrap" style="font-size: 16px;">
                                    ชื่อจริง <span class="text-danger">*</span>
                                </label>
                                <input type="text" class="form-control @error('firstname') is-invalid @enderror" 
                                       id="firstname" name="firstname" placeholder="ระบุชื่อจริง" value="{{ old('firstname') }}"
                                       style="height: 48px; font-size: 16px;">
                                <div class="invalid-feedback fs-6"></div>
                                @error('firstname') <div class="invalid-feedback fs-6">{{ $message }}</div> @enderror
                            </div>
                            <div class="col-12 col-sm-5 col-md-5">
                                <label for="lastname" class="form-label fw-bold text-dark text-nowrap" style="font-size: 16px;">
                                    นามสกุล <span class="text-danger">*</span>
                                </label>
                                <input type="text" class="form-control @error('lastname') is-invalid @enderror" 
                                       id="lastname" name="lastname" placeholder="ระบุนามสกุล" value="{{ old('lastname') }}"
                                       style="height: 48px; font-size: 16px;">
                                <div class="invalid-feedback fs-6"></div>
                                @error('lastname') <div class="invalid-feedback fs-6">{{ $message }}</div> @enderror
                            </div>

                            {{-- แถวประจำตัว: เลขบัตรประชาชน (col-12 col-md-6) และ วันเดือนปีเกิด พ.ศ. (col-12 col-md-6) --}}
                            <div class="col-12 col-md-6">
                                <label for="id_card" class="form-label fw-bold text-dark" style="font-size: 16px;">
                                    เลขประจำตัวประชาชน (13 หลัก)
                                </label>
                                <input type="text" class="form-control @error('id_card') is-invalid @enderror" 
                                       id="id_card" name="id_card" placeholder="เลขบัตร 13 หลัก" value="{{ old('id_card') }}" maxlength="13"
                                       style="height: 48px; font-size: 16px;">
                                <div class="invalid-feedback fs-6"></div>
                            </div>
                            <div class="col-12 col-md-6">
                                <label for="birthdate_display" class="form-label fw-bold text-dark" style="font-size: 16px;">
                                    วัน/เดือน/ปีเกิด (พ.ศ.)
                                </label>
                                <div class="input-group">
                                    <input type="text" id="birthdate_display" class="form-control datepicker-thai" 
                                           placeholder="วว/ดด/ปปปป (พ.ศ.)" style="height: 48px; font-size: 16px;" autocomplete="off">
                                    <input type="hidden" name="birthdate" id="birthdate" value="{{ old('birthdate') }}">
                                    <span class="input-group-text bg-light"><i class="fas fa-calendar-alt text-primary"></i></span>
                                </div>
                            </div>

                            {{-- แถวข้อมูลติดต่อ: เบอร์โทรศัพท์มือถือ (col-12 col-md-6) --}}
                            <div class="col-12 col-md-6">
                                <label for="phone" class="form-label fw-bold text-dark" style="font-size: 16px;">
                                    หมายเลขโทรศัพท์มือถือ
                                </label>
                                <input type="text" class="form-control @error('phone') is-invalid @enderror" 
                                       id="phone" name="phone" placeholder="เช่น 0812345678" value="{{ old('phone') }}" maxlength="10"
                                       style="height: 48px; font-size: 16px;">
                                <div class="invalid-feedback fs-6"></div>
                            </div>
                        </div>

                        {{-- 3. พื้นที่และที่อยู่ --}}
                        <h6 class="text-secondary fw-bold border-bottom pb-2 mb-3" style="font-size: 16px;">
                            <i class="fas fa-map-marker-alt text-primary me-1"></i> 3. ข้อมูลพื้นที่รับผิดชอบและที่อยู่
                        </h6>
                        <div class="row g-3 mb-3">
                            <div class="col-12 col-md-6">
                                <label for="zone_id" class="form-label fw-bold text-dark" style="font-size: 16px;">
                                    โซน (Zone) <span class="text-danger">*</span>
                                </label>
                                <select class="form-select @error('zone_id') is-invalid @enderror" id="zone_id" name="zone_id" style="height: 48px; font-size: 16px;">
                                    <option value="">-- กรุณาเลือกโซน --</option>
                                    @foreach($zones as $zone)
                                        <option value="{{ $zone->id }}" {{ old('zone_id') == $zone->id ? 'selected' : '' }}>
                                            {{ $zone->zone_name }}
                                        </option>
                                    @endforeach
                                </select>
                                <div class="invalid-feedback fs-6"></div>
                            </div>
                            <div class="col-12 col-md-6">
                                <label for="subzone_id" class="form-label fw-bold text-dark" style="font-size: 16px;">
                                    ซอย/ชุมชนย่อย (Subzone) <span class="text-danger">*</span>
                                </label>
                                <select class="form-select @error('subzone_id') is-invalid @enderror" id="subzone_id" name="subzone_id" style="height: 48px; font-size: 16px;">
                                    <option value="">-- กรุณาเลือกโซนก่อน --</option>
                                </select>
                                <div class="invalid-feedback fs-6"></div>
                            </div>
                            <div class="col-12">
                                <label for="address" class="form-label fw-bold text-dark" style="font-size: 16px;">
                                    เลขที่บ้าน / อาคาร / ถนน / รายละเอียดที่อยู่เพิ่มเติม
                                </label>
                                <input type="text" class="form-control" id="address" name="address" 
                                       placeholder="เช่น 123/4 หมู่ 1 ถนนสุขุมวิท" value="{{ old('address') }}"
                                       style="height: 48px; font-size: 16px;">
                            </div>
                        </div>

                        {{-- ข้อมูลที่อยู่เทศบาลส่วนกลาง (Responsive Stacking on Mobile) --}}
                        <div class="row g-2 p-3 bg-light rounded-3 border">
                            <div class="col-12 col-sm-4">
                                <small class="text-secondary fw-bold">ตำบล/แขวง</small>
                                <div class="fw-bold text-dark" style="font-size: 16px;">{{ $defaultAddress['tambon'] ?? '-' }}</div>
                            </div>
                            <div class="col-12 col-sm-4">
                                <small class="text-secondary fw-bold">อำเภอ/เขต</small>
                                <div class="fw-bold text-dark" style="font-size: 16px;">{{ $defaultAddress['district'] ?? '-' }}</div>
                            </div>
                            <div class="col-12 col-sm-4">
                                <small class="text-secondary fw-bold">จังหวัด</small>
                                <div class="fw-bold text-dark" style="font-size: 16px;">{{ $defaultAddress['province'] ?? '-' }}</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            {{-- ฝั่งขวา: การเปิดบริการ (Sticky Sidebar on Desktop, Stacks on Mobile) --}}
            <div class="col-12 col-lg-4">
                <div class="card border shadow-sm sticky-top" style="top: 20px; background: #ffffff; border-color: #e2e8f0; border-radius: 12px;">
                    <div class="card-header bg-white border-bottom p-3 p-md-4">
                        <h5 class="fw-bold text-dark mb-0" style="font-size: 18px;">
                            <i class="fas fa-check-circle text-success me-2"></i> สิทธิ์และบริการเทศบาล
                        </h5>
                    </div>
                    <div class="card-body p-3 p-md-4">
                        {{-- 1. ธนาคารขยะรีไซเคิล --}}
                        <div class="form-check form-switch mb-3 p-3 bg-light rounded-3 border-start border-success border-4">
                            <input class="form-check-input ms-0 chk-service" type="checkbox" name="svc_recycle" id="svc_recycle" value="1"
                                   {{ auth()->user()->hasAnyRole(['Super Admin', 'Admin', 'Recycle Bank Staff']) ? 'checked' : 'disabled' }}>
                            <label class="form-check-label fw-bold ms-4 text-dark" for="svc_recycle" style="font-size: 16px;">ธนาคารขยะรีไซเคิล</label>
                            <p class="text-muted mb-0 ms-4" style="font-size: 14px;">เปิดบัญชีสะสมทรัพย์และแต้ม</p>
                        </div>

                        {{-- 2. ธนาคารขยะเปียก --}}
                        <div class="form-check form-switch mb-3 p-3 bg-light rounded-3 border-start border-info border-4">
                            <input class="form-check-input ms-0 chk-service" type="checkbox" name="svc_food_waste" id="svc_food_waste" value="1"
                                   {{ auth()->user()->hasAnyRole(['Super Admin', 'Admin', 'FoodWaste Staff']) ? '' : 'disabled' }}>
                            <label class="form-check-label fw-bold ms-4 text-dark" for="svc_food_waste" style="font-size: 16px;">ธนาคารขยะเปียก</label>
                            <p class="text-muted mb-0 ms-4" style="font-size: 14px;">ระบบถังหมักปุ๋ย AiroBact</p>
                        </div>

                        {{-- 3. ค่าขยะรายปี --}}
                        <div class="form-check form-switch mb-4 p-3 bg-light rounded-3 border-start border-warning border-4">
                            <input class="form-check-input ms-0 chk-service" type="checkbox" name="svc_annual_trash" id="svc_annual_trash" value="1"
                                   {{ auth()->user()->hasAnyRole(['Super Admin', 'Admin', 'Annual Trash Staff']) ? 'checked' : 'disabled' }}>
                            <label class="form-check-label fw-bold ms-4 text-dark" for="svc_annual_trash" style="font-size: 16px;">ค่าขยะรายปี</label>
                            <p class="text-muted mb-0 ms-4" style="font-size: 14px;">สิทธิ์ยกเว้น/จ่ายค่าขยะรายเดือน</p>
                        </div>

                        <div class="d-grid gap-2">
                            <button type="submit" id="btnSubmitUser" class="btn btn-success py-3 fw-bold shadow-sm d-inline-flex align-items-center justify-content-center" style="font-size: 18px; border-radius: 8px;">
                                <i class="fas fa-save me-2"></i>
                                <span>บันทึกและเปิดสิทธิ์</span>
                            </button>
                            <a href="{{ route('admin.users.index') }}" class="btn btn-outline-secondary py-2 d-inline-flex align-items-center justify-content-center" style="font-size: 16px; border-radius: 8px;">
                                <i class="fas fa-times me-2"></i>
                                <span>ยกเลิก</span>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</div>

{{-- Modal สำหรับ Import User --}}
<div class="modal fade" id="importUserModal" tabindex="-1" role="dialog" aria-labelledby="importUserModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content" style="border-radius: 12px;">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-bold text-dark" id="importUserModalLabel">นำเข้าข้อมูลผู้ใช้งานจาก Excel</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="{{ route('admin.users.import') }}" method="POST" enctype="multipart/form-data" novalidate>
                @csrf
                <div class="modal-body p-3 p-md-4">
                    <div class="text-center mb-4">
                        <i class="fas fa-file-excel fa-3x text-success mb-3"></i>
                        <p class="text-secondary" style="font-size: 16px;">กรุณาอัปโหลดไฟล์ Excel ตามรูปแบบที่ระบบกำหนด</p>
                        <a href="{{ route('admin.users.download_template') }}" class="btn btn-link text-info">
                            <i class="fas fa-download me-1"></i> ดาวน์โหลดไฟล์ตัวอย่าง (.xlsx)
                        </a>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold text-dark" style="font-size: 16px;">เลือกไฟล์ Excel</label>
                        <input type="file" name="file" class="form-control" accept=".xlsx, .xls" style="min-height: 48px;">
                    </div>
                </div>
                <div class="modal-footer border-top">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal" style="min-height: 44px;">ยกเลิก</button>
                    <button type="submit" class="btn btn-success fw-bold px-4 d-inline-flex align-items-center gap-2" style="min-height: 44px;">
                        <i class="fas fa-upload"></i>
                        <span>เริ่มการนำเข้า</span>
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
@endsection

@section('script')
<script>
$(document).ready(function () {
    // 1. Dynamic Subzone loading on Zone select
    $('#zone_id').on('change', function () {
        var zoneId = $(this).val();
        var $subzoneSelect = $('#subzone_id');
        $subzoneSelect.empty().append('<option value="">-- กำลังโหลดข้อมูล... --</option>');
        
        if (zoneId) {
            $.ajax({
                url: `{{ url('admin/subzone') }}/${zoneId}/getSubzone`,
                type: "GET",
                success: function (data) {
                    $subzoneSelect.empty().append('<option value="">-- เลือกซอย/ชุมชนย่อย --</option>');
                    $.each(data, function (key, value) {
                        $subzoneSelect.append('<option value="' + value.id + '">' + value.subzone_name + '</option>');
                    });
                },
                error: function (xhr) {
                    AppNotification.handleAjaxError(xhr);
                }
            });
        } else {
            $subzoneSelect.empty().append('<option value="">-- กรุณาเลือกโซนก่อน --</option>');
        }
    });

    var oldZone = "{{ old('zone_id') }}";
    if (oldZone) {
        $('#zone_id').trigger('change');
    }

    // 2. Client-Side Validation with Single-Error Filter (docs/UI_FORM_TABLE_STANDARDS.md)
    initFormValidation('#userCreateForm', {
        username: {
            required: true,
            minlength: 3
        },
        password: {
            required: true,
            minlength: 6
        },
        firstname: {
            required: true
        },
        lastname: {
            required: true
        },
        zone_id: {
            required: true
        },
        subzone_id: {
            required: true
        }
    }, {
        username: {
            required: "กรุณาระบุชื่อผู้ใช้งานสำหรับเข้าสู่ระบบ",
            minlength: "ชื่อผู้ใช้งานต้องมีความยาวอย่างน้อย 3 ตัวอักษร"
        },
        password: {
            required: "กรุณาระบุรหัสผ่าน",
            minlength: "รหัสผ่านต้องมีความยาวอย่างน้อย 6 ตัวอักษร"
        },
        firstname: {
            required: "กรุณาระบุชื่อจริงของสมาชิก"
        },
        lastname: {
            required: "กรุณาระบุนามสกุลของสมาชิก"
        },
        zone_id: {
            required: "กรุณาเลือกโซนพื้นที่รับผิดชอบ"
        },
        subzone_id: {
            required: "กรุณาเลือกซอยหรือชุมชนย่อย"
        }
    }, function (form) {
        AppNotification.confirm(
            'ยืนยันการบันทึกข้อมูลสมาชิก?',
            'กรุณาตรวจสอบความถูกต้องของข้อมูลก่อนยืนยัน',
            'บันทึกข้อมูล',
            function () {
                form.submit();
            }
        );
    });
});
</script>
@endsection
