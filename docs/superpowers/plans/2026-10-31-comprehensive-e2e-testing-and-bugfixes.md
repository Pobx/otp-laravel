# Implementation Plan: Comprehensive E2E Testing and Real-World Bugfixes

**Date:** 2026-10-31  
**Target Branch:** `refactor/upgrade-l13-container`  
**Purpose:** Resolve runtime errors identified during user testing (null geo relations, missing role definitions), implement comprehensive end-to-end (E2E) feature test suites covering all major domains, and verify 100% test success.

---

## 1. Problem Analysis & Root Causes

From `storage/logs/laravel.log` and user feedback:

1. **`Attempt to read property "id" on null at app/Models/Admin/Organization.php:97`:**
   - `Organization::getOrgName()` attempts to access `$connection->zones->id` without checking if the relation is null. When an organization lacks full geographic linkage (e.g. `zones` or `provinces` is null), loading `/accessmenu` or any page displaying organization header throws a 500 error.
   - **Fix:** Use nullsafe operator `$connection->zones?->id` and default fallbacks across all geographic fields.

2. **`Spatie\Permission\Exceptions\RoleDoesNotExist: There is no role named 'Annual Fee Staff' for guard 'web'`:**
   - `StaffController.php` and access menu views check for roles like `Annual Fee Staff`, `Food Waste Staff`, `Staff`, `Annual Trash Staff`, `Recycle Bank User`, etc.
   - In `RolesSeeder.php`, only a subset of roles was seeded.
   - When Spatie Permission checks `$user->hasRole(...)` or `hasAnyRole(...)` for an unseeded role, it throws `RoleDoesNotExist`.
   - **Fix:** Seed all referenced roles in `RolesSeeder.php` and `TestUsersSeeder.php`.

3. **Missing E2E / Feature Test Coverage for Real-world Workflows:**
   - Currently, unit/feature tests only cover basic calculation logic and contracts.
   - Need comprehensive E2E tests covering:
     - Authentication & organization selection flow (Super Admin, Staff, User).
     - Admin & Organization Management.
     - Tabwater meter reading, invoicing, and overdue management.
     - KeptKaya waste purchasing, selling, pricing, withdraw batches, and member shop.
     - Foodwaste IoT box and dashboard workflows.

---

## 2. Proposed File Changes

### Code & Fixes:
- `app/Models/Admin/Organization.php`: Add nullsafe operators in `getOrgName()`.
- `database/seeders/RolesSeeder.php`: Add all missing roles (`Annual Fee Staff`, `Food Waste Staff`, `Staff`, `Annual Trash Staff`, `Recycle Bank User`, `Tabwater User`, `Annual Fee User`, `Food Waste User`).
- `database/seeders/TestUsersSeeder.php`: Ensure all roles exist prior to user assignment.

### New Test Suites:
- `tests/Feature/E2E/AuthAndLandingFlowE2ETest.php`: E2E tests for login, role routing, org selection, accessmenu rendering, and logout.
- `tests/Feature/E2E/AdminManagementE2ETest.php`: E2E tests for org switching, user management CRUD, role assignments, and zones.
- `tests/Feature/E2E/TabwaterSystemE2ETest.php`: E2E tests for meter reader mobile view, reading submission, invoice generation, and cutmeter.
- `tests/Feature/E2E/KeptKayaSystemE2ETest.php`: E2E tests for item/pricing config, purchase transaction with points, sell transaction, withdraw batch approval, and member shop.
- `tests/Feature/E2E/FoodWasteSystemE2ETest.php`: E2E tests for food waste dashboard and IoT box transactions.

---

## 3. Step-by-Step Execution Plan

### Task 1: Fix Runtime Bugs (Null-Safe Geo Relations & Missing Roles)
- **Step 1.1:** Update `app/Models/Admin/Organization.php` with nullsafe accessors and fallback values.
- **Step 1.2:** Update `database/seeders/RolesSeeder.php` to seed all required Spatie roles.
- **Step 1.3:** Run `db:seed --class=RolesSeeder` and `db:seed --class=TestUsersSeeder`.
- **Step 1.4:** Verify via Tinker and cURL that logging in as `admin` and navigating to `/accessmenu` renders without errors.
- **Step 1.5:** Commit bugfixes: `fix(core): ensure null-safe organization geo relations and seed all active roles`.

### Task 2: Implement Auth & Landing Flow E2E Tests
- **Step 2.1:** Create `tests/Feature/E2E/AuthAndLandingFlowE2ETest.php`.
- **Step 2.2:** Test Super Admin login -> org selector -> select org -> accessmenu.
- **Step 2.3:** Test Staff login (`Tabwater Staff`, `Recycle Bank Staff`) -> accessmenu / staff_accessmenu.
- **Step 2.4:** Test Citizen login -> accessmenu.
- **Step 2.5:** Run tests: `./app.sh test --filter=AuthAndLandingFlowE2ETest`.
- **Step 2.6:** Commit: `test(e2e): add end-to-end authentication and landing page navigation tests`.

### Task 3: Implement Admin Management E2E Tests
- **Step 3.1:** Create `tests/Feature/E2E/AdminManagementE2ETest.php`.
- **Step 3.2:** Test org listing, user creation with services, updating user, and role assignments.
- **Step 3.3:** Run tests: `./app.sh test --filter=AdminManagementE2ETest`.
- **Step 3.4:** Commit: `test(e2e): add admin and organization management E2E tests`.

### Task 4: Implement Tabwater System E2E Tests
- **Step 4.1:** Create `tests/Feature/E2E/TabwaterSystemE2ETest.php`.
- **Step 4.2:** Test meter reader mobile landing, meter reading recording, invoice period and bill generation, overdue notices.
- **Step 4.3:** Run tests: `./app.sh test --filter=TabwaterSystemE2ETest`.
- **Step 4.4:** Commit: `test(e2e): add tabwater meter reading and billing E2E tests`.

### Task 5: Implement KeptKaya System E2E Tests
- **Step 5.1:** Create `tests/Feature/E2E/KeptKayaSystemE2ETest.php`.
- **Step 5.2:** Test recycle items/pricing listing, purchase transaction with point calculation, sell transaction, withdraw batch creation, and member shop cart/order.
- **Step 5.3:** Run tests: `./app.sh test --filter=KeptKayaSystemE2ETest`.
- **Step 5.4:** Commit: `test(e2e): add KeptKaya waste banking, pricing, and member shop E2E tests`.

### Task 6: Implement FoodWaste System E2E Tests
- **Step 6.1:** Create `tests/Feature/E2E/FoodWasteSystemE2ETest.php`.
- **Step 6.2:** Test executive dashboard rendering and IoT Box data recording.
- **Step 6.3:** Run tests: `./app.sh test --filter=FoodWasteSystemE2ETest`.
- **Step 6.4:** Commit: `test(e2e): add food waste IoT and dashboard E2E tests`.

### Task 7: Full Test Suite Run & Quality Verification
- **Step 7.1:** Run all tests: `./app.sh test`.
- **Step 7.2:** Run PHPStan: `./app.sh phpstan`.
- **Step 7.3:** Run Pint: `./app.sh pint --test`.
- **Step 7.4:** Update documentation and git tag `v2.0.0-l13`.
