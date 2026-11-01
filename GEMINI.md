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
