# Design Document: Dynamic Left Menu by Role & Modern Senior-Friendly Form UX

## 1. Intent & The Why
ระบบบริหารจัดการเทศบาลดิจิทัล OTP 2025 มีผู้ใช้งานหลัก 2 กลุ่ม:
1. **เจ้าหน้าที่เทศบาลหลากหลายฝ่าย** (ผู้บริหาร, ฝ่ายการเงิน, ฝ่ายประปา, ฝ่ายสาธารณสุขและสิ่งแวดล้อม, เจ้าหน้าที่พัสดุ) ซึ่งส่วนใหญ่มีอายุ 40 ปีขึ้นไป
2. **ประชาชนในท้องถิ่น** ที่เข้ามาดูข้อมูลและยื่นคำร้องขอรับบริการ

ปัญหาปัจจุบันคือ โครงสร้างเมนูด้านซ้าย (Left Sidebar) แตกกระจายอยู่ในหลาย Layouts ที่ไม่สอดคล้องกัน (เช่น `super-admin-navigation`, `inventory_navigation`, `welfare-navigation`, `config/adminlte.php`), รายการเมนูยาวเกินความจำเป็นสำหรับเจ้าหน้าที่เฉพาะทาง, และฟอร์มรับข้อมูลในหลายโมดูลขาดการจัดลำดับข้อมูล (Visual Hierarchy), ไม่มี Step Wizard, และขาดการจัดการ Error Feedback ที่สุภาพตามเกณฑ์ Senior-Friendly (ADR 0003 & ADR 0005)

เอกสารนี้กำหนดแผนการออกแบบและสร้าง **Dynamic Left Menu by Role** ที่รวมศูนย์ผ่าน AdminLTE 4 ร่วมกับ Spatie Permission และพัฒนา **Senior-Friendly Modern Form Component Standard** เพื่อเป็นแม่แบบในการปรับปรุงฟอร์มทั่วทั้งระบบ

---

## 2. Goals, Non-Goals & Anti-Goals

### Goals
- รวมศูนย์การตั้งค่า Left Sidebar ให้อยู่ภายใต้ AdminLTE 4 Menu Configuration (`config/adminlte.php` หรือ Dynamic Menu Builder) โดยคัดกรองเมนูตามบทบาทผู้ใช้ (Spatie Roles / Permissions) แบบอัตโนมัติ
- รองรับการสลับชุดเมนูตามบทบาท เช่น `Super Admin`, `Admin`, `finance`, `tabwater`, `keptkaya`, `inventory`, `staff`, `User` (Citizen)
- มีปุ่มทางลัด "ศูนย์รวมระบบงาน (Hub)" ด้านบนของ Sidebar ให้ผู้ใช้สามารถกลับหน้า Hub (`/accessmenu`) ได้สะดวกในคลิกเดียว
- ออกแบบและสร้างโครงสร้าง Form แม่แบบที่ใช้งานง่าย สบายตา สไตล์ Senior-Friendly:
  - Touch Target สำหรับ Input และ Button ขั้นต่ำ 48px–52px
  - รองรับ Step Wizard นำทางทีละขั้นสำหรับฟอร์มที่มีข้อมูลจำนวนมาก
  - ช่องกรอกวันที่ภาษาไทย (พ.ศ.) แบบ Dual-Binding เก็บเป็น ค.ศ. `YYYY-MM-DD`
  - Single-Error Focus Banner (แสดงเฉพาะข้อผิดพลาดแรกสุด พร้อม Scroll & Focus)
  - Action Bar มาตรฐาน: ปุ่มยกเลิกอยู่ซ้าย ปุ่มบันทึกอยู่ขวา

### Non-Goals
- ไม่เปลี่ยน Business Logic หรือ Controller Endpoints เดิม
- ไม่ลบ Data Tables หรือ APIs ฝั่ง Backend
- ไม่ใช้ Tailwind CSS หรือ CSS Framework อื่นที่ขัดแย้งกับ Bootstrap 5.3 (ตามข้อห้ามใน ADR 0004)

### Anti-Goals
- ห้ามเรนเดอร์เมนูทุกระบบรวมกันเป็น Accordion ขนาดยาวที่ต้อง Scroll ลึก (เพราะทำให้เจ้าหน้าที่ 40+ ปีสับสน)
- ห้ามใช้ Browser Native Tooltip สำหรับ Form Validation
- ห้ามแสดง Database Exception หรือ Technical Jargon บนหน้าจอ

---

## 3. Constraints
- สอดคล้องกับ **ADR 0003** (Senior-Friendly White Theme: `#FFFFFF`/`#F8FAFC`, ตัวอักษร 16px+, High Contrast)
- สอดคล้องกับ **ADR 0004** (AdminLTE 4 + Bootstrap 5.3 + Vite)
- สอดคล้องกับ **ADR 0005** (Form Standards: `novalidate`, Dual-Binding พ.ศ./ค.ศ., Single-Error Focus, SweetAlert2 Feedback)
- คำสั่ง CLI ทั้งหมดต้องรันผ่าน `./app.sh [command]` (ADR 0001 / Rule)
- การทำงานต้องทำบน branch แยก (`feat/role-menu-and-form-ux`) และเมื่อเสร็จสิ้นให้ push & merge เข้า `main` อัตโนมัติ (Rule 4)

