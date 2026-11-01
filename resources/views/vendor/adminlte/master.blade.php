@php
    $layoutFixed = config('adminlte.layout_fixed_sidebar', true);
    $fixedHeader = config('adminlte.layout_fixed_navbar', true);
    $fixedFooter = config('adminlte.layout_fixed_footer');
    $rtl = config('adminlte.layout_rtl', false);
    $sidebarBreakpoint = config('adminlte.sidebar_breakpoint', 'lg');
    $sidebarMini = config('adminlte.sidebar_mini', true);
    $sidebarCollapse = config('adminlte.sidebar_collapse', false);

    $bodyClasses = collect([
        $layoutFixed ? 'layout-fixed' : null,
        $fixedHeader ? 'fixed-header' : null,
        $fixedFooter ? 'fixed-footer' : null,
        'sidebar-expand-'.$sidebarBreakpoint,
        $sidebarMini ? 'sidebar-mini' : null,
        $sidebarCollapse ? 'sidebar-collapse' : null,
        'bg-body-tertiary',
        config('adminlte.classes_body'),
    ])->filter()->implode(' ');

    $titlePrefix = config('adminlte.title_prefix', '');
    $titlePostfix = config('adminlte.title_postfix', '');
    $pageTitle = trim($titlePrefix.' '.($title ?? config('adminlte.title', 'Envsogo เทศบาลอัจฉริยะ')).' '.$titlePostfix);
@endphp
<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}"
      dir="{{ $rtl ? 'rtl' : 'ltr' }}"
      data-bs-theme="light">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="csrf-token" content="{{ csrf_token() }}">

    <title>{{ $pageTitle }}</title>

    <link rel="icon" type="image/png" href="{{ asset('logo/ko_envsogo.png') }}">

    <!-- Google Fonts: Sarabun & Prompt -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Prompt:wght@400;500;600;700&family=Sarabun:ital,wght@0,300;0,400;0,500;0,600;0,700;1,400&display=swap" rel="stylesheet">

    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="{{ asset('adminlte/plugins/fontawesome-free/css/all.min.css') }}">
    <link rel="stylesheet" href="{{ asset('adminlte/plugins/sweetalert2/sweetalert2.min.css') }}">

    <!-- jQuery for legacy views compatibility -->
    <script src="{{ asset('soft-ui/assets/js/jquery-3.7.0.js') }}"></script>

    @hasSection('adminlte_css')
        @yield('adminlte_css')
    @endif

    {{-- Compiled AdminLTE 4 + Bootstrap 5 from Vite pipeline --}}
    @vite(['resources/css/adminlte.css', 'resources/js/adminlte.js'])

    <!-- Senior White Theme Global Tokens -->
    <link rel="stylesheet" href="{{ asset('css/senior-white-theme.css') }}">

    @if ($rtl)
        <link rel="stylesheet" href="{{ asset('vendor/adminlte/css/adminlte.rtl.min.css') }}">
    @endif

    @include('adminlte::partials.theme-colors')

    <!-- Style sections from child blade views -->
    @stack('css')
    @stack('style')
    @stack('styles')
    @yield('css')
    @yield('style')
    @yield('styles')
    @pluginStyles
</head>
<body class="{{ $bodyClasses }}" style="background-color: #F8FAFC !important;">
    @include('adminlte::partials.preloader')

    @include('adminlte::partials.impersonation-banner')

    <div class="app-wrapper">
        @include('adminlte::partials.navbar')
        @include('adminlte::partials.sidebar')

        <main class="app-main" style="background-color: #F8FAFC;">
            @hasSection('content_header')
                <div class="app-content-header {{ config('adminlte.classes_content_header', 'py-3') }}">
                    <div class="container-fluid px-4">
                        @yield('content_header')
                    </div>
                </div>
            @endif

            @hasSection('page-topic')
                <div class="container-fluid px-4 pt-3">
                    <div class="card border mb-3 shadow-sm" style="border-radius: 12px;">
                        <div class="card-body p-3">
                            <h4 class="mb-0 fw-bold text-dark">
                                @yield('page-topic')
                            </h4>
                        </div>
                    </div>
                </div>
            @endif

            <div class="app-content {{ config('adminlte.classes_content', 'py-3') }}">
                <div class="container-fluid px-4">
                    @yield('content')
                </div>
            </div>
        </main>

        @include('adminlte::partials.footer')
        @include('adminlte::partials.control-sidebar')
    </div>

    @pluginScripts
    <!-- UI Standards Libraries: SweetAlert2, jQuery Validate, Thai DatePicker, Standards Helper -->
    <script src="{{ asset('adminlte/plugins/sweetalert2/sweetalert2.all.min.js') }}"></script>
    <script src="{{ asset('adminlte/plugins/jquery-validation/jquery.validate.min.js') }}"></script>
    <script src="{{ asset('js/bootstrap-datepicker/js/bootstrap-datepicker.js') }}"></script>
    <script src="{{ asset('js/bootstrap-datepicker/js/bootstrap-datepicker-thai.js') }}"></script>
    <script src="{{ asset('js/otp-ui-standards.js') }}"></script>

    <!-- Script sections from child blade views -->
    @stack('js')
    @stack('script')
    @stack('scripts')
    @yield('js')
    @yield('script')
    @yield('scripts')
</body>
</html>
