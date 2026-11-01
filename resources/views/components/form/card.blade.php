@props([
    'title' => null,
    'subtitle' => null,
    'icon' => null,
    'headerClass' => '',
])

<div {{ $attributes->merge(['class' => 'senior-card bg-white border rounded-4 p-4 mb-4 shadow-sm']) }} style="border-color: #E2E8F0 !important;">
    @if ($title)
        <div class="senior-card-header d-flex align-items-center justify-content-between pb-3 mb-3 border-bottom {{ $headerClass }}" style="border-color: #E2E8F0 !important;">
            <div class="d-flex align-items-center gap-2">
                @if ($icon)
                    <div class="d-flex align-items-center justify-content-center rounded-3 bg-light text-primary" style="width: 40px; height: 40px; font-size: 20px;">
                        <i class="{{ $icon }}"></i>
                    </div>
                @endif
                <div>
                    <h3 class="h5 fw-bold mb-0 text-dark" style="font-family: 'Prompt', sans-serif;">{{ $title }}</h3>
                    @if ($subtitle)
                        <p class="text-muted small mb-0 mt-1">{{ $subtitle }}</p>
                    @endif
                </div>
            </div>
            @isset($actions)
                <div class="card-header-actions">
                    {{ $actions }}
                </div>
            @endisset
        </div>
    @endif

    <div class="senior-card-body">
        {{ $slot }}
    </div>
</div>
