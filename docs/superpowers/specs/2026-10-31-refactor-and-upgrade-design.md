# Refactoring & Laravel Upgrade — Design (Draft for approval)

**Date:** 2026-10-31  **Status:** Draft — awaiting approval (nothing has been built)
**Plan:** [`../plans/2026-10-31-refactor-and-upgrade.md`](../plans/2026-10-31-refactor-and-upgrade.md)

## 1. Intent
ระบบ "otp2025" เป็น Laravel multi-module (Tabwater ประปา, KeptKaya ธนาคารขยะ, FoodWaste, Inventory, Kiosk, Admin, LINE API). ต้องการ (1) ทำให้ codebase ดูแลง่ายขึ้น และ (2) ยกระดับ version ให้ทันสมัย (Laravel 13) โดยไม่ทำให้ production (deploy ผ่าน GitHub Actions → Hostinger, branch `prod`) พัง และรัน local dev บน Docker Compose ทั้งหมด

## 2. Current State (findings จากการ explore เชิงลึก)

| หัวข้อ | สถานะ |
|---|---|
| Framework | `laravel/framework` v11.47.0 (composer.lock), `php: ^8.2` |
| **Skeleton** | ยังเป็นโครงสร้าง **Laravel 10**: `bootstrap/app.php` แบบเก่า, `app/Http/Kernel.php`, `app/Console/Kernel.php`, `Exceptions/Handler.php`, 5 providers (`RouteServiceProvider`, `EventServiceProvider`, `BroadcastServiceProvider`, `AuthServiceProvider`, `AppServiceProvider`), `$routeMiddleware` |
| Key packages (ใช้อยู่จริง) | reverb 1.7, sanctum 4, spatie/permission 6, maatwebsite/excel 3.1.67, phpspreadsheet ^1.29, dompdf 3.1, intervention/image 3, simple-qrcode 4.2 (ใช้จุดเดียวใน `LineLiffController`), tesseract_ocr 2.13, larastan 3 (level 5), phpunit 10.5 |
| **Unused / Redundant packages** | `livewire/livewire` (ไม่มี Component เลย มีแค่ `liverwire.blade.php` ที่สะกดผิดและไม่ได้ใช้), `icehouse-ventures/laravel-chartjs` (ไม่ได้ใช้ใน PHP หน้าบ้านดึง JS ตรง), `doctrine/dbal` (Laravel 11+ รวมใน core แล้ว), `laravel/ui` (ซ้ำซ้อนกับ breeze), `laravel/sail` (จะแทนที่ด้วย custom Docker Compose), `spatie/laravel-ignition` (L11+ ใช้ built-in error page) |
| Frontend | Laravel Mix 6 + Tailwind 3 + Alpine, axios 0.25, Node 20 in CI |
| CI/CD | มีเฉพาะ `deploy-prod.yml` (PHP 8.2); **ไม่มี CI สำหรับ test/phpstan**; `rsync` ยังไม่ได้ exclude ไฟล์ Docker/docs; การรัน migration บน prod ต้องระบุ `--path=...` ทีละไฟล์เพราะ migration เก่าขัดแย้งกับ schema จริง |
| Code size | ~29.5k LOC ใน Controllers; 34+ top-level models รวม ~122 ไฟล์ model; 160 migrations; 11 route files (`web.php` 522 บรรทัด) |
| Tests | มีแค่ `ExampleTest` + Auth (Breeze) → **แทบไม่มี safety net** |
| Local env | `php` บนเครื่องชี้ไป 7.4 (พัง, dyld error); ไม่มี docker/compose file ใน repo → **ตัดสินใจ: dev local รันบน Docker Compose** (php-fpm 8.3, nginx, mysql, redis, node, reverb, queue, mailpit; image ต้องมี tesseract+tha และฟอนต์ไทยสำหรับ dompdf) |

### Code smells & Architectural Risks ที่พบ
1. **Half-migrated Multi-Tenancy (ความเสี่ยงสูงสุด)**:
   - ใน `app/Http/Kernel.php` ตัว `SetTenantConnection` ถูก comment ปิดไว้
   - ระบบกำลังเปลี่ยนผ่านจาก Multi-DB (`envsogo_main`, `envsogo_hs1`, `envsogo_kp1` ผ่าน `session('db_conn')`) มาเป็น Single-DB ที่แยกองค์กรด้วย `org_id_fk` ผ่าน trait `BelongsToOrganization` (มีใช้อยู่ 43 จาก 122 models)
   - **แต่ยังย้ายไม่เสร็จ:** โค้ดใน Controller หลายจุด (`KpTbankUnitsController`, `KpTbankItemsController`, `KpSellController`, `KpPurchaseController`, `BudgetYearController`, `InvoicePeriodController`, `SettingsController`, `SuperUserController`, `SuperAdminAuthController`) ยังเรียก `.setConnection(session('db_conn'))` หรือชี้ไป `envsogo_hs1`/`envsogo_kp1`/`envsogo_super_admin` หรือใช้ใน validation rule `unique:'.session('db_conn').'...` อยู่
