# Role-Based Left Menu & Modern Senior-Friendly Form UX Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement a dynamic role-based Left Sidebar navigation using AdminLTE 4 and create reusable Senior-Friendly Form Blade components adhering to ADR 0003, ADR 0004, ADR 0005, and ADR 0006.

**Architecture:** A dedicated `RoleMenuService` and AdminLTE `BuildingMenu` listener dynamically filters sidebar menu items based on the authenticated user's Spatie roles, with a permanent top shortcut back to the Access Hub. Reusable Blade components encapsulate WCAG AAA high-contrast styling, 48px–52px touch targets, Buddhist Era (พ.ศ.) date dual-binding, and single-error focus validation.

**Tech Stack:** Laravel 11, AdminLTE 4 (colorlibhq/adminlte-laravel), Bootstrap 5.3, Spatie Laravel-Permission, PHPStan Level 5.

**Spec:** [`docs/superpowers/specs/2026-11-01-role-menu-and-form-ux-design.md`](docs/superpowers/specs/2026-11-01-role-menu-and-form-ux-design.md)

---

## Global Constraints
- Run all artisan, composer, and testing commands through `./app.sh [command]` (ADR 0001 / Rule 2).
- Follow Senior-Friendly design: background `#FFFFFF`/`#F8FAFC`, font size 16px+, touch targets 48px–52px (ADR 0003).
- Strict adherence to AdminLTE 4 + Bootstrap 5.3; do not mix Tailwind classes in standard AdminLTE views (ADR 0004).
- Forms must include `novalidate`, display Buddhist Era (พ.ศ.) dates while saving ISO `YYYY-MM-DD` (ค.ศ.), filter to first-error only, and align action buttons (Cancel on left, Save on right) (ADR 0005).
- Git Workflow: Work on branch `feat/role-menu-and-form-ux`. When tests pass, push to remote repository and merge to `main` automatically (Rule 4).

## Review Focus
- **User with multiple roles:** Ensure highest privilege or union of roles is safely rendered without duplicate keys.
- **Unauthenticated / Guest access:** Fallback gracefully to default public/auth menu without PHP exception.
- **Form validation with multiple empty required fields:** Verify that only the first error is highlighted and scrolled to, preventing UI clutter.
- **Thai datepicker edge cases:** Verify leap years (e.g. 2567 / 2024) and format conversion correctly sync hidden input before submission.
- **Responsive mobile sidebar:** Ensure touch targets remain >= 48px on 390px mobile screens.

---

### Task 1: Navigation Service & Dynamic Role Menu Listener

**Files:**
- Create: `app/Services/Navigation/RoleMenuService.php`
- Create: `app/Listeners/BuildRoleSidebarMenu.php`
- Modify: `app/Providers/EventServiceProvider.php` (or `bootstrap/providers.php` / AdminLTE config)
- Create: `tests/Unit/RoleMenuServiceTest.php`

**Interfaces:**
- Produces: `RoleMenuService::getMenuForUser(?User $user): array`
- Consumes: `Spatie\Permission\Models\Role`, `Auth::user()`

- [ ] **Step 1: Write Unit Test for RoleMenuService**
  - Create `tests/Unit/RoleMenuServiceTest.php` testing menu output for `Super Admin`, `finance`, and `tabwater` roles.
  - Assert that `finance` role sees payment/invoice menus and does not see machine/workflow menus.
  - Assert that all role configurations contain the Hub link `route('accessmenu')`.

- [ ] **Step 2: Run test to verify it fails**
  - Run: `./app.sh test --filter RoleMenuServiceTest`
  - Expected: Class `RoleMenuService` does not exist.

- [ ] **Step 3: Implement `RoleMenuService`**
  - Create `app/Services/Navigation/RoleMenuService.php`.
  - Implement role-specific menu sections mapping Spatie roles (`Super Admin`, `Admin`, `finance`, `tabwater`, `keptkaya`, `inventory`, `staff`, `User`).
  - Add permanent Hub return button as the topmost navigation item.

- [ ] **Step 4: Implement `BuildRoleSidebarMenu` Listener**
  - Create `app/Listeners/BuildRoleSidebarMenu.php` listening for `ColorlibHQ\AdminLte\Events\BuildingMenu`.
  - Clear default static demo menu items and inject role-filtered menu items.
  - Register listener in `EventServiceProvider.php` or `config/adminlte.php`.

- [ ] **Step 5: Run tests and verify they pass**
  - Run: `./app.sh test --filter RoleMenuServiceTest`
  - Expected: All tests PASS.

- [ ] **Step 6: Commit**
  - `git add app/Services/Navigation/RoleMenuService.php app/Listeners/BuildRoleSidebarMenu.php tests/Unit/RoleMenuServiceTest.php`
  - `git commit -m "feat(nav): add dynamic role-based sidebar menu service and listener"`

---

### Task 2: Reusable Senior-Friendly Blade Form Components

**Files:**
- Create: `resources/views/components/form/card.blade.php`
- Create: `resources/views/components/form/wizard.blade.php`
- Create: `resources/views/components/form/input.blade.php`
- Create: `resources/views/components/form/select.blade.php`
- Create: `resources/views/components/form/thai-date.blade.php`
- Create: `resources/views/components/form/error-banner.blade.php`
- Create: `resources/views/components/form/action-bar.blade.php`
- Create: `tests/Feature/FormComponentsRenderTest.php`

