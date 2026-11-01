# Refactor & Laravel 11→13 Upgrade Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Containerize local development, standardize half-migrated multi-tenancy, upgrade the app from Laravel 11.47 (Laravel-10 skeleton) to Laravel 13 (via a 12 checkpoint) on the slim skeleton, and refactor fat controllers into FormRequest + Action classes without changing business behavior.

**Architecture:** Staged, test-first. Each phase is an independently mergeable/deployable branch. Unused packages and broken migration chains are resolved before the framework upgrade. Characterization tests land before any framework or controller change. Controllers keep their routes/URLs; logic moves into `app/Actions/<Module>/` and `app/Http/Requests/<Module>/`.

**Tech Stack:** Docker Compose, PHP 8.3+ (Laravel 13 minimum), Laravel 13, MySQL 8, Redis, PHPUnit 10/11, Larastan 3, Spatie Permission 6, Reverb, Sanctum, Maatwebsite Excel, DomPDF, Tesseract OCR, Mix→(optional) Vite.

**Spec:** [`../specs/2026-10-31-refactor-and-upgrade-design.md`](../specs/2026-10-31-refactor-and-upgrade-design.md) — **must be approved first** (open decisions in §6 there).

## Global Constraints
- Branch from `main`; never push to `prod` until a phase is verified on staging.
- No destructive change to existing production tables; new/idempotent migrations only.
- URLs, route names, JSON response shapes of `routes/api.php` and LINE/LIFF endpoints stay identical.
- One PR ≤ ~500 changed lines (excluding deletions of dead files, schema dumps, and lockfiles).
- Run before each commit (inside the container: `docker compose exec app …`): `php artisan test` and `vendor/bin/phpstan analyse` (no new errors vs baseline).
- **Target: Laravel 13 (final decision, 2026-10-31); PHP ^8.3 is a hard prerequisite — Hostinger and CI must be on 8.3+ before Task 11.**
- **Local development runs in containers (Docker Compose), not on host PHP.** Host `php` is a broken 7.4, so all commands run as `docker compose exec app <cmd>` (documented in README). Container PHP version = production/CI version (8.3).

## Review Focus
- **Tenant & Connection isolation:** A user of organization A must never read/update records of org B, and no controller/validation rule may fail or leak across DB connections due to leftover `session('db_conn')` calls → tested in Task 6 & fixed in Task 6.5.
- **Invoice amount calculation:** Meter reading → total, rounding, vat/penalty must be bit-identical before/after refactor → golden-value test in Task 7.
- **Kiosk/KeptKaya point balance:** Purchase/transfer must not double-credit on retry → idempotency test in Task 8.
- **Mass assignment (`$request->all()`):** Unknown fields must not alter protected columns (`org_id_fk`, `role`, balances) → test in Task 9.
- **Slim skeleton routing & CSRF:** `routes/web.php` nested `require` files must not be double-registered, and `PreventRequestForgery` (L13) must not block valid form POSTs or `api/*` webhooks → test in Task 12.

---

## Phase 0 — Containerized Environment, Schema Baseline & Tooling

