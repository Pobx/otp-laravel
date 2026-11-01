# OTP 2025 - รายงานผลการทดสอบ End-to-End (E2E Test Report & Visual Screenshots)

วันที่ทดสอบ: 31 ตุลาคม 2026  
สภาพแวดล้อม: Docker Environment (`otp2025_app`, `otp2025_web`, `otp2025_db`, `otp2025_redis`)  
Laravel Version: 13.x | PHP Version: 8.3  
URL ทดสอบ: `http://localhost:8080`  
ที่จัดเก็บภาพ Screenshot: [`docs/screenshots/`](./screenshots/)

---

## 1. ภาพรวมการทดสอบ (Executive Summary)

ระบบได้รับการทดสอบ End-to-End (E2E) แบบ Real Browser Automation ครอบคลุมการทำงานจริงทุกฟังก์ชัน (Full Functionality) ตั้งแต่ Authentication, สิทธิ์การเข้าถึงตามบทบาท (Multi-role RBAC), โมดูลบริหารจัดการระบบ (Admin Domain), โมดูลระบบประปา (Tabwater), โมดูลธนาคารขยะและขยะทั่วไป (KeptKaya), โมดูลขยะอินทรีย์และอาหาร (FoodWaste), และโมดูลคลังพัสดุ (Inventory Domain)

ระหว่างการทดสอบ หากพบข้อบกพร่อง (Runtime Errors, Database Mismatches, หรือ Template View Issues) ได้ดำเนินการแก้ไขและทดสอบซ้ำจนกระทั่งทุกหน้าแสดงผลได้ถูกต้อง 100% (HTTP Status 200 OK)

---

## 2. รายการข้อบกพร่องที่พบและแก้ไขระหว่างทดสอบ (Issues Discovered & Resolved)

| # | ตำแหน่งที่พบ | สาเหตุของปัญหา (Root Cause) | การแก้ไข (Solution) |
|---|---|---|---|
| 1 | `resources/views/layouts/super-admin.blade.php` | การ Render หน้าเลือกเทศบาลแบบ Super Admin เกิด Render latency ทำให้ DOM หายบางช่วง | ปรับปรุง Puppeteer ให้รอ selector ตารางองค์กรก่อนกดยืนยัน และจัดโครงสร้าง layout ให้สมบูรณ์ |
| 2 | `app/Models/User.php` | เมธอดความสัมพันธ์ `wastePreference()` ขาดหายบน Model `User` ทำให้ฟังก์ชันร้านค้า/ขยะเรียก `$user->wastePreference` แล้วเกิด Error | เพิ่มความสัมพันธ์ `public function wastePreference() { return $this->hasOne(KpUserWastePreference::class, 'user_id', 'id'); }` พร้อม PHPDoc properties ครบถ้วน |
| 3 | `routes/web.php` (Line 501) | Middleware กลุ่มสวัสดิการ (`/admin/welfare/*`) กำหนด `role:Admin` ส่งผลให้ `Super Admin` โดนบล็อก (HTTP 403) | ปรับเป็น `role:Admin\|Super Admin` ให้ทั้ง Admin และ Super Admin เข้าถึงได้ |
| 4 | `app/Models/WelfarePayout.php` | Model มีการระบุ `$table = 'welfare_payouts'` ซึ่งชื่อตารางจริงใน Migration คือ `kp_welfare_payouts` ส่งผลให้เกิด Query Exception | แก้ไข `$table = 'kp_welfare_payouts'` ให้ตรงกับโครงสร้างฐานข้อมูล |
| 5 | Controllers หลายไฟล์ | การเข้าถึง `$user->kpUserPreferenceid` พิมพ์ผิด (Typo) | แก้ไขเป็น `$user->kpUserPreference?->id` ด้วย Nullsafe Operator |
| 6 | Database Seeder | ผู้ใช้ทดสอบ `food_staff` มีปัญหาเรื่องบทบาท `FoodWaste Staff` | ปรับปรุง `database/seeders/TestUsersSeeder.php` ให้สร้างและผูก Role อย่างถูกต้อง |

---

## 3. ดัชนีภาพ Screenshot แยกตามกลุ่มฟังก์ชัน (Screenshot Evidence Index)

