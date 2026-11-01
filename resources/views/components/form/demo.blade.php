@extends('layouts.super-admin')
@section('title_page', 'แบบฟอร์มมาตรฐาน Senior-Friendly (Template Showcase)')

@section('content')
<div class="container-fluid py-3">

    {{-- 1. Error Banner (Single Error Focus) --}}
    <x-form.error-banner id="demoFormErrorBanner" title="โปรดตรวจสอบและแก้ไขข้อมูลในแบบฟอร์ม" />

    {{-- 2. Wizard Stepper Indicator --}}
    <x-form.card title="ตัวอย่างแบบฟอร์มมาตรฐาน (Senior-Friendly Form Showcase)" subtitle="ออกแบบตามมาตรฐาน ADR 0003, ADR 0004, ADR 0005, และ ADR 0006" icon="bi bi-ui-checks">
        <x-form.wizard :steps="['ข้อมูลผู้ขอรับบริการ', 'ข้อมูลสถานที่และมาตรวัด', 'ยืนยันและแนบเอกสาร']" :current="2" />

        <form id="seniorDemoForm" action="#" method="POST" novalidate>
            @csrf

            <div class="row g-4">
                {{-- Part 1: Citizen Data --}}
                <div class="col-12">
                    <h5 class="fw-bold text-primary mb-3 pb-2 border-bottom">
                        <i class="bi bi-person-vcard me-2"></i> ส่วนที่ 1: ข้อมูลผู้ขอรับบริการ
                    </h5>
                </div>

                <div class="col-md-4">
                    <x-form.input name="citizen_id" label="เลขประจำตัวประชาชน" placeholder="1-xxxx-xxxxx-xx-x" :required="true" hint="เลข 13 หลักของผู้ขอรับบริการ" icon="bi bi-credit-card" />
                </div>

                <div class="col-md-4">
                    <x-form.input name="fullname" label="ชื่อ - นามสกุล" placeholder="เช่น นายสมคิด สบายใจ" :required="true" icon="bi bi-person" />
                </div>

                <div class="col-md-4">
                    <x-form.input name="phone" label="เบอร์โทรศัพท์ติดต่อ" type="tel" placeholder="08xxxxxxxx" :required="true" hint="สำหรับรับ SMS แจ้งเตือนบิล" icon="bi bi-telephone" />
                </div>

                {{-- Part 2: Meter & Date Selection --}}
                <div class="col-12 mt-4">
                    <h5 class="fw-bold text-primary mb-3 pb-2 border-bottom">
                        <i class="bi bi-geo-alt me-2"></i> ส่วนที่ 2: สถานที่ติดตั้งและวันนัดหมาย
                    </h5>
                </div>

                <div class="col-md-4">
                    <x-form.input name="house_no" label="บ้านเลขที่ / อาคาร" placeholder="เช่น 99/4 หมู่บ้านสุขใจ" :required="true" />
                </div>

                <div class="col-md-4">
                    <x-form.select name="meter_category" label="ประเภทผู้ใช้น้ำ" :required="true" :options="[
                        '1' => 'ประเภท 1: ที่พักอาศัยทั่วไป',
                        '2' => 'ประเภท 2: พาณิชยกรรม / ร้านค้า',
                        '3' => 'ประเภท 3: หน่วยงานราชการ / วัด',
                    ]" selected="1" />
                </div>

                <div class="col-md-4">
                    {{-- Thai Buddhist Era Datepicker with Dual Binding --}}
                    <x-form.thai-date name="appointment_date" label="วันนัดหมายติดตั้งมาตรวัด" value="2026-11-15" :required="true" hint="แสดงปี พ.ศ. และจัดเก็บเป็น ค.ศ. อัตโนมัติ" />
                </div>
            </div>

            {{-- 3. Action Bar --}}
            <x-form.action-bar cancelText="ยกเลิก" submitText="บันทึกข้อมูลคำร้อง" submitIcon="bi bi-save2" />
        </form>
    </x-form.card>

</div>
@endsection
