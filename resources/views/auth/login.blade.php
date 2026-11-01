<x-guest-layout>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" />
    <link rel="stylesheet" href="{{ asset('css/senior-white-theme.css') }}" />

    <style>
        body {
            background-color: #F8FAFC !important;
            font-family: 'Sarabun', sans-serif !important;
        }
        .login-card-container {
            max-width: 520px;
            margin: 40px auto;
            background: #FFFFFF;
            border: 2px solid #E2E8F0;
            border-radius: 16px;
            box-shadow: 0 10px 25px rgba(15, 23, 42, 0.06);
            padding: 40px 36px;
        }
        .login-logo-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 90px;
            height: 90px;
            border-radius: 50%;
            background: #F1F5F9;
            border: 2px solid #E2E8F0;
            margin-bottom: 16px;
        }
        .login-logo-badge img {
            width: 64px;
            height: 64px;
            object-fit: contain;
        }
        .login-title {
            font-size: 26px !important;
            font-weight: 700 !important;
            color: #0F172A !important;
            margin-bottom: 6px;
            text-align: center;
        }
        .login-subtitle {
            font-size: 16px !important;
            color: #475569 !important;
            text-align: center;
            margin-bottom: 28px;
        }
        .input-group-custom {
            margin-bottom: 22px;
        }
        .input-group-custom label {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 17px !important;
            font-weight: 600 !important;
            color: #0F172A !important;
            margin-bottom: 8px;
        }
        .input-group-custom input {
            width: 100%;
            height: 52px !important;
            font-size: 18px !important;
            padding: 10px 16px !important;
            border: 2px solid #CBD5E1 !important;
            border-radius: 10px !important;
            background-color: #FFFFFF !important;
            color: #0F172A !important;
            box-sizing: border-box;
        }
        .input-group-custom input:focus {
            border-color: #0284C7 !important;
            box-shadow: 0 0 0 4px rgba(2, 132, 199, 0.2) !important;
            outline: none;
        }
        .login-submit-btn {
            width: 100%;
            height: 52px !important;
            font-size: 18px !important;
            font-weight: 700 !important;
            color: #FFFFFF !important;
            background-color: #0284C7 !important;
            border: none !important;
            border-radius: 10px !important;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            transition: background-color 0.2s ease;
            margin-top: 24px;
        }
        .login-submit-btn:hover {
            background-color: #0369A1 !important;
        }
        .login-help-box {
            margin-top: 30px;
            padding: 16px 20px;
            background-color: #F8FAFC;
            border: 1.5px dashed #CBD5E1;
            border-radius: 10px;
            font-size: 15px;
            color: #475569;
        }
    </style>

    <div class="login-card-container">
        <!-- Logo and App Title -->
        <div class="text-center">
            <div class="login-logo-badge">
                <img src="{{ asset('logo/ko_envsogo.png') }}" alt="Municipality Logo">
            </div>
            <h1 class="login-title">ระบบบริหารจัดการเทศบาลอัจฉริยะ</h1>
            <p class="login-subtitle">เข้าสู่ระบบเพื่อปฏิบัติงาน (Smart Municipality Portal)</p>
        </div>

        <!-- Session Status -->
        <x-auth-session-status class="mb-4" :status="session('status')" />

        <!-- Validation Errors -->
        <x-auth-validation-errors class="mb-4" :errors="$errors" />

        <form method="POST" action="{{ route('login') }}">
            @csrf

            <!-- Username Input -->
            <div class="input-group-custom">
                <label for="username">
                    <i class="fas fa-user text-primary"></i>
                    <span>ชื่อผู้ใช้งาน (Username)</span>
                </label>
                <input id="username" type="text" name="username"
                    value="{{ old('username', 'admin') }}"
                    required autofocus placeholder="กรอกชื่อผู้ใช้งาน..." />
            </div>

            <!-- Password Input -->
            <div class="input-group-custom">
                <label for="password">
                    <i class="fas fa-lock text-primary"></i>
                    <span>รหัสผ่าน (Password)</span>
                </label>
                <input id="password" type="password" name="password"
                    value="password"
                    required autocomplete="current-password" placeholder="กรอกรหัสผ่าน..." />
            </div>

            <!-- Remember Me & Forgot Password -->
            <div class="d-flex justify-content-between align-items-center mb-3">
                <label for="remember_me" class="d-flex align-items-center gap-2 m-0" style="cursor: pointer;">
                    <input id="remember_me" type="checkbox" name="remember" style="width: 20px; height: 20px;">
                    <span class="text-sm font-weight-normal text-muted">จดจำการเข้าสู่ระบบ</span>
                </label>
            </div>

            <!-- Submit Button -->
            <button type="submit" class="login-submit-btn">
                <i class="fas fa-sign-in-alt"></i>
                <span>เข้าสู่ระบบ (Sign In)</span>
            </button>
        </form>

        <!-- Help hints for users -->
        <div class="login-help-box">
            <div class="font-weight-bold text-dark mb-1">
                <i class="fas fa-info-circle text-info me-1"></i> บัญชีทดสอบสำหรับเจ้าหน้าที่:
            </div>
            <div>• <strong>admin</strong> = ผู้ดูแลระบบสูงสุด (Super Admin)</div>
            <div>• <strong>water_staff</strong> = เจ้าหน้าที่ระบบประปาและจดมิเตอร์</div>
            <div>• <strong>recycle_staff</strong> = เจ้าหน้าที่ธนาคารขยะรีไซเคิล</div>
            <div>• <strong>food_staff</strong> = เจ้าหน้าที่ระบบขยะอินทรีย์</div>
            <div class="text-muted mt-1 small">รหัสผ่านเริ่มต้นสำหรับทุกบัญชี: <code>password</code></div>
        </div>
    </div>
</x-guest-layout>
