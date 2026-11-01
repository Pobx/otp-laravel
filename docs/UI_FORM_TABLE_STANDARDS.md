# มาตรฐานการออกแบบ Form, Data Table, DatePicker พ.ศ., Validation และการจัดการ Error ของระบบ OTP 2025

**เอกสารอ้างอิงสถาปัตยกรรม:** [`docs/adr/ADR-0005-ui-form-table-validation-error-standards.md`](file:///Users/poppy.geidtiphong/Documents/workspace/homework/otp2025/docs/adr/ADR-0005-ui-form-table-validation-error-standards.md)  
**ตารางรหัสข้อผิดพลาด:** [`docs/ERROR_CODE_MAPPING.md`](file:///Users/poppy.geidtiphong/Documents/workspace/homework/otp2025/docs/ERROR_CODE_MAPPING.md)  
**กลุ่มเป้าหมายผู้ใช้งาน:** เจ้าหน้าที่เทศบาลและประชาชนทั่วไป อายุ 40+ ปี และผู้ที่มีทักษะคอมพิวเตอร์ระดับเริ่มต้น  
**เทคโนโลยีหลัก:** Laravel 13, Bootstrap 5.3 (AdminLTE 4), jQuery 3.7, DataTables Server-Side, Bootstrap-Datepicker-Thai, SweetAlert2

---

## 1. ผังโครงสร้างมาตรฐานหน้าจอ (Standard Page Layout Anatomy)

ทุกหน้าจอที่เป็นระบบงานหลัก (เช่น จัดการสมาชิก, ขยะรีไซเคิล, มิเตอร์น้ำ, คลังพัสดุ) จะประกอบด้วย 4 ส่วนตามลำดับ:

```
┌────────────────────────────────────────────────────────────────────────┐
│ 1. Header Card (หัวข้อระบบ, Breadcrumbs, และปุ่ม Action หลัก)          │
├────────────────────────────────────────────────────────────────────────┤
│ 2. Filter Card (ฟอร์มค้นหาข้อมูล และตัวกรองสถานะ/ช่วงวันที่)          │
├────────────────────────────────────────────────────────────────────────┤
│ 3. Data Table Card (ตารางแสดงผลข้อมูล Server-Side Ajax + Pagination)    │
└────────────────────────────────────────────────────────────────────────┘
```

---

## 2. มาตรฐาน Form ค้นหาข้อมูล (Search & Filter Form Specification)

### 2.1 โครงสร้าง UI
- บรรจุอยู่ใน `<div class="card border mb-4 shadow-sm" style="border-radius: 12px; background: #ffffff;">`
- **Header:** มีไอคอนแว่นขยาย `fas fa-search` พร้อมข้อความ *"ค้นหาและกรองข้อมูล"*
- **แถวค้นหาหลัก (Quick Search Row):**
  - ช่องกรอกค้นหาด่วน (เช่น ค้นหาด้วยชื่อ, เลขประจำตัวประชาชน, หรือหมายเลขมิเตอร์) ขนาดความสูง 48px
  - Dropdown ตัวกรองหลัก (เช่น โซนพื้นที่, ประเภทขยะ, สถานะการชำระเงิน)
- **แถวค้นหาขั้นสูง (Advanced Filters - Collapsible):**
  - ช่วงวันที่เริ่มต้น - วันที่สิ้นสุด (ใช้ Thai DatePicker พ.ศ.)
- **Action Buttons Bar:**
  - ปุ่ม **"🔍 ค้นหาข้อมูล"** (`.btn-primary`, ความสูง 48px, ขนาดตัวอักษร 16px)
  - ปุ่ม **"🔄 ล้างค่าการค้นหา"** (`.btn-outline-secondary`, ความสูง 48px) รีเซ็ตเงื่อนไขกลับเป็นค่าเริ่มต้นและรีโหลดตารางทันที

### 2.2 ตัวอย่างโค้ด Blade Form ค้นหาข้อมูล
```html
<div class="card border mb-4 shadow-sm" style="border-radius: 12px; background: #ffffff; border-color: #e2e8f0;">
    <div class="card-header bg-white border-bottom p-3">
        <h5 class="fw-bold text-dark mb-0 d-flex align-items-center gap-2" style="font-size: 18px;">
            <i class="fas fa-filter text-primary"></i> ค้นหาและกรองข้อมูล
        </h5>
    </div>
    <div class="card-body p-4">
        <form id="filterForm" class="row g-3" novalidate onsubmit="return false;">
            <!-- ช่องค้นหาคำหลัก -->
            <div class="col-md-4">
                <label class="form-label fw-bold text-dark" style="font-size: 16px;">คำค้นหา (ชื่อ / รหัสสมาชิก / เบอร์โทร)</label>
                <div class="input-group">
                    <span class="input-group-text bg-light border-end-0"><i class="fas fa-search text-muted"></i></span>
                    <input type="text" id="filter_keyword" class="form-control border-start-0" placeholder="พิมพ์คำค้นหา..." style="height: 48px; font-size: 16px;">
                </div>
            </div>

            <!-- ตัวกรองสถานะ -->
            <div class="col-md-3">
                <label class="form-label fw-bold text-dark" style="font-size: 16px;">สถานะ</label>
                <select id="filter_status" class="form-select" style="height: 48px; font-size: 16px;">
                    <option value="">-- แสดงทุกสถานะ --</option>
                    <option value="active">เปิดใช้งาน (Active)</option>
                    <option value="pending">รอดำเนินการ (Pending)</option>
                    <option value="inactive">ปิดใช้งาน (Inactive)</option>
                </select>
            </div>

            <!-- ตัวกรองวันที่ (พ.ศ.) -->
            <div class="col-md-3">
                <label class="form-label fw-bold text-dark" style="font-size: 16px;">ตั้งแต่วันที่</label>
                <div class="input-group">
                    <input type="text" id="filter_start_date_display" class="form-control datepicker-thai" placeholder="วว/ดด/ปปปป" style="height: 48px; font-size: 16px;" autocomplete="off">
                    <input type="hidden" id="filter_start_date" name="start_date">
                    <span class="input-group-text bg-light"><i class="fas fa-calendar-alt text-primary"></i></span>
                </div>
            </div>

            <!-- ปุ่มดำเนินการ -->
            <div class="col-md-2 d-flex align-items-end gap-2">
                <button type="button" id="btnSearch" class="btn btn-primary w-100 fw-bold" style="height: 48px; font-size: 16px; border-radius: 8px;">
                    <i class="fas fa-search me-1"></i> ค้นหา
                </button>
                <button type="button" id="btnResetFilter" class="btn btn-outline-secondary fw-bold" style="height: 48px; width: 48px; border-radius: 8px;" title="ล้างค่าตัวกรอง">
                    <i class="fas fa-redo"></i>
                </button>
            </div>
        </form>
    </div>
</div>
```

---

## 3. มาตรฐาน Form บันทึกข้อมูล (Data Entry / Create & Edit Form Specification)

### 3.1 หลักการออกแบบเพื่อผู้สูงวัย (Senior-Friendly Principles)
1. **แบ่งข้อมูลเป็นกลุ่มก้อน (Logical Chunking):** ไม่เรียงฟิลด์ยาวติดต่อกัน แบ่งเป็น Sections ชัดเจนด้วยการ์ดหรือแถบสีเทาอ่อน เช่น `ข้อมูลทั่วไป`, `ข้อมูลที่อยู่และพิกัด`, `ข้อมูลการรับเงิน`
2. **สัญลักษณ์ฟิลด์บังคับชัดเจน:** ฟิลด์ที่จำเป็นต้องมี `<span class="text-danger fw-bold ms-1">*</span>` และมีคำอธิบายกำกับใต้ฟอร์ม
3. **ช่องกรอกขนาดใหญ่ (48px–52px):** ระยะห่างระหว่างฟิลด์ (Form Spacing) `1.25rem` ไม่แออัด
4. **ปุ่มกดแถบด้านล่าง (Bottom Action Bar):**
   - ปุ่ม **"💾 บันทึกข้อมูล"** (`btn-success` หรือ `btn-primary`, ขนาดใหญ่, กว้างอย่างน้อย 160px)
   - ปุ่ม **"❌ ยกเลิก / กลับ"** (`btn-outline-secondary`, กว้างอย่างน้อย 120px)

### 3.2 ตัวอย่างโค้ด Blade Form บันทึกข้อมูล
```html
<div class="card border shadow-sm" style="border-radius: 12px; background: #ffffff; border-color: #e2e8f0;">
    <div class="card-header bg-white border-bottom p-4">
        <h4 class="fw-bold text-dark mb-0">
            <i class="fas fa-edit text-primary me-2"></i> แบบฟอร์มบันทึกข้อมูลสมาชิก
        </h4>
        <small class="text-muted fs-6">ช่องที่มีเครื่องหมาย (<span class="text-danger">*</span>) จำเป็นต้องกรอกข้อมูล</small>
    </div>
    <div class="card-body p-4">
        <form id="dataEntryForm" method="POST" action="/api/members" novalidate>
            @csrf
            
            <!-- ส่วนที่ 1: ข้อมูลส่วนตัว -->
            <div class="mb-4">
                <h6 class="text-uppercase text-secondary fw-bold border-bottom pb-2 mb-3">
                    <i class="fas fa-user text-primary me-1"></i> ส่วนที่ 1: ข้อมูลส่วนบุคคล
                </h6>
                <div class="row g-3">
                    <div class="col-md-6">
                        <label for="firstname" class="form-label fw-bold text-dark fs-6">
                            ชื่อจริง <span class="text-danger">*</span>
                        </label>
                        <input type="text" name="firstname" id="firstname" class="form-control" placeholder="ระบุชื่อจริง" style="height: 50px; font-size: 16px;">
                        <div class="invalid-feedback fs-6"></div>
                    </div>
                    <div class="col-md-6">
                        <label for="lastname" class="form-label fw-bold text-dark fs-6">
                            นามสกุล <span class="text-danger">*</span>
                        </label>
                        <input type="text" name="lastname" id="lastname" class="form-control" placeholder="ระบุนามสกุล" style="height: 50px; font-size: 16px;">
                        <div class="invalid-feedback fs-6"></div>
                    </div>
                    <div class="col-md-6">
                        <label for="id_card" class="form-label fw-bold text-dark fs-6">
                            เลขประจำตัวประชาชน (13 หลัก) <span class="text-danger">*</span>
                        </label>
                        <input type="text" name="id_card" id="id_card" maxlength="13" class="form-control" placeholder="x-xxxx-xxxxx-xx-x" style="height: 50px; font-size: 16px;">
                        <div class="invalid-feedback fs-6"></div>
                    </div>
                    <div class="col-md-6">
                        <label for="birthdate_display" class="form-label fw-bold text-dark fs-6">
                            วัน/เดือน/ปีเกิด (พ.ศ.) <span class="text-danger">*</span>
                        </label>
                        <div class="input-group">
                            <input type="text" id="birthdate_display" class="form-control datepicker-thai" placeholder="01/09/2568" style="height: 50px; font-size: 16px;" autocomplete="off">
                            <input type="hidden" name="birthdate" id="birthdate">
                            <span class="input-group-text bg-light"><i class="fas fa-calendar-alt text-primary"></i></span>
                        </div>
                        <div class="invalid-feedback fs-6 d-block" id="birthdate-error" style="display: none;"></div>
                    </div>
                </div>
            </div>

            <!-- ส่วนที่ 2: แถบปุ่มดำเนินการ -->
            <div class="d-flex align-items-center justify-content-between pt-4 border-top mt-4">
                <a href="{{ url()->previous() }}" class="btn btn-outline-secondary px-4 py-2" style="min-height: 48px; font-size: 16px; border-radius: 8px;">
                    <i class="fas fa-arrow-left me-1"></i> ย้อนกลับ
                </a>
                <div class="d-flex gap-2">
                    <button type="reset" class="btn btn-light border px-4 py-2" style="min-height: 48px; font-size: 16px; border-radius: 8px;">
                        <i class="fas fa-undo me-1"></i> ล้างข้อมูลในแบบฟอร์ม
                    </button>
                    <button type="submit" id="btnSubmitForm" class="btn btn-success px-5 py-2 fw-bold" style="min-height: 48px; font-size: 17px; border-radius: 8px; background-color: #16a34a; border-color: #16a34a;">
                        <i class="fas fa-save me-1"></i> บันทึกข้อมูล
                    </button>
                </div>
            </div>
        </form>
    </div>
</div>
```

---

## 4. มาตรฐาน Data Table (Server-Side Ajax + Pagination Specification)

### 4.1 ข้อกำหนดด้านเทคนิค (Technical Rules)
1. **Server-Side Rendering เสมอ:** ตารางข้อมูลทุกตัวในระบบต้องตั้งค่า `serverSide: true`, `processing: true` และดึงข้อมูลผ่าน `ajax` URL
2. **ตัวเลือกขนาดหน้า (Page Lengths):** อนุญาตให้เลือก 10, 25, 50, 100 รายการต่อหน้า
3. **ภาษาไทยครบถ้วน (Thai Localization):** ปรับแต่งข้อความของ DataTable ทั้งหมดเป็นภาษาไทยที่เป็นมิตร
4. **ความสูงแถวและระยะห่าง (Row Spacing):** Padding ขั้นต่ำ `0.85rem 1rem` ขนาดตัวอักษร 16px อ่านสบายตา
5. **ปุ่ม Action ประจำแถว (Row Actions):** ใช้ปุ่มขนาดเล็กที่มีไอคอนและสีสื่อความหมาย เช่น ดูข้อมูล (`btn-outline-info`), แก้ไข (`btn-outline-warning`), ลบ (`btn-outline-danger`)

### 4.2 การตั้งค่า JavaScript มาตรฐานสำหรับ DataTable
```javascript
/**
 * OTP 2025 Standard Server-Side DataTable Helper
 */
function initServerSideDataTable(tableSelector, ajaxUrl, columnsConfig, extraFilterParams = {}) {
    return $(tableSelector).DataTable({
        serverSide: true,
        processing: true,
        responsive: true,
        ajax: {
            url: ajaxUrl,
            type: 'GET',
            data: function (d) {
                // ผูกพารามิเตอร์การค้นหาเพิ่มเติมจาก Form ค้นหา
                if (typeof extraFilterParams === 'function') {
                    Object.assign(d, extraFilterParams());
                } else {
                    Object.assign(d, extraFilterParams);
                }
            },
            error: function (xhr) {
                AppNotification.handleAjaxError(xhr);
            }
        },
        columns: columnsConfig,
        order: [[0, 'desc']],
        pageLength: 10,
        lengthMenu: [[10, 25, 50, 100], [10, 25, 50, 100]],
        language: {
            processing: '<div class="d-flex align-items-center justify-content-center p-3"><div class="spinner-border text-primary me-2" role="status"></div><span class="fs-5 fw-bold text-dark">กำลังโหลดข้อมูล...</span></div>',
            lengthMenu: 'แสดง _MENU_ รายการต่อหน้า',
            zeroRecords: '<div class="text-center py-5"><i class="fas fa-search fa-3x text-muted mb-3"></i><p class="fs-5 text-secondary">ไม่พบข้อมูลที่ตรงกับเงื่อนไขการค้นหา</p></div>',
            info: 'แสดงรายการที่ <strong>_START_</strong> ถึง <strong>_END_</strong> จากทั้งหมด <strong>_TOTAL_</strong> รายการ',
            infoEmpty: 'ไม่มีรายการข้อมูลสำหรับแสดงผล',
            infoFiltered: '(กรองจากข้อมูลทั้งหมด _MAX_ รายการ)',
            paginate: {
                first: '<i class="fas fa-angle-double-left"></i> หน้าแรก',
                last: 'หน้าสุดท้าย <i class="fas fa-angle-double-right"></i>',
                next: 'ถัดไป <i class="fas fa-angle-right"></i>',
                previous: '<i class="fas fa-angle-left"></i> ก่อนหน้า'
            }
        },
        drawCallback: function () {
            // ปรับแต่งปุ่ม Pagination ให้เป็นไปตาม Senior White Theme
            $('.paginate_button').addClass('btn btn-sm btn-outline-secondary mx-1');
            $('.paginate_button.current').addClass('btn-primary text-white border-primary').removeClass('btn-outline-secondary');
        }
    });
}
```

---

## 5. มาตรฐาน Thai Buddhist Era DatePicker (พ.ศ. / ค.ศ.)

### 5.1 ข้อกำหนดสำคัญ (The Buddhist Calendar Rule)
1. **สิ่งที่ผู้ใช้งานเห็น (Display Input):** แสดงเป็นปี พ.ศ. เสมอ ในรูปแบบ `dd/mm/yyyy` (เช่น `01/09/2568`)
2. **สิ่งที่เก็บลงฐานข้อมูล (Backend Storage):** จัดเก็บเป็นปี ค.ศ. เสมอ ในรูปแบบ ISO-8601 `YYYY-MM-DD` (เช่น `2025-09-01`)
3. **การแปลงปี:** ปี พ.ศ. = ปี ค.ศ. + 543 (และ ปี ค.ศ. = ปี พ.ศ. - 543)

### 5.2 ตัวอย่างโค้ด DatePicker Helper (`public/js/thai-datepicker-helper.js`)
```javascript
/**
 * OTP 2025 Thai Datepicker & Calendar Transformer
 */
const ThaiDateHelper = {
    // แปลง ค.ศ. (YYYY-MM-DD) เป็น พ.ศ. (DD/MM/YYYY)
    toBuddhistDisplay: function (gregorianDateStr) {
        if (!gregorianDateStr) return '';
        const parts = gregorianDateStr.split('-');
        if (parts.length !== 3) return gregorianDateStr;
        const year = parseInt(parts[0], 10) + 543;
        const month = parts[1];
        const day = parts[2];
        return `${day}/${month}/${year}`;
    },

    // แปลง พ.ศ. (DD/MM/YYYY) เป็น ค.ศ. (YYYY-MM-DD)
    toGregorianDb: function (buddhistDateStr) {
        if (!buddhistDateStr) return '';
        const parts = buddhistDateStr.split('/');
        if (parts.length !== 3) return buddhistDateStr;
        const day = parts[0];
        const month = parts[1];
        const year = parseInt(parts[2], 10) - 543;
        return `${year}-${month}-${day}`;
    },

    // เริ่มต้นใช้งาน Datepicker ให้กับช่อง input ที่มี class .datepicker-thai
    init: function () {
        $('.datepicker-thai').each(function () {
            const $displayInput = $(this);
            const $hiddenInput = $displayInput.siblings('input[type="hidden"]');

            // หากมีค่าเริ่มต้นที่เป็น ค.ศ. จากฐานข้อมูล ให้แปลงเป็น พ.ศ. แสดงผลทันที
            if ($hiddenInput.val()) {
                $displayInput.val(ThaiDateHelper.toBuddhistDisplay($hiddenInput.val()));
            }

            $displayInput.datepicker({
                language: 'th-th',
                format: 'dd/mm/yyyy',
                autoclose: true,
                todayHighlight: true,
                clearBtn: true
            }).on('changeDate', function (e) {
                if (e.date) {
                    const d = ('0' + e.date.getDate()).slice(-2);
                    const m = ('0' + (e.date.getMonth() + 1)).slice(-2);
                    const y = e.date.getFullYear(); // bootstrap-datepicker-thai ให้ปี ค.ศ. ใน e.date
                    $hiddenInput.val(`${y}-${m}-${d}`);
                } else {
                    $hiddenInput.val('');
                }
            }).on('clearDate', function () {
                $hiddenInput.val('');
            });
        });
    }
};

$(document).ready(function () {
    ThaiDateHelper.init();
});
```

---

## 6. มาตรฐาน Client-Side Validation & Single-Error Filtering

### 6.1 กฎเหล็ก (Strict Validation Rules)
1. **ห้ามใช้ HTML5 Validation เด็ดขาด:** ป้องกัน Popup บอลลูนสีเทาของเบราว์เซอร์ โดยต้องใส่ `novalidate` บน `<form novalidate>` ทุกอัน
2. **Single-Error Filter (แสดงเฉพาะ Error แรกสุด):**
   - เมื่อผู้ใช้กรอกผิด 5 ช่อง ระบบจะไม่พ่นข้อความสีแดง 5 จุดพร้อมกัน
   - ระบบจะค้นหาฟิลด์แรกสุดที่ผิด (First Invalid Field) ไฮไลต์ฟิลด์นั้น แสดงข้อความภาษาไทยที่ชัดเจน และทำ **Auto-scroll + Focus** ไปยังช่องนั้นทันที

### 6.2 ตัวอย่างโค้ด Validation ด้วย jQuery Validation
```javascript
/**
 * OTP 2025 Standard Form Validation with Single-Error Filter
 */
function initFormValidation(formSelector, rulesConfig, messagesConfig, submitHandlerFn) {
    const $form = $(formSelector);
    $form.attr('novalidate', 'novalidate'); // บังคับปิด HTML5 Validation

    return $form.validate({
        rules: rulesConfig,
        messages: messagesConfig,
        errorElement: 'div',
        errorClass: 'invalid-feedback fs-6',
        
        // กฎ Single-Error Filter: ประมวลผลและเน้นเฉพาะข้อผิดพลาดแรกสุด
        showErrors: function(errorMap, errorList) {
            // ล้างสถานะ error เดิมทั้งหมดก่อน
            $form.find('.is-invalid').removeClass('is-invalid');
            $form.find('.invalid-feedback').text('').hide();

            if (errorList.length > 0) {
                // เลือกเฉพาะ Error อันแรกสุดเสมอ (First Error Only)
                const firstError = errorList[0];
                const $element = $(firstError.element);
                
                $element.addClass('is-invalid');
                let $feedback = $element.siblings('.invalid-feedback');
                if (!$feedback.length) {
                    $feedback = $element.parent().find('.invalid-feedback');
                }
                $feedback.text(firstError.message).show();

                // เลื่อนหน้าจอไปหาฟิลด์ที่มีปัญหาและโฟกัสให้อัตโนมัติ
                $('html, body').animate({
                    scrollTop: $element.offset().top - 120
                }, 300);
                $element.focus();

                // แจ้งเตือนแบบ Toast ด้านบนขวาให้ผู้ใช้ทราบ
                AppNotification.toast('warning', firstError.message);
            }
        },

        highlight: function (element) {
            $(element).addClass('is-invalid');
        },
        unhighlight: function (element) {
            $(element).removeClass('is-invalid');
            $(element).siblings('.invalid-feedback').text('').hide();
        },
        submitHandler: function (form) {
            submitHandlerFn(form);
        }
    });
}
```

---

## 7. มาตรฐานการแจ้งเตือนแบบเป็นเอกภาพ (Two-Tier Feedback Pattern)

เพื่อให้ระบบมีความสม่ำเสมอ ไม่สับสน กำหนดใช้ **SweetAlert2** เป็นศูนย์กลางการแจ้งเตือนทั้งหมด แบ่งออกเป็น 2 รูปแบบเท่านั้น:

### 7.1 Tier 1: SweetAlert2 Modal Dialog (สำหรับผลลัพธ์สำคัญ / ยืนยันธุรกรรม)
ใช้เมื่อ:
- บันทึกข้อมูลสำเร็จ (Create / Update Success)
- ยืนยันการลบข้อมูล (Delete Confirmation)
- ข้อผิดพลาดร้ายแรงจากระบบ (System Error เช่น `[ERR-SYS-002]`)

```javascript
const AppNotification = {
    // 1. Popup ยืนยันการทำรายการ (Confirmation Modal)
    confirm: function(title, text, confirmButtonText = 'ยืนยันดำเนินการ', callback) {
        Swal.fire({
            title: title,
            text: text,
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#16a34a', // เขียว
            cancelButtonColor: '#64748b',  // เทา
            confirmButtonText: `<i class="fas fa-check me-1"></i> ${confirmButtonText}`,
            cancelButtonText: '<i class="fas fa-times me-1"></i> ยกเลิก',
            reverseButtons: true,
            focusCancel: true
        }).then((result) => {
            if (result.isConfirmed && typeof callback === 'function') {
                callback();
            }
        });
    },

    // 2. Popup แจ้งผลสำเร็จ (Success Modal)
    success: function(title, text = '', callback) {
        Swal.fire({
            title: `<span class="text-success fw-bold">${title}</span>`,
            text: text,
            icon: 'success',
            confirmButtonColor: '#16a34a',
            confirmButtonText: 'ตกลง'
        }).then(() => {
            if (typeof callback === 'function') callback();
        });
    },

    // 3. Popup แจ้งข้อผิดพลาดที่เป็นมิตร (Friendly Error Modal พร้อม Error Code)
    error: function(errorCode, friendlyMessage, technicalDetail = null) {
        Swal.fire({
            title: '<span class="text-danger fw-bold">เกิดข้อผิดพลาดในการทำรายการ</span>',
            html: `
                <div class="p-2 text-start">
                    <p class="fs-5 text-dark mb-2">${friendlyMessage}</p>
                    <div class="alert alert-light border text-muted small p-2 mb-0">
                        <i class="fas fa-info-circle me-1"></i> รหัสอ้างอิง: <strong>[${errorCode}]</strong>
                    </div>
                </div>
            `,
            icon: 'error',
            confirmButtonColor: '#dc2626',
            confirmButtonText: 'ปิดหน้าต่าง'
        });
    },

    // 4. Toast แจ้งเตือนมุมขวาบน (Non-blocking Notifications)
    toast: function(type, message) {
        const Toast = Swal.mixin({
            toast: true,
            position: 'top-end',
            showConfirmButton: false,
            timer: 3500,
            timerProgressBar: true,
            didOpen: (toast) => {
                toast.addEventListener('mouseenter', Swal.stopTimer);
                toast.addEventListener('mouseleave', Swal.resumeTimer);
            }
        });
        Toast.fire({
            icon: type, // 'success', 'warning', 'info', 'error'
            title: `<span class="fw-bold fs-6">${message}</span>`
        });
    },

    // 5. ตัวจัดการดักจับ Error จาก API/Ajax อัตโนมัติ (Single-Error Extractor)
    handleAjaxError: function(xhr) {
        let errorCode = 'ERR-SYS-001';
        let friendlyMsg = 'ระบบไม่สามารถเชื่อมต่อได้ในขณะนี้ กรุณาลองใหม่อีกครั้ง';

        if (xhr.status === 422) {
            errorCode = 'ERR-VAL-001';
            const errors = xhr.responseJSON?.errors;
            if (errors) {
                // กรองเอาเฉพาะ Error ตัวแรกสุดเสมอ
                const firstKey = Object.keys(errors)[0];
                friendlyMsg = errors[firstKey][0];
            } else {
                friendlyMsg = xhr.responseJSON?.message || 'ข้อมูลที่กรอกไม่ถูกต้องครบถ้วน';
            }
        } else if (xhr.status === 403) {
            errorCode = 'ERR-AUTH-003';
            friendlyMsg = 'ท่านไม่มีสิทธิ์ในการดำเนินการหรือเข้าถึงข้อมูลนี้';
        } else if (xhr.status === 404) {
            errorCode = 'ERR-DATA-002';
            friendlyMsg = 'ไม่พบข้อมูลที่ท่านต้องการในระบบ';
        } else if (xhr.status === 500) {
            errorCode = 'ERR-SYS-002';
            friendlyMsg = 'ระบบเกิดข้อผิดพลาดในการประมวลผล ข้อมูลเหตุการณ์ถูกบันทึกเรียบร้อยแล้ว';
        }

        AppNotification.error(errorCode, friendlyMsg);
    }
};
```
