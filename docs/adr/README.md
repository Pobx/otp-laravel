# Architecture Decision Records (ADR) - OTP 2025

> [!IMPORTANT]
> **กฎเหล็กสำหรับ AI Agent และนักพัฒนา:**  
> ก่อนเขียนหรือแก้ไขเอกสาร ADR ใดๆ **ต้องอ่านไฟล์โครงสร้างจาก [`docs/adr/ADR_PATTERN.md`](ADR_PATTERN.md) ก่อนเสมอ** และปฏิบัติตาม Pattern อย่างเคร่งครัด

---

## รูปแบบโครงสร้าง (Standard Pattern)
ทุกเอกสาร ADR ในโฟลเดอร์นี้ ต้องใช้รูปแบบมาตรฐานตาม [`ADR_PATTERN.md`](ADR_PATTERN.md):
- `# ADR [ID]: [Title]`
- `## Status`
- `## Context`
- `## Decision`
- `## Consequences` (`Positive`, `Negative`, `Constraints (สำหรับ AI Agent)`)

---

## สารบัญ ADR ทั้งหมด

| รหัส ADR | ชื่อเรื่อง (Title) | สถานะ (Status) | วันที่บันทึก | เอกสาร |
| :--- | :--- | :---: | :---: | :--- |
| **ADR 0001** | การจัดสภาพแวดล้อมระบบและการพัฒนาด้วย Docker Container | `Accepted` | 2026-10-31 | [`ADR-0001-containerization-docker-environment.md`](ADR-0001-containerization-docker-environment.md) |
| **ADR 0002** | การอัปเกรดความเสถียรของเฟรมเวิร์ก Laravel และการบังคับใช้ Static Analysis ด้วย PHPStan Level 5 | `Accepted` | 2026-10-31 | [`ADR-0002-laravel-modernization-phpstan-strictness.md`](ADR-0002-laravel-modernization-phpstan-strictness.md) |
| **ADR 0003** | การออกแบบระบบ UI/UX สไตล์ Senior-Friendly โทนสีขาวสบสายตาสำหรับผู้ใช้งานอายุ 40+ ปี | `Accepted` | 2026-11-01 | [`ADR-0003-ui-ux-senior-friendly-white-theme.md`](ADR-0003-ui-ux-senior-friendly-white-theme.md) |
| **ADR 0004** | การย้ายโครงสร้าง UI ทั้งระบบสู่ AdminLTE 4 และ Bootstrap 5.3 | `Accepted` | 2026-11-01 | [`ADR-0004-adminlte4-bootstrap5-migration.md`](ADR-0004-adminlte4-bootstrap5-migration.md) |
| **ADR 0005** | มาตรฐาน Form, Data Table, Thai DatePicker, Client Validation และการจัดการ Error ให้เป็นมิตรกับผู้ใช้งาน | `Accepted` | 2026-11-01 | [`ADR-0005-ui-form-table-validation-error-standards.md`](ADR-0005-ui-form-table-validation-error-standards.md) |
