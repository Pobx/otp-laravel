@props([
    'name',
    'id' => null,
    'label' => null,
    'type' => 'text',
    'value' => null,
    'placeholder' => '',
    'required' => false,
    'hint' => null,
    'icon' => null,
])

@php
    $inputId = $id ?? $name;
    $val = old($name, $value);
@endphp

<div class="mb-3 senior-form-group">
    @if ($label)
        <label for="{{ $inputId }}" class="form-label fw-semibold text-dark mb-2" style="font-size: 16px;">
            {{ $label }}
            @if ($required)
                <span class="text-danger fw-bold ms-1" title="จำเป็นต้องระบุ">*</span>
            @endif
        </label>
    @endif

    <div class="position-relative">
        <input 
            type="{{ $type }}"
            name="{{ $name }}"
            id="{{ $inputId }}"
            value="{{ $val }}"
            placeholder="{{ $placeholder }}"
            {{ $required ? 'required' : '' }}
            {{ $attributes->merge(['class' => 'form-control border-2 ' . ($errors->has($name) ? 'is-invalid' : '')]) }}
            style="min-height: 50px; font-size: 16px; border-radius: 10px; border-color: #CBD5E1; padding: 10px 16px;"
        >
        @if ($icon)
            <span class="position-absolute end-0 top-50 translate-middle-y me-3 text-muted">
                <i class="{{ $icon }}"></i>
            </span>
        @endif
    </div>

    @if ($hint)
        <div class="form-text text-muted mt-1" style="font-size: 14px;">
            <i class="bi bi-info-circle me-1"></i>{{ $hint }}
        </div>
    @endif

    @error($name)
        <div class="invalid-feedback d-block mt-1" style="font-size: 14px;">
            {{ $message }}
        </div>
    @enderror
</div>