### Task 0: Containerized local environment & DB Schema Squatting
**Files:** Create `docker/php/Dockerfile`, `docker/php/php.ini`, `docker/nginx/default.conf`, `compose.yaml`, `Makefile`, `database/schema/mysql-schema.sql`; Modify `.env.example`, `.dockerignore`, `.github/workflows/deploy-prod.yml`, `README.md`
**Interfaces:** Produces: services `app` (php-fpm 8.3), `web` (nginx, http://localhost:8080), `db` (mysql 8, volume `dbdata`), `db_test` (mysql 8, tmpfs for PHPUnit), `redis`, `node` (Mix/Vite watcher), `reverb` (`php artisan reverb:start`, port 8081), `queue` (`php artisan queue:work`), `mailpit`; `make up|down|sh|test|stan|migrate|seed`. Every later "Run:" command is executed via `docker compose exec app ...`.
- [ ] **Step 1:** Write `docker/php/Dockerfile` (`php:8.3-fpm`, extensions `pdo_mysql bcmath gd intl zip mbstring exif pcntl redis`, `composer`, **`tesseract-ocr` + `tesseract-ocr-tha`** for `thiagoalessio/tesseract_ocr`, Thai fonts (`fonts-tlwg-*` / Sarabun) for DomPDF, `mysql-client` for `schema:dump`, non-root user matching host UID).
- [ ] **Step 2:** Write `compose.yaml` with healthchecks, bind-mount source, named volumes for `vendor`/`node_modules` (avoid macOS slowness), `db` and `db_test` (tmpfs) services; update `.env.example` (`DB_CONNECTION=envsogo_main`, `DB_HOST_S_ADMIN=db`, `REDIS_HOST=redis`, `REVERB_HOST` for browser = `localhost`, server host = `reverb`).
- [ ] **Step 3 (Fix broken 160-migration chain):** Because historic migrations were edited retroactively (per `deploy-prod.yml` notes), running `migrate:fresh` from scratch fails. Load a clean production/staging schema structure (or reconcile conflicting early migrations) into `db` and generate `database/schema/mysql-schema.sql` via `docker compose exec app php artisan schema:dump` so `migrate:fresh` and `RefreshDatabase` work cleanly on empty DBs.
- [ ] **Step 4:** Run `docker compose up -d --build && docker compose exec app composer install && docker compose exec app php artisan key:generate && docker compose exec app php artisan migrate:fresh --seed`. Expected: `http://localhost:8080` renders login page; `docker compose ps` all healthy.
- [ ] **Step 5:** Verify inside container: `tesseract --list-langs` contains `tha`, PDF with Thai font renders without garbled text, Reverb responds on 8081.
- [ ] **Step 6:** Update `.github/workflows/deploy-prod.yml` `rsync` step to `--exclude='docker/' --exclude='docs/' --exclude='compose.yaml' --exclude='Makefile' --exclude='phpstan*'`.
- [ ] **Step 7:** Document in `README.md` (setup, `make` targets, how to load a DB dump); commit `chore: containerized local dev environment and schema dump`.

### Task 1: Baseline in the container
**Files:** Modify `phpstan.neon`; Create `phpstan-baseline.neon`, `docs/superpowers/notes/baseline.md`
**Interfaces:** Consumes Task 0 containers. Produces: green reference commands used by every later task.
- [ ] **Step 1:** `docker compose up -d`; verify `docker compose exec app php -v` is 8.3.
- [ ] **Step 2:** `docker compose exec app php artisan test` (using `db_test`). Expected: Example/Auth tests PASS. Record result in `baseline.md`.
- [ ] **Step 3:** `docker compose exec app vendor/bin/phpstan analyse --memory-limit=1G --generate-baseline` → commit `phpstan-baseline.neon`; add `- phpstan-baseline.neon` to `includes:` in `phpstan.neon`.
- [ ] **Step 4:** Create `docker compose exec app php artisan route:list --json > docs/superpowers/notes/routes-before.json` (used to prove routes are unchanged after upgrade).
- [ ] **Step 5:** `git tag pre-upgrade-baseline`; commit `chore: add phpstan baseline and route snapshot`.

### Task 2: CI for tests + static analysis
**Note:** CI environment must mirror the Task 0 container (same PHP 8.3 version, extensions, and MySQL 8 service).
**Files:** Create `.github/workflows/ci.yml`
**Interfaces:** Consumes Task 1 baseline. Produces: required check on PRs.
- [ ] **Step 1:** Workflow on `pull_request` and `push` to `main`: setup-php 8.3 with identical extensions + MySQL 8 service container, `composer install`, `php artisan test`, `vendor/bin/phpstan analyse --memory-limit=1G`.
- [ ] **Step 2:** Open PR; Expected: CI green.
- [ ] **Step 3:** Commit `ci: run tests and phpstan on PRs`.

---

## Phase 1 — Safe Cleanup & Dependency Pruning (no behavior change)

### Task 3: Secret rotation & repo hygiene
**Files:** Delete (`git rm --cached`) `_ide_helper.php`, `repomix-output.xml`, `.env.zip`, `.ftpquota`, `.DS_Store`; Modify `.gitignore`
- [ ] **Step 1 (Manual / Owner Action):** Rotate leaked secrets confirmed in `.env.zip` on 2026-10-31:
  - `LINE_CHANNEL_ACCESS_TOKEN` & `LINE_CHANNEL_SECRET`
  - `STAFF_LINE_CHANNEL_ACCESS_TOKEN` & `STAFF_LINE_GROUP_ID`
  - `GEMINI_API_KEY`
  - `REVERB_APP_ID`, `REVERB_APP_KEY`, `REVERB_APP_SECRET`
  - Verify if production uses the leaked `APP_KEY`; if so, schedule key rotation.
- [ ] **Step 2:** Fix `.gitignore`: remove `.env.example` from ignore list; add `_ide_helper*.php`, `.phpstorm.meta.php`, `repomix-output.xml`, `.env.zip`, `.ftpquota`, `.DS_Store`, `/storage/*.key`.
- [ ] **Step 3:** `git rm --cached _ide_helper.php repomix-output.xml .env.zip .ftpquota .DS_Store`; commit `chore: untrack generated and secret archive files`.
- [ ] **Step 4 (Optional, with owner sign-off):** Purge `.env.zip` from git history using `git filter-repo --path .env.zip --invert-paths` and force-push.

### Task 4: Remove dead code & unused Composer packages
**Files:** Modify `composer.json`, `composer.lock`, `routes/web.php:44,148-149,522`; Delete `app/Http/Controllers/_Backup_Unused/`, `app/Http/Requests/Auth/LoginRequest1.php`, `resources/views/layouts/liverwire.blade.php`, `resources/views/kiosk copy/`, `resources/views/*copy*.blade.php`, `staff_accessmenu.blade1.php`, `kiosk-monitor.blade copy.php`
- [ ] **Step 1:** Verify zero references across `app/`, `routes/`, `resources/` for each dead file and unused package (`livewire/livewire`, `icehouse-ventures/laravel-chartjs`, `laravel/ui`, `laravel/sail`, `doctrine/dbal`, `spatie/laravel-ignition`).
- [ ] **Step 2:** Run `docker compose exec app composer remove livewire/livewire icehouse-ventures/laravel-chartjs laravel/ui doctrine/dbal` and `--dev laravel/sail spatie/laravel-ignition`.
- [ ] **Step 3:** Inspect `routes/tabwater.php` (currently commented out at `routes/web.php:522`). Confirm all active Tabwater routes live in `routes/web.php`; delete `routes/tabwater.php` if superseded, or document in `notes/findings.md`.
- [ ] **Step 4:** Gate `TestController` routes behind `if (app()->environment('local'))` in `routes/web.php`, delete the backup views/controllers, and remove the 4 `dd/dump` calls.
- [ ] **Step 5:** Run `php artisan view:cache && php artisan route:list` and `php artisan test && vendor/bin/phpstan analyse`. Diff `route:list --json` vs `routes-before.json` (only `/test*` and unused Livewire routes removed).
- [ ] **Step 6:** Commit `chore: prune unused packages, dead files, and debug calls`.

---

## Phase 2 — Safety-Net Tests & Multi-Tenancy Standardization

### Task 5: Test infrastructure (factories + MySQL test DB)
**Files:** Create `database/factories/{UserFactory,OrganizationFactory,...}.php` for core models; Modify `phpunit.xml`, `tests/TestCase.php`
**Interfaces:** Produces: `User::factory()->forOrganization($org)`, `actingAsStaff($org)` helper in `tests/TestCase.php`.
- [ ] **Step 1:** Configure `phpunit.xml` to use `db_test` (MySQL 8 tmpfs service from Task 0) so raw MySQL queries (`DB::select`, `information_schema`) are tested accurately.
- [ ] **Step 2:** Write failing smoke test `tests/Feature/SmokeTest.php`: login page renders, and each module landing route returns 200/302 for an authenticated user.
- [ ] **Step 3:** Implement factories + `TestCase` helpers; run `docker compose exec app php artisan test` → PASS.
- [ ] **Step 4:** Commit `test: add factories and smoke tests on mysql test db`.

### Task 6: Tenant isolation & connection consistency tests
**Files:** Create `tests/Feature/TenantIsolationTest.php`
- [ ] **Step 1:** Write tests asserting `user_of_org_a_cannot_see_or_mutate_org_b_records` across Tabwater (invoices, budget years, invoice periods), KeptKaya (items, units, purchases, sells), Inventory (transactions), and FoodWaste.
- [ ] **Step 2:** Write test asserting that requests work when `session('db_conn')` is **not** set (exposing controllers that still rely on `.setConnection(session('db_conn'))`).
- [ ] **Step 3:** Run tests and record all failures in `docs/superpowers/notes/findings.md`. Commit `test: add tenant isolation and connection consistency tests`.

### Task 6.5: Standardize Multi-Tenancy (`org_id_fk` vs `session('db_conn')`)
**Files:** Modify controllers/models still referencing `session('db_conn')`, `envsogo_hs1`, `envsogo_kp1`, `envsogo_super_admin` (`KpTbankUnitsController`, `KpTbankItemsController`, `KpSellController`, `KpPurchaseController`, `BudgetYearController`, `InvoicePeriodController`, `Tabwater/InvoiceController`, `Tabwater/SettingsController`, `SuperUserController`, `SuperAdminAuthController`, `FunctionsController`, `Api/LineController`); Delete or deprecate `app/Http/Middleware/SetTenantConnection.php`
**Interfaces:** Produces: uniform single-DB multi-tenancy via default connection (`envsogo_main`) + `BelongsToOrganization` global scope (`org_id_fk`).
- [ ] **Step 1:** Replace `.setConnection(session('db_conn'))` and `Model::on(session('db_conn'))` with standard Eloquent queries scoped by `BelongsToOrganization` (or explicit `where('org_id_fk', ...)`).
- [ ] **Step 2:** Replace connection-prefixed validation rules (`unique:'.session('db_conn').'.table,col`, `exists:'.session('db_conn').'.table,id`) with `Rule::unique('table', 'col')->where('org_id_fk', $orgId)` and `Rule::exists(...)`.
- [ ] **Step 3:** Audit models missing `BelongsToOrganization` that have an `org_id_fk` column; add the trait where appropriate and verify with `TenantIsolationTest`.
- [ ] **Step 4:** Remove dead `SetTenantConnection` middleware (already commented out in `Kernel.php`).
- [ ] **Step 5:** Run `TenantIsolationTest` + full test suite + phpstan → PASS. Commit `refactor(tenancy): standardize on single-db org_id_fk and remove session db_conn`.

### Task 7: Tabwater invoice/payment characterization
**Files:** Create `tests/Feature/Tabwater/InvoiceCalculationTest.php`, `tests/Feature/Tabwater/PaymentTest.php`
- [ ] **Step 1:** Capture 5 golden cases from production-like data (meter prev/curr, rate tiers, minimum charge, vat, rounding) as `test_invoice_total_matches_golden_*` asserting exact satang values.
- [ ] **Step 2:** Run → PASS against current code (characterization; do not alter calculation formulas). Commit.

### Task 8: KeptKaya / Kiosk / FoodWaste characterization
**Files:** Create `tests/Feature/KeptKaya/PurchaseTest.php`, `tests/Feature/Kiosk/KioskMatchTest.php`, `tests/Feature/FoodWaste/RewardTest.php`
- [ ] **Step 1:** Write `test_purchase_credits_points_once`, `test_repeated_request_does_not_double_credit`, `test_point_transfer_conserves_total`.
- [ ] **Step 2:** Run → PASS (or log existing bugs in `notes/findings.md`). Commit.

### Task 9: API contract tests
**Files:** Create `tests/Feature/Api/{InvoiceApiTest,UsersApiTest,LineApiTest,OwepaperApiTest}.php`
- [ ] **Step 1:** For each `routes/api.php` endpoint used by mobile/LIFF/Kiosk: assert status + JSON structure (`assertJsonStructure`) with Sanctum auth; add `test_unknown_fields_are_ignored` for endpoints using `$request->all()`.
- [ ] **Step 2:** Mock LINE HTTP calls via `Http::fake()`. Run → PASS. Commit.

---

## Phase 3 — Upgrade to Laravel 13 (via 12 checkpoint) + Slim Skeleton

### Task 10: Framework 11 → 12 → 13
**Files:** Modify `composer.json`, `composer.lock`, `.github/workflows/{ci,deploy-prod}.yml` (php-version 8.3); **Test** full suite.
**Interfaces:** Consumes Tasks 5–9 as the regression gate. Produces: git tags `l12-checkpoint`, `l13`.
- [ ] **Step 1 (prerequisite):** Confirm Hostinger PHP ≥ 8.3 (switch in hPanel and verify `php -v` over SSH); update `deploy-prod.yml` `php-version: "8.3"` while still on Laravel 11. Deploy to staging; Expected: app unchanged.
- [ ] **Step 2:** Read the official Laravel 12 and 13 upgrade guides; document applicable items in `docs/superpowers/notes/l13-impact.md`:
  - **CSRF / Request Forgery (L13):** `VerifyCsrfToken` renamed to `PreventRequestForgery` with origin-aware `Sec-Fetch-Site` check; verify all POST forms, AJAX calls, and `api/*` / LINE webhook exclusions.
  - **`Http::pool()` (L13):** Default concurrency is now `2`; inspect `Api/LineController` and `Tabwater/NotifyController`.
  - **Carbon 3 & PHPUnit 11:** Verify date helpers (`CarbonTranslator.php`) and test annotations.
  - **`simplesoftwareio/simple-qrcode`:** Used only in `LineLiffController.php:123`; if it blocks L13, replace directly with `bacon/bacon-qr-code` or `chillerlan/php-qrcode`.
- [ ] **Step 3 (Laravel 12 checkpoint):** Set `laravel/framework: ^12.0` in `composer.json`, bump `larastan/larastan`, `spatie/laravel-permission`, `maatwebsite/excel`, `laravel/reverb`, `laravel/sanctum`, `barryvdh/laravel-dompdf`, `nunomaduro/collision`, `phpunit/phpunit`. Run `docker compose exec app composer update -W`; run `php artisan test && vendor/bin/phpstan analyse` → PASS. Commit and tag `l12-checkpoint`.
- [ ] **Step 4 (Laravel 13 upgrade):** Run `composer why-not laravel/framework 13`. Set `"php": "^8.3"`, `"laravel/framework": "^13.0"` and update remaining package constraints. (If any package has no stable L13 tag yet, record options in `notes/l13-impact.md` before proceeding.)
- [ ] **Step 5:** Run `docker compose exec app composer update -W`; run full test suite + phpstan → PASS.
- [ ] **Step 6:** Compare `php artisan route:list --json` with `routes-before.json` → identical.
- [ ] **Step 7:** Commit `chore: upgrade to laravel 13`, tag `l13`. Deploy to staging and execute manual checklist in `notes/staging-checklist.md` (login, tenant data, PDF/Excel export, QR code, OCR, LINE webhook, Reverb websocket, kiosk flow).

### Task 11: Migrate to slim skeleton (on Laravel 13)
**Files:** Rewrite `bootstrap/app.php`; Create `bootstrap/providers.php`; Delete `app/Http/Kernel.php`, `app/Console/Kernel.php`, `app/Exceptions/Handler.php`, `app/Providers/{RouteServiceProvider,EventServiceProvider,BroadcastServiceProvider,AuthServiceProvider}.php`, and default middleware wrappers (`EncryptCookies`, `TrimStrings`, `TrustProxies`, `TrustHosts`, `VerifyCsrfToken`, `Authenticate`, `RedirectIfAuthenticated`, `PreventRequestsDuringMaintenance`); Modify `routes/console.php`, `app/Providers/AppServiceProvider.php`.
**Interfaces:** Produces: `Application::configure(basePath: dirname(__DIR__))->withRouting(web:, api:, commands:, channels:, health: '/up')->withMiddleware(...)->withExceptions(...)->create()`.
- [ ] **Step 1:** Write `tests/Feature/BootstrapTest.php`:
  - Middleware aliases `role`, `permission`, `role_or_permission` resolve.
  - Unauthenticated redirect goes to `/login` and post-login redirect goes to `/accessmenu` (previously `RouteServiceProvider::HOME`).
  - CSRF-excluded URIs (`api/*`) are excluded via `$middleware->preventRequestForgery(except: ['api/*'])`.
  - Scheduled commands (`invoice:archive` daily at 23:25, `recycle:check-waive` monthlyOn 1 at 00:01) appear in `php artisan schedule:list`.
  - Rate limiter `api` (60/min) is registered in `AppServiceProvider::boot()`.
  Run on old skeleton → PASS.
- [ ] **Step 2:** Port configuration to `bootstrap/app.php`, `bootstrap/providers.php`, `routes/console.php`, and `AppServiceProvider`:
  - **Important:** Keep `routes/web.php` as the single `web:` entry in `withRouting` for now because `routes/web.php` still has `require __DIR__ . '/...'` at lines 516–521 (do **not** register those sub-files twice; Task 13 cleans them up).
  - Configure `$middleware->redirectUsersTo('/accessmenu')`.
- [ ] **Step 3:** Run `BootstrapTest` + full suite + `route:list --json` diff (must match URL, name, and middleware stack per route). Expected: PASS.
- [ ] **Step 4:** Update models using `$casts` property (34 files) to `protected function casts(): array` (mechanical, 1 commit).
- [ ] **Step 5:** Commit `refactor: adopt laravel 13 slim application skeleton`. Re-deploy to staging.

---

## Phase 4 — Controller Refactor, Routing & Model Hardening

Order (by risk/size): `Admin/UserController` (827) → `Tabwater` (`InvoiceController` 778, `ReportsController` 811, `PaymentController` 673, `SettingsController` 552, `NotifyController` 530) → `Api` (`InvoiceController` 883, `OwepaperController` 743, `LineController` 702, `UsersController` 612) → `Inventory/InvTransactionController` (888) → `KeptKaya/KpPurchaseController` (542) → `FoodWaste` → `Kiosk`.

### Task 12 (template, repeat per controller): Extract FormRequest + Action
**Files (example `Tabwater/InvoiceController`):** Create `app/Http/Requests/Tabwater/StoreInvoiceRequest.php`, `app/Actions/Tabwater/CalculateInvoiceTotal.php`, `app/Actions/Tabwater/IssueInvoice.php`; Modify `app/Http/Controllers/Tabwater/InvoiceController.php`; Test existing characterization tests (Tasks 6–9) + new unit tests for each Action.
**Interfaces:** Produces: `final class CalculateInvoiceTotal { public function __invoke(UserMeterInfo $meter, MeterReading $reading): InvoiceAmount }` (one public `__invoke`/`handle`, typed DTO/model in and out).
- [ ] **Step 1:** Write unit test for the Action using the golden values from Task 7. Run → FAIL (class missing).
- [ ] **Step 2:** Move logic into the Action (cut/paste first, no behavior edits); controller calls Action via method/constructor injection.
- [ ] **Step 3:** Replace inline `$request->validate([...])` with FormRequest, keeping rules and Thai error messages identical; use `$request->validated()` instead of `$request->all()`.
- [ ] **Step 4:** Replace `DB::select/raw` with Eloquent/query builder only where output is covered by a test; otherwise parameterize bindings and list in `notes/raw-sql.md`.
- [ ] **Step 5:** `php artisan test && vendor/bin/phpstan analyse` PASS; target controller < 250 lines, methods < 40 lines.
- [ ] **Step 6:** Commit `refactor(<module>): extract actions and form requests`; one PR per controller.

### Task 13: Routing cleanup & route caching
**Files:** Modify `routes/web.php`, `bootstrap/app.php`; Move sub-route files into `routes/modules/{auth,admin,foodwaste,keptkaya,keptkaya_mobile,annual_trash}.php`
- [ ] **Step 1:** Remove `require __DIR__ . '/...'` from the bottom of `routes/web.php` (lines 516–521) and register each module route file cleanly via `withRouting(then: ...)` in `bootstrap/app.php` under the `web` middleware group.
- [ ] **Step 2:** Convert the 16 closure routes to Invokable/Controller actions so `php artisan route:cache` works in production.
- [ ] **Step 3:** Verify `php artisan route:cache` succeeds and `route:list --json` diff shows zero URL, name, or middleware changes. Add `php artisan route:cache` to `deploy-prod.yml`. Commit.

### Task 14: Models hardening & N+1 prevention
**Files:** Modify `app/Models/**`, `app/Providers/AppServiceProvider.php`
- [ ] **Step 1:** Add `$fillable` (or Laravel 13 `#[Fillable([...])]`) to the ~88 models currently missing mass-assignment protection — starting with models written in controllers; verify `test_unknown_fields_are_ignored` (Task 9) stays green.
- [ ] **Step 2:** Enable `Model::preventLazyLoading(! app()->isProduction())` in `AppServiceProvider::boot()`; fix N+1 queries surfaced by tests in Tabwater reports and KeptKaya dashboards using `.with(...)`.
- [ ] **Step 3:** Commit per module.

---

## Phase 5 — Modernization & Post-Upgrade Hardening

### Task 15: Strict quality gates & Deployment migration cleanup
**Files:** Modify `phpstan.neon`, `.github/workflows/deploy-prod.yml`; Create `pint.json`
- [ ] **Step 1:** Raise Larastan level 5→6 on `app/Actions` and `app/Http/Requests` first, shrinking `phpstan-baseline.neon` as controllers are refactored.
- [ ] **Step 2:** Install `laravel/pint --dev`, configure `pint.json` (PSR-12 / Laravel preset), run once in a dedicated style-only commit, and add `vendor/bin/pint --test` to `.github/workflows/ci.yml`.
- [ ] **Step 3:** Clean up `.github/workflows/deploy-prod.yml` step 3 (`php artisan migrate --path=...`): sync the `migrations` table on production so normal `php artisan migrate --force` can run without hardcoded `--path` flags.

### Task 16: Frontend Mix → Vite (optional, separate PR)
**Files:** Modify `package.json`, `compose.yaml` (`node` service command → `npm run dev -- --host`), layouts (`@mix` → `@vite`); Create `vite.config.js`; Delete `webpack.mix.js`
- [ ] **Step 1:** Install `vite`, `laravel-vite-plugin`, bump `axios`; port `webpack.mix.js` entries to `vite.config.js`.
- [ ] **Step 2:** Verify `npm run build` succeeds; visual smoke test of each module layout; update `deploy-prod.yml` (`npm run build`). Commit.

### Task 17: Final audit
- [ ] **Step 1:** Confirm zero references to deprecated middleware/aliases (`grep -rn "VerifyCsrfToken\|SetTenantConnection\|session('db_conn')" app bootstrap routes` → 0 matches).
- [ ] **Step 2:** Run `composer outdated --direct` and `composer audit`; Expected: 0 security advisories. Tag release `v2.0.0-l13`.

## Self-Review
- **Spec coverage:** Docker Compose + Thai OCR/PDF (T0), broken migration chain / schema dump (T0), CI (T2), leaked `.env.zip` secrets & repo hygiene (T3), unused packages removal (T4), safety-net tests (T5–9), half-migrated multi-tenancy standardization (T6–6.5), Laravel 11→12→13 upgrade (T10), slim skeleton & `web.php` nested requires (T11, T13), fat controller refactor (T12), models & N+1 (T14), Pint & deploy workflow cleanup (T15), Mix→Vite (T16), final audit (T17). ✔
- **Consistency:** `db_test` (T0) is used by PHPUnit (T5); `routes-before.json` & `phpstan-baseline.neon` (T1) gate T4, T10, T11, T13; golden values (T7) gate T10 and T12. ✔
- **Remaining owner inputs before execution:** Hostinger PHP 8.3+ support, production/staging schema dump for `mysql-schema.sql`, and confirmation of single-DB (`org_id_fk`) tenancy direction.