### กลุ่มที่ 1: การยืนยันตัวตนและพอร์ทัลตามบทบาทผู้ใช้ (Authentication & Role Portals)
- [01_auth_login.png](./screenshots/01_auth_login.png) — หน้าจอเข้าสู่ระบบ (`/login`)
- [02_super_admin_select_org.png](./screenshots/02_super_admin_select_org.png) — หน้าจอ Super Admin เลือกเทศบาล/องค์กร (`/admin/select-organization`)
- [03_super_admin_accessmenu.png](./screenshots/03_super_admin_accessmenu.png) — เมนูหลักของ Super Admin (`/accessmenu`)
- [04_tabwater_staff_portal.png](./screenshots/04_tabwater_staff_portal.png) — พอร์ทัลเจ้าหน้าที่ประปา (`/staff_accessmenu`)
- [05_recycle_staff_portal.png](./screenshots/05_recycle_staff_portal.png) — พอร์ทัลเจ้าหน้าที่ธนาคารขยะ (`/accessmenu`)
- [06_foodwaste_staff_portal.png](./screenshots/06_foodwaste_staff_portal.png) — พอร์ทัลเจ้าหน้าที่ขยะอินทรีย์ (`/accessmenu`)
- [07_citizen_portal.png](./screenshots/07_citizen_portal.png) — พอร์ทัลประชาชนทั่วไป (`/accessmenu`)

### กลุ่มที่ 2: ระบบบริหารจัดการกลาง (Admin Management Domain)
- [08_admin_users_index.png](./screenshots/08_admin_users_index.png) — ตารางรายการผู้ใช้งานในระบบ (`/admin/users`)
- [09_admin_users_create.png](./screenshots/09_admin_users_create.png) — ฟอร์มเพิ่มผู้ใช้งานใหม่ (`/admin/users/create`)
- [10_admin_zones_index.png](./screenshots/10_admin_zones_index.png) — จัดการพื้นที่และโซน (`/admin/zone`)
- [11_admin_roles_index.png](./screenshots/11_admin_roles_index.png) — จัดการบทบาทผู้ใช้งาน (Roles Management) (`/admin/roles`)
- [12_admin_permissions_index.png](./screenshots/12_admin_permissions_index.png) — จัดการสิทธิ์การใช้งาน (Permissions) (`/admin/permissions`)
- [13_admin_welfare_dashboard.png](./screenshots/13_admin_welfare_dashboard.png) — แดชบอร์ดระบบสวัสดิการขยะ (`/admin/welfare/dashboard`)
- [14_admin_financial_report.png](./screenshots/14_admin_financial_report.png) — รายงานการเงินและค่าธรรมเนียมขยะ (`/admin/financial`)

### กลุ่มที่ 3: ระบบประปา (Tabwater Domain)
- [15_tabwater_twmanmobile.png](./screenshots/15_tabwater_twmanmobile.png) — ระบบจดมิเตอร์น้ำผ่านมือถือ พอร์ทัลแรกเข้า (`/twmanmobile`)
- [16_tabwater_twmanmobile_main.png](./screenshots/16_tabwater_twmanmobile_main.png) — หน้าหลักระบบจดมิเตอร์น้ำ (`/twmanmobile/main`)
- [17_tabwater_cutmeter_index.png](./screenshots/17_tabwater_cutmeter_index.png) — ระบบจัดการตัดมิเตอร์และระงับการใช้น้ำ (`/cutmeter`)
- [18_tabwater_invoice_period.png](./screenshots/18_tabwater_invoice_period.png) — จัดการรอบบิลและใบแจ้งหนี้ค่าน้ำ (`/admin/invoice_period`)
- [19_tabwater_stations_index.png](./screenshots/19_tabwater_stations_index.png) — ข้อมูลสถานีผลิตน้ำประปาและแผนที่ (`/tabwater/settings/stations`)
- [20_tabwater_pipelines_index.png](./screenshots/20_tabwater_pipelines_index.png) — ผังท่อและเส้นทางการจ่ายน้ำประปา (`/tabwater/settings/pipelines`)

