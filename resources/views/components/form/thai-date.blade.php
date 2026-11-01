@props([
    'name',
    'id' => null,
    'label' => null,
    'value' => null, // Expects YYYY-MM-DD or DD/MM/YYYY
    'required' => false,
    'hint' => null,
    'placeholder' => 'วัน/เดือน/ปี (พ.ศ.)',
])

@php
    $inputId = $id ?? $name;
    $rawVal = old($name, $value);

    // Compute display Thai date and hidden ISO date
    $displayThai = '';
    $isoDate = '';

    if (!empty($rawVal)) {
        if (preg_match('/^\d{4}-\d{2}-\d{2}$/', $rawVal)) {
            // ISO YYYY-MM-DD -> convert to Thai DD/MM/YYYY+543
            $parts = explode('-', $rawVal);
            $year = (int)$parts[0] + 543;
            $displayThai = "{$parts[2]}/{$parts[1]}/{$year}";
            $isoDate = $rawVal;
        } elseif (preg_match('/^\d{2}\/\d{2}\/\d{4}$/', $rawVal)) {
            $displayThai = $rawVal;
            $parts = explode('/', $rawVal);
            $year = (int)$parts[2] - 543;
            $isoDate = sprintf('%04d-%02d-%02d', $year, $parts[1], $parts[0]);
        }
    }
@endphp

<div class="mb-3 senior-form-group">
    @if ($label)
        <label for="{{ $inputId }}_thai" class="form-label fw-semibold text-dark mb-2" style="font-size: 16px;">
            {{ $label }}
            @if ($required)
                <span class="text-danger fw-bold ms-1" title="จำเป็นต้องระบุ">*</span>
            @endif
        </label>
    @endif

    <div class="position-relative thai-date-container">
        <input 
            type="text"
            id="{{ $inputId }}_thai"
            value="{{ $displayThai }}"
            placeholder="{{ $placeholder }}"
            data-thai-datepicker
            data-target-hidden="#{{ $inputId }}"
            {{ $required ? 'required' : '' }}
            {{ $attributes->merge(['class' => 'form-control border-2 pe-5 ' . ($errors->has($name) ? 'is-invalid' : '')]) }}
            style="min-height: 50px; font-size: 16px; border-radius: 10px; border-color: #CBD5E1; padding: 10px 16px;"
            autocomplete="off"
        >
        
        <span class="position-absolute end-0 top-50 translate-middle-y me-3 badge bg-secondary text-white fw-bold px-2 py-1" style="font-size: 12px; pointer-events: none;">
            พ.ศ.
        </span>

        <!-- Hidden input storing ISO-8601 YYYY-MM-DD for backend and database -->
        <input 
            type="hidden" 
            name="{{ $name }}" 
            id="{{ $inputId }}" 
            value="{{ $isoDate }}"
        >
    </div>

    @if ($hint)
        <div class="form-text text-muted mt-1" style="font-size: 14px;">
            <i class="bi bi-calendar-event me-1"></i>{{ $hint }}
        </div>
    @endif

    @error($name)
        <div class="invalid-feedback d-block mt-1" style="font-size: 14px;">
            {{ $message }}
        </div>
    @enderror
</div>
