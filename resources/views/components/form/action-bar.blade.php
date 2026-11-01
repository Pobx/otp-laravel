@props([
    'cancelText' => 'ยกเลิก / ย้อนกลับ',
    'cancelUrl' => null,
    'cancelAction' => null,
    'submitText' => 'บันทึกข้อมูล',
    'submitIcon' => 'bi bi-check2-circle',
    'cancelIcon' => 'bi bi-arrow-left',
    'loadingText' => 'กำลังบันทึกข้อมูล...',
])

<div class="senior-action-bar d-flex flex-wrap align-items-center justify-content-between gap-3 pt-4 mt-4 border-top" style="border-color: #E2E8F0 !important;">
    <div>
        @if ($cancelUrl)
            <a href="{{ $cancelUrl }}" class="btn btn-outline-secondary d-inline-flex align-items-center gap-2 fw-semibold"
               style="min-height: 52px; padding: 12px 24px; font-size: 16px; border-radius: 10px; border-color: #CBD5E1; color: #475569;">
                <i class="{{ $cancelIcon }}"></i>
                <span>{{ $cancelText }}</span>
            </a>
        @else
            <button type="button" 
                    @if ($cancelAction) onclick="{{ $cancelAction }}" @else onclick="window.history.back()" @endif
                    class="btn btn-outline-secondary d-inline-flex align-items-center gap-2 fw-semibold"
                    style="min-height: 52px; padding: 12px 24px; font-size: 16px; border-radius: 10px; border-color: #CBD5E1; color: #475569;">
                <i class="{{ $cancelIcon }}"></i>
                <span>{{ $cancelText }}</span>
            </button>
        @endif
    </div>

    <div class="d-flex align-items-center gap-3">
        @isset($extraButtons)
            {{ $extraButtons }}
        @endisset

        <button type="submit" 
                class="btn btn-primary d-inline-flex align-items-center gap-2 fw-bold text-white shadow-sm"
                style="min-height: 52px; padding: 12px 32px; font-size: 17px; border-radius: 10px; background-color: #0284C7; border-color: #0284C7;">
            <i class="{{ $submitIcon }} fs-5"></i>
            <span>{{ $submitText }}</span>
        </button>
    </div>
</div>
