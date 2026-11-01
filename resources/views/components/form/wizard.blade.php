@props([
    'steps' => [],
    'current' => 1,
])

<div class="senior-wizard mb-4">
    <div class="d-flex align-items-center justify-content-between position-relative px-2">
        <div class="wizard-progress-track position-absolute top-50 start-0 end-0 translate-middle-y" style="height: 3px; background-color: #E2E8F0; z-index: 1;"></div>
        
        @foreach ($steps as $index => $step)
            @php
                $stepNumber = $index + 1;
                $isCompleted = $stepNumber < $current;
                $isActive = $stepNumber === (int)$current;
                
                $bgColor = $isActive ? '#0284C7' : ($isCompleted ? '#16A34A' : '#FFFFFF');
                $borderColor = $isActive ? '#0284C7' : ($isCompleted ? '#16A34A' : '#CBD5E1');
                $textColor = ($isActive || $isCompleted) ? '#FFFFFF' : '#64748B';
                $boxShadow = $isActive ? '0 0 0 5px #E0F2FE' : 'none';
            @endphp
            
            <div class="wizard-step-node position-relative text-center" style="z-index: 2; background-color: #FFFFFF; padding: 0 10px;">
                <div class="wizard-step-circle d-flex align-items-center justify-content-center mx-auto rounded-circle fw-bold"
                     style="width: 48px; height: 48px; background-color: {{ $bgColor }}; border: 3px solid {{ $borderColor }}; color: {{ $textColor }}; box-shadow: {{ $boxShadow }}; font-size: 18px; transition: all 0.25s ease;">
                    @if ($isCompleted)
                        <i class="bi bi-check-lg"></i>
                    @else
                        {{ $stepNumber }}
                    @endif
                </div>
                <div class="wizard-step-label mt-2 small fw-semibold {{ $isActive ? 'text-primary fw-bold' : ($isCompleted ? 'text-success' : 'text-muted') }}" style="font-size: 15px;">
                    {{ is_array($step) ? ($step['label'] ?? '') : $step }}
                </div>
            </div>
        @endforeach
    </div>
</div>