2. **Broken Migration Chain (160 ไฟล์)**:
   - มีการแก้ไฟล์ create migration เก่าย้อนหลัง ทำให้ไม่สามารถรัน `php artisan migrate:fresh` บน DB เปล่าตรงๆ ได้ (ใน `deploy-prod.yml` จึงต้องรัน `migrate --path=...` เฉพาะไฟล์ใหม่) ซึ่งจะทำให้การบูต DB ใน Docker และการรัน `RefreshDatabase` ใน PHPUnit พังหากไม่ทำ Schema Dump (`mysql-schema.sql`) หรือซ่อมลำดับ migration ก่อน
3. **Fat controllers**: `InvTransactionController` 888, `Api/InvoiceController` 883, `Admin/UserController` 827, `Tabwater/ReportsController` 811, `Tabwater/InvoiceController` 778, `Api/OwepaperController` 743, `Api/LineController` 702 บรรทัด — มี business logic, query, และ response ปนกัน; มี `Services/` แค่ 2 ไฟล์
4. **ไม่มี FormRequest** สำหรับ domain (มีเฉพาะ Auth) — `validate(` inline ใน 87 ไฟล์ controller; `$request->all()`/`Hash::` ใช้ 46 จุด
5. **Raw DB**: `DB::select/raw/statement` 52 จุด ใน 30 ไฟล์ (เสี่ยง SQL injection, ผูกกับ MySQL, กระทบการ upgrade)
6. **Dead / debug code**: `_Backup_Unused/`, `TestController` (691 บรรทัด, route `/test` ใน `web.php`), `LoginRequest1.php`, view สำเนา (`kiosk copy`, `*copy*.blade.php`, `staff_accessmenu.blade1.php`, `liverwire.blade.php`), `routes/tabwater.php` (ถูก comment ปิดใน `web.php`), `dd/dump` 4 จุด
7. **Repo hygiene & Secrets (ตรวจสอบแล้ว)**:
   - Commit `_ide_helper.php` (936KB), `repomix-output.xml` (2.2MB), `.env.zip`, `.ftpquota`, `.DS_Store`
   - **ผลตรวจ `.env.zip` (2026-10-31):** พบ **Secret จริง** ข้างใน ได้แก่ `LINE_CHANNEL_ACCESS_TOKEN`, `LINE_CHANNEL_SECRET`, `STAFF_LINE_CHANNEL_ACCESS_TOKEN`, `STAFF_LINE_GROUP_ID`, `REVERB_APP_KEY`/`SECRET`, `GEMINI_API_KEY`, และ `APP_KEY` (ส่วน DB ชี้ไป 127.0.0.1 root) → **ต้อง Rotate keys และล้างออกจาก git history**
8. **Models**: `$fillable/$guarded` มีแค่ ~34 ไฟล์จาก ~122; `$casts` ใช้ property แบบเก่า (ใน Laravel 11+ ควรใช้ `casts()` method)
9. **Routing**: ท้ายไฟล์ `routes/web.php` ใช้ `require __DIR__ . '/...'` ดึงไฟล์ route ย่อยเข้ามา (ต้องระวังตอนย้ายไป `bootstrap/app.php` ไม่ให้โหลดซ้ำ), มี closure/inline route ปนกับ `Route::resource`
10. **Static analysis**: larastan level 5 ติดตั้งแล้ว แต่ไม่มี baseline / ไม่รันใน CI

## 3. Goals / Non-goals / Anti-goals
**Goals**
- รัน local ทั้งหมดบน Docker Compose เวอร์ชัน PHP 8.3+ เดียวกับ prod/CI (Task 0) และทำ Schema Dump เพื่อให้รัน migration/test บน DB เปล่าได้
- ถอนแพ็กเกจที่ไม่ได้ใช้งานจริงออก เพื่อลดตัวถ่วงในการอัปเกรด
- เคลียร์สถาปัตยกรรม Multi-Tenancy ที่ค้างครึ่งทางให้เป็นมาตรฐานเดียว (`org_id_fk` + connection หลัก)
- สร้าง safety net (characterization/feature tests) ให้ flow สำคัญก่อนแตะโค้ด
- Upgrade เป็น **Laravel 13** (ผู้ใช้ตัดสินใจ 2026-10-31) บน PHP 8.3+ โดยผ่าน checkpoint Laravel 12 แบบ incremental ผ่าน CI
- ย้ายไปใช้ skeleton ใหม่ (`bootstrap/app.php` fluent config, ไม่มี Kernel/Handler)
- แตก fat controllers → FormRequest + Action/Service + (ถ้าจำเป็น) Resource
- เก็บกวาด dead code / repo hygiene / rotate leaked secrets