### กลุ่มที่ 4: ระบบธนาคารขยะรีไซเคิลและขยะทั่วไป (KeptKaya Domain)
- [21_keptkaya_dashboard.png](./screenshots/21_keptkaya_dashboard.png) — แดชบอร์ดภาพรวมธนาคารขยะ (`/keptkayas/dashboard`)
- [22_keptkaya_members.png](./screenshots/22_keptkaya_members.png) — รายชื่อสมาชิกธนาคารขยะและยอดสะสม (`/keptkayas/recycle-bank/members`)
- [23_keptkaya_korkor3_report.png](./screenshots/23_keptkaya_korkor3_report.png) — รายงานแบบ กก.3 (สรุปปริมาณและมูลค่าขยะ) (`/keptkayas/korkor3`)
- [24_keptkaya_tbank_items.png](./screenshots/24_keptkaya_tbank_items.png) — จัดการประเภทสินค้าและประเภทขยะ (`/keptkayas/tbank/items`)
- [25_keptkaya_tbank_prices.png](./screenshots/25_keptkaya_tbank_prices.png) — กำหนดราคารับซื้อขยะรีไซเคิลประจำวัน (`/keptkayas/tbank/prices`)
- [26_keptkaya_tbank_units.png](./screenshots/26_keptkaya_tbank_units.png) — กำหนดหน่วยนับขยะรีไซเคิล (`/keptkayas/tbank/units`)
- [27_keptkaya_annual_payments.png](./screenshots/27_keptkaya_annual_payments.png) — รายการชำระค่าธรรมเนียมขยะรายปี (`/keptkayas/annual-payments`)

### กลุ่มที่ 5: ระบบขยะอินทรีย์และเศษอาหาร (FoodWaste Domain)
- [28_foodwaste_executive_dashboard.png](./screenshots/28_foodwaste_executive_dashboard.png) — แดชบอร์ดผู้บริหาร ระบบขยะอินทรีย์ (`/foodwaste/exec-dashboard`)
- [29_foodwaste_staff_dashboard.png](./screenshots/29_foodwaste_staff_dashboard.png) — แดชบอร์ดเจ้าหน้าที่บันทึกขยะอินทรีย์ (`/foodwaste/dashboard`)
- [30_foodwaste_admin_issues.png](./screenshots/30_foodwaste_admin_issues.png) — จัดการข้อร้องเรียนและปัญหาขยะ (`/foodwaste/admin/issues`)
- [31_foodwaste_admin_issue_types.png](./screenshots/31_foodwaste_admin_issue_types.png) — กำหนดประเภทปัญหาขยะอินทรีย์ (`/foodwaste/admin/issue-types`)
- [32_foodwaste_iotboxes.png](./screenshots/32_foodwaste_iotboxes.png) — ข้อมูลกล่อง IoT รับขยะอินทรีย์และสถานะเชื่อมต่อ (`/foodwaste/iotboxes`)
- [33_foodwaste_local_foods.png](./screenshots/33_foodwaste_local_foods.png) — ข้อมูลอาหารท้องถิ่นและปริมาณที่คาดการณ์ (`/foodwaste/admin/local-foods`)
- [34_foodwaste_members_waste.png](./screenshots/34_foodwaste_members_waste.png) — บันทึกประวัติการทิ้งขยะอินทรีย์ของสมาชิก (`/foodwaste/admin/members-waste`)

### กลุ่มที่ 6: ระบบคลังพัสดุและจัดซื้อจัดจ้าง (Inventory Domain)
- [35_inventory_dashboard.png](./screenshots/35_inventory_dashboard.png) — แดชบอร์ดภาพรวมคลังพัสดุ (`/inventory/dashboard`)
- [36_inventory_items.png](./screenshots/36_inventory_items.png) — บัญชีรายการพัสดุในคลัง (SKUs) (`/inventory/items/index`)
- [37_inventory_categories.png](./screenshots/37_inventory_categories.png) — จัดการหมวดหมู่พัสดุ (`/inventory/categories`)
- [38_inventory_locations.png](./screenshots/38_inventory_locations.png) — แผนผังจุดจัดเก็บพัสดุในคลัง (`/inventory/locations/index`)
- [39_inventory_suppliers.png](./screenshots/39_inventory_suppliers.png) — ทะเบียนคู่ค้าและผู้จัดจำหน่าย (Suppliers) (`/admin/suppliers`)

---

## 4. วิธีการสั่งรัน E2E Screenshot Capture ซ้ำ

หากต้องการรันการทดสอบและจับภาพหน้าจอใหม่ทั้งหมดในภายหลัง สามารถรันคำสั่งได้ทันที:

```bash
node scripts/run_all_e2e_capture.js
```
*(ระบบจะทำการเข้าสู่ระบบตาม Role และบันทึกภาพหน้าจอใหม่ลงในโฟลเดอร์ `docs/screenshots/` โดยอัตโนมัติ)*
