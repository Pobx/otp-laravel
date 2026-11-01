@props([
    'name',
    'id' => null,
    'label' => null,
    'options' => [],
    'selected' => null,
    'required' => false,
    'hint' => null,
    'placeholder' => '-- กรุณาเลือก --',
])

@php
    $selectId = $id ?? $name;
    $currentVal = old($name, $selected);
@endphp

<div class="mb-3 senior-form-group">
    @if ($label)
        <label for="{{ $selectId }}" class="form-label fw-semibold text-dark mb-2" style="font-size: 16px;">
            {{ $label }}
            @if ($required)
                <span class="text-danger fw-bold ms-1" title="จำเป็นต้องระบุ">*</span>
            @endif
        </label>
    @endif

    <select 
        name="{{ $name }}"
        id="{{ $selectId }}"
        {{ $required ? 'required' : '' }}
        {{ $attributes->merge(['class' => 'form-select border-2 ' . ($errors->has($name) ? 'is-invalid' : '')]) }}
        style="min-height: 50px; font-size: 16px; border-radius: 10px; border-color: #CBD5E1; padding: 10px 16px;"
    >
        @if ($placeholder)
            <option value="">{{ $placeholder }}</option>
        @endif

        @if (!empty($options))
            @foreach ($options as $key => $text)
                <option value="{{ $key }}" {{ (string)$currentVal === (string)$key ? 'selected' : '' }}>
                    {{ $text }}
                </option>
            @endforeach
        @else
            {{ $slot }}
        @endif
    </select>

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