**Non-goals**
- ไม่ rewrite เป็น framework/UI stack อื่น, ไม่เปลี่ยน Mix→Vite ใน phase เดียวกับ framework upgrade (แยกเป็น Phase 5)
- ไม่เปลี่ยน database schema เชิงธุรกิจที่กระทบข้อมูลบน production
- ไม่เปลี่ยน behavior ทางธุรกิจ (ใบแจ้งหนี้, แต้ม, คะแนน, LINE notify)

**Anti-goals** (ถือว่าล้มเหลวแม้ "ผ่าน"): downtime/ข้อมูลผิดพลาดบน prod, multi-tenant ข้อมูลรั่วข้าม organization หรือเชื่อมต่อผิด DB จาก `session('db_conn')`, refactor ใหญ่ที่ review ไม่ได้ (PR ใหญ่เกิน ~500 บรรทัด diff)

## 4. Approaches

**A. Big-bang** — upgrade + refactor + skeleton ใน branch เดียว. เร็วสุดบนกระดาษ แต่ไม่มี test, diff ใหญ่, rollback ยาก ❌

**B. Test-first, staged (แนะนำ ✅)** — (0) Docker container + schema baseline + CI → (1) cleanup dead code/unused packages/secrets → (2) safety-net tests + standardize multi-tenancy → (3) upgrade framework 11→12→13 + migrate slim skeleton → (4) refactor ทีละ module → (5) PHP/frontend/CI modernization. ทุก phase merge เข้า main ได้และ deploy ได้เอง. ช้ากว่าแต่เสี่ยงต่ำสุด

**C. Upgrade-first, refactor-later** — upgrade ก่อนโดยไม่เพิ่ม test และไม่เคลียร์ unused packages/tenancy. เสี่ยงติด dependency conflict และไม่สามารถยืนยันว่า behavior ไม่เปลี่ยน

**Recommendation: B** เพราะแอปจัดการเงิน/ใบแจ้งหนี้และมีปัญหา multi-tenancy ลูกผสมค้างอยู่โดยแทบไม่มี test.

## 5. Constraints
- Production: Hostinger (shared/SSH+rsync) — ต้องยืนยัน PHP version ที่ host รองรับ (Laravel 13 ต้อง PHP ≥ 8.3) **ก่อน** bump
- Laravel 11 หมดระยะ security support แล้ว (มี.ค. 2026) → ควร upgrade ไม่เกิน Phase 3
- ทุก phase ต้องมี rollback (git tag + DB backup ก่อน deploy)

## 6. Decisions & Status
1. ~~Target version~~ → **ตัดสินใจแล้ว: ไป Laravel 13** (ผ่าน 12 checkpoint; ต้องใช้ PHP ≥ 8.3)
2. ~~Local environment~~ → **ตัดสินใจแล้ว: รันบน Docker Compose ทั้งหมด**
3. ~~`.env.zip` มี secret จริงหรือไม่~~ → **ตรวจสอบแล้ว: มี Secret จริง** (LINE, Gemini, Reverb, APP_KEY) ต้องทำการ Rotate และลบออกจาก Git
4. **รอคำตอบ:** PHP บน Hostinger อัปเป็น 8.3+ ได้หรือไม่? **(blocker ของ Laravel 13)**
5. **รอคำตอบ:** มี SQL dump โครงสร้างตารางล่าสุดจาก staging/production สำหรับนำมาทำ `database/schema/mysql-schema.sql` ใน Docker หรือไม่?
6. **รอคำตอบ:** ยืนยันทิศทาง Multi-Tenancy ว่าต้องการใช้ **Single-Database (`envsogo_main` + `org_id_fk`)** ทั้งหมด และเลิกใช้การสลับ DB (`envsogo_hs1`, `envsogo_kp1`, `session('db_conn')`) ใช่หรือไม่?
7. **รอคำตอบ:** ยอมให้ลบไฟล์ dead code และถอนแพ็กเกจที่ไม่ได้ใช้ (`livewire`, `laravel-chartjs`, `laravel/ui`) ได้เลยหรือไม่?

## 7. Left to builder
ลำดับ module ภายใน Phase 4, ชื่อ Action/Service class, ระดับ phpstan ที่จะขยับ (เริ่ม baseline ที่ level 5).
