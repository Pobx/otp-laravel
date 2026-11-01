# Agent Guidelines for OTP 2025

## 1. Architectural Decision Records (ADR)
- **Mandatory Pattern Reading:** ก่อนเขียนหรือแก้ไขเอกสาร ADR ใดๆ ในโฟลเดอร์ `docs/adr/` AI Agent **ต้องอ่าน [`docs/adr/ADR_PATTERN.md`](docs/adr/ADR_PATTERN.md) ก่อนเสมอ**
- **Strict Pattern:** ทุกเอกสาร ADR ต้องประกอบด้วย 4 ส่วน:
  1. `# ADR [NUMBER]: [Title]` (หมายเลข 4 หลัก เช่น `ADR 0001`, `ADR 0005`, `ADR 0006`)
  2. `## Status` ระบุสถานะและวันที่ เช่น `Accepted (วันที่ YYYY-MM-DD)`
  3. `## Context` อธิบายบริบทและปัญหา
  4. `## Decision` อธิบายรายละเอียดการตัดสินใจทางสถาปัตยกรรม
  5. `## Consequences` ต้องมีครบทั้ง 3 ข้อย่อย:
     - `- **Positive:**`
     - `- **Negative:**`
     - `- **Constraints (สำหรับ AI Agent):`
- **Catalog Update:** เมื่อเพิ่ม ADR ใหม่ ต้องอัปเดตสารบัญใน [`docs/adr/README.md`](docs/adr/README.md) ทุกครั้ง

## 2. Docker & Environment Execution
- ทุกคำสั่ง `php artisan`, `composer`, `npm`, `phpunit` ต้องรันผ่าน `./app.sh [command]` ห้ามรันตรงบน Host Machine

## 3. UI/UX Standards
- รักษามาตรฐาน Senior-Friendly (อายุ 40+ ปี): พื้นหลังขาวสบายตา (`#FFFFFF`/`#F8FAFC`), Touch Target ขั้นต่ำ 44px–48px, และ Contrast สูงตามมาตรฐาน WCAG
- ฟอร์มทุกตัวต้องมี `novalidate` และแสดงผลวันที่เป็นปี พ.ศ. เสมอ (จัดเก็บเป็น ค.ศ. `YYYY-MM-DD`)
- ตารางขนาดใหญ่ต้องใช้ DataTables แบบ Server-Side Ajax (`serverSide: true`) เสมอ

## 4. Git & Branching Workflow (กฎการส่งมอบงานอัตโนมัติ)
- **แตก Branch เสมอ:** ก่อนเริ่มพัฒนางานหรือแก้ไขฟีเจอร์ใดๆ ให้แตก branch ใหม่เสมอ (เช่น `feat/...`, `fix/...`)
- **Push & Merge อัตโนมัติทันทีหลังเสร็จสิ้น:** หลังจากพัฒนางานและผ่านการทดสอบ (Verification) เสร็จสมบูรณ์แล้ว ให้ AI Agent ทำการ:
  1. Commit การเปลี่ยนแปลงทั้งหมด
  2. Push branch ขึ้นสู่ Remote Repository (`git push -u origin <branch>`)
  3. สลับกลับไปที่ branch หลัก (`git checkout main`) และ Merge branch ฟีเจอร์เข้าสู่ `main` (`git merge <branch>`)
  4. Push branch `main` ขึ้นสู่ Remote Repository (`git push origin main`) ทันทีโดยไม่ต้องรอถามผู้ใช้ซ้ำ

## 5. Autonomous File Editing (การแก้ไขไฟล์โดยอัตโนมัติ)
- **แก้ไขไฟล์ได้ทันที:** AI Agent สามารถสร้าง แก้ไข ดัดแปลง หรือจัดโครงสร้างไฟล์ในโปรเจกต์ได้โดยตรงทันทีโดยไม่ต้องถามขอความยินยอม (Accept/Confirm) การเปลี่ยนแปลงจากผู้ใช้ซ้ำซ้อน ให้ตัดสินใจและลงมือดำเนินการเพื่อความต่อเนื่องและรวดเร็ว