---

## 4. Approaches Considered

### Approach 1: Dynamic Role-Scoped Sidebar (Selected & Recommended)
- **กลไก:** ใช้ AdminLTE 4 ร่วมกับ Custom Menu Filter (`RoleMenuFilter.php` / `GateFilter`) หรือ Dynamic Menu Provider ที่ตรวจสอบ Spatie Roles/Permissions ของ `Auth::user()` เพื่อส่งเฉพาะรายการเมนูที่เกี่ยวข้องกับ Role นั้นๆ ไปยัง Sidebar
- **ข้อดี:** เมนูสั้น กระชับ มีพื้นที่แนวตั้งกว้างขวาง ตัวอักษร 16px สบายตา ผู้ใช้ไม่เกิด Cognitive Overload
- **การตัดสินใจ:** ผู้ใช้เห็นชอบและเลือกแนวทางนี้

### Approach 2: Unified Mega Accordion Sidebar (Rejected)
- **กลไก:** นำทุกโมดูลมารวมไว้ใน Sidebar เดียว โดยใช้ Collapsible Treeview ซ้อนกันหลายชั้น
- **ข้อเสีย:** รายการเมนูยาวมาก ผู้สูงอายุต้องเลื่อน Scrollbar หาเมนู และเสี่ยงต่อการคลิกผิด ขัดกับแนวคิด Senior-Friendly

---

## 5. Architecture & Implementation Specification

### 5.1 Left Menu by Role Architecture
1. **Menu Provider / Service (`app/Services/Navigation/RoleMenuService.php`):**
   - ลงทะเบียนรายการเมนูแยกตาม Scope/Role (เช่น `superadmin`, `finance`, `tabwater`, `keptkaya`, `inventory`, `member`)
   - ตรวจสอบ Role ของ `Auth::user()` ผ่าน Spatie Permission (`hasRole`, `can`)
   - กรองและประกอบโครงสร้าง Menu Array สำหรับส่งต่อให้ AdminLTE Sidebar
2. **AdminLTE Integration (`config/adminlte.php`):**
   - ใช้งาน Event Listener `BuildingMenu` ของ AdminLTE 4 (`App\Listeners\BuildRoleSidebarMenu`) เพื่อแทรกเมนูตาม Role ในช่วง Runtime
   - แสดง Sidebar Header Card (ชื่อผู้ใช้, บทบาท, เทศบาล, ปุ่มกลับ Hub)
3. **Senior-Friendly Sidebar Styling:**
   - Touch Target เมนูความสูงขั้นต่ำ 48px
   - มี Hover & Active State ชัดเจน (พื้นหลัง `#E0F2FE`, ข้อความและไอคอน `#0284C7`)
   - Badge แจ้งเตือนจำนวนงานค้าง (เช่น บิลค้างชำระ, งานตัดมิเตอร์)

### 5.2 Modern Senior-Friendly Form Architecture
1. **Reusable Blade Components (`resources/views/components/form/`):**
   - `x-form.card`: การ์ดครอบฟอร์มสไตล์ Senior-White ขอบมน 16px พร้อมหัวข้อและคำอธิบาย
   - `x-form.wizard`: Step Wizard Indicator (ขั้นตอนที่ 1-2-3)
   - `x-form.input`: Text/Number input รองรับ 50px height, label 16px, required star, floating hint
   - `x-form.select`: Select dropdown ขนาด 50px
   - `x-form.thai-datepicker`: ช่องเลือกวันที่ พ.ศ. พร้อม Dual-Binding กับ input hidden ค.ศ.
   - `x-form.error-banner`: Single-Error Display Banner พร้อม Auto-scroll และ Auto-focus
   - `x-form.action-bar`: ปุ่มยกเลิก (ซ้าย) และปุ่มบันทึก (ขวา)
2. **Client Validation Helper (`resources/js/senior-form-validator.js`):**
   - Intercept event `submit` ของ form ที่มี `novalidate`
   - ค้นหาฟิลด์ที่มี invalid เป็นตัวแรก (First Error Only)
   - แสดงข้อความภาษาไทยสุภาพใน Error Banner และเลื่อนหน้าจอไปยังฟิลด์นั้น

---

## 6. What's Left to the Builder
- สร้าง `App\Services\Navigation\RoleMenuService` และ `App\Listeners\BuildRoleSidebarMenu`
- สร้าง Blade Components ใน `resources/views/components/form/`
- นำร่องปรับแต่งหน้าฟอร์มตัวอย่าง (เช่น ฟอร์มลงทะเบียนผู้ใช้น้ำ/ติดตั้งมิเตอร์ `resources/views/admin/users/create.blade.php` หรือหน้าคำร้องที่เกี่ยวข้อง)
- บันทึกเอกสาร `ADR 0006` และอัปเดต `docs/adr/README.md`
- ตรวจสอบด้วย PHPStan Level 5 และรัน Pint ตามมาตรฐานระบบ