**Interfaces:**
- Produces: Blade components `<x-form.card>`, `<x-form.wizard>`, `<x-form.input>`, `<x-form.select>`, `<x-form.thai-date>`, `<x-form.error-banner>`, `<x-form.action-bar>`

- [ ] **Step 1: Write Blade Component Rendering Test**
  - Create `tests/Feature/FormComponentsRenderTest.php` to render sample form view and assert presence of `novalidate`, `min-height: 48px` or input classes, and Thai date badge.

- [ ] **Step 2: Run test to verify it fails**
  - Run: `./app.sh test --filter FormComponentsRenderTest`
  - Expected: Components not found.

- [ ] **Step 3: Implement Blade Components**
  - Implement `card.blade.php` (white surface, 16px radius, border `#E2E8F0`).
  - Implement `wizard.blade.php` (numbered circles, active/completed states).
  - Implement `input.blade.php` (height 50px, label 16px, required star, hint).
  - Implement `select.blade.php` (height 50px, clear options).
  - Implement `thai-date.blade.php` (visible พ.ศ. input with badge + hidden ISO YYYY-MM-DD input).
  - Implement `error-banner.blade.php` (ADR 0005 single-error alert box).
  - Implement `action-bar.blade.php` (Cancel button on left, Submit button on right, height 52px).

- [ ] **Step 4: Run test to verify it passes**
  - Run: `./app.sh test --filter FormComponentsRenderTest`
  - Expected: PASS.

- [ ] **Step 5: Commit**
  - `git add resources/views/components/form/ tests/Feature/FormComponentsRenderTest.php`
  - `git commit -m "feat(ui): add Senior-Friendly Blade form components"`

---

### Task 3: Client-Side Senior Form Validation & Date Transform Helper

**Files:**
- Create: `resources/js/senior-form-validator.js`
- Modify: `resources/js/adminlte.js` (or app asset bundle)
- Test: In-browser verification with prototype & test runner

**Interfaces:**
- Produces: `window.SeniorFormValidator = { init(), syncThaiDate(input, hiddenInput), handleFirstError(form, errors) }`

- [ ] **Step 1: Create `resources/js/senior-form-validator.js`**
  - Implement automatic event listener on all forms with `novalidate`.
  - Implement Single-Error First Filter: scan `:invalid` controls, find first invalid input, show friendly message in error banner, smooth scroll & focus to the input.
  - Implement Thai Buddhist Era year dual-binding sync (`DD/MM/YYYY` Thai to `YYYY-MM-DD` ISO-8601).
  - Export and import into main JS bundle.

- [ ] **Step 2: Compile assets**
  - Run: `./app.sh npm run build` (or Vite build)

- [ ] **Step 3: Commit**
  - `git add resources/js/senior-form-validator.js resources/js/adminlte.js`
  - `git commit -m "feat(js): add client-side single error focus validator and Thai date sync"`

---

### Task 4: Showcase Form Modernization (Benchmark Template)

**Files:**
- Modify/Create: Showcase view `resources/views/tabwater/member_register.blade.php` or `resources/views/admin/users/create.blade.php`
- Modify: Corresponding route/controller if needed

- [ ] **Step 1: Refactor Showcase Form using Senior Components**
  - Replace raw inputs with `<x-form.card>`, `<x-form.wizard>`, `<x-form.input>`, `<x-form.thai-date>`, and `<x-form.action-bar>`.
  - Include `<x-form.error-banner id="formErrorBanner" />`.
  - Ensure touch targets and visual styling match prototype.

- [ ] **Step 2: Verify in browser and test suite**
  - Check form rendering and responsiveness.

- [ ] **Step 3: Commit**
  - `git add resources/views/`
  - `git commit -m "refactor(views): modernize registration form with Senior-Friendly components"`

---

### Task 5: Static Analysis, Formatting & Test Verification

**Files:**
- All modified and created files

- [ ] **Step 1: Run Code Style Fixer (Pint)**
  - Run: `./app.sh pint`
  - Expected: No styling violations.

- [ ] **Step 2: Run Static Analysis (PHPStan Level 5)**
  - Run: `./app.sh phpstan`
  - Expected: [OK] No errors found.

- [ ] **Step 3: Run Full Test Suite**
  - Run: `./app.sh test`
  - Expected: All tests pass.

- [ ] **Step 4: Commit any cleanup**
  - `git commit -am "chore: format and pass static analysis checks"`

---

### Task 6: Automatic Push & Merge to Main (Per Project Rule 4)

- [ ] **Step 1: Push feature branch to origin**
  - Run: `git push -u origin feat/role-menu-and-form-ux`

- [ ] **Step 2: Checkout main and merge**
  - Run: `git checkout main`
  - Run: `git merge feat/role-menu-and-form-ux`

- [ ] **Step 3: Push main to origin**
  - Run: `git push origin main`

- [ ] **Step 4: Final verification on main**
  - Run: `git status`
  - Confirm repository is clean and up to date.
