@props([
    'id' => 'seniorFormErrorBanner',
    'title' => 'โปรดตรวจสอบข้อมูลในแบบฟอร์ม',
])

<div id="{{ $id }}" class="senior-error-banner alert alert-danger border-2 p-3 mb-4 rounded-3 shadow-sm align-items-start gap-3" 
     style="display: {{ $errors->any() ? 'flex' : 'none' }}; background-color: #FEF2F2; border-color: #FCA5A5; color: #991B1B;"
     role="alert">
    <div class="fs-4 text-danger flex-shrink-0 mt-1">
        <i class="bi bi-exclamation-triangle-fill"></i>
    </div>
    
    <div class="flex-grow-1">
        <div class="fw-bold fs-6 mb-1 banner-title">
            {{ $title }}
        </div>
        <div class="banner-message" style="font-size: 15px;">
            @if ($errors->any())
                {{-- ADR 0005: Display First Error Only --}}
                {{ $errors->all()[0] }}
            @else
                กรุณาระบุข้อมูลในช่องที่ทำเครื่องหมายดอกจัน (*) สีแดงให้ครบถ้วนถูกต้อง
            @endif
        </div>
    </div>

    <button type="button" class="btn-close flex-shrink-0" onclick="this.closest('.senior-error-banner').style.display='none'" aria-label="Close"></button>
</div>
