# ADR 0002: การอัปเกรดความเสถียรของเฟรมเวิร์ก Laravel และการบังคับใช้ Static Analysis ด้วย PHPStan Level 5

## Status
Accepted (วันที่ 2026-10-31)

## Context
โค้ดเบสเดิมของระบบมีปัญหาทางเทคนิคสะสมหลายประการ เช่น การใช้ฟังก์ชันหรือเมธอดที่ deprecated, type safety ที่หละหลวม, และไม่มีระบบตรวจสอบ Static Analysis ทำให้เกิดข้อผิดพลาดรันไทม์ (Runtime Exceptions) บ่อยครั้งระหว่างการใช้งานจริง

## Decision
กำหนดมาตรฐานคุณภาพโค้ดระดับสูงสำหรับระบบ OTP 2025:
1. อัปเกรด Laravel สู่เวอร์ชันที่ทันสมัยและปลอดภัย รองรับ PHP 8.3
2. ติดตั้งและบังคับใช้ **PHPStan ระดับ Level 5** เป็น Quality Gate ของโปรเจกต์ โค้ดทั้งหมดต้องผ่านการตรวจสอบแบบ 0 errors
3. บังคับใช้ **Laravel Pint** ในการจัดฟอร์แมตโค้ด PHP ให้เป็นไปตามมาตรฐาน PSR-12/Laravel Style อย่างสม่ำเสมอ
4. เขียนชุดทดสอบ Automated E2E & Feature Tests ครอบคลุม 6 โดเมนหลักของระบบ โดยต้องผ่าน 100% เสมอ

## Consequences
- **Positive:** ระบบมีความเสถียรสูงมาก ป้องกันข้อผิดพลาดประเภท TypeError, NullPointerException, และ Undefined Method ได้ล่วงหน้าก่อนนำขึ้น Production
- **Negative:** ใช้เวลาในการพัฒนาและ Refactor เพิ่มขึ้นเนื่องจากต้องระบุ Type Hint, Return Type และ PHPDoc อย่างเคร่งครัด
- **Constraints (สำหรับ AI Agent):**
  - ทุกการเปลี่ยนแปลงโค้ด PHP ต้องผ่านการรัน `./app.sh phpstan` โดยต้องมี **0 errors เสมอ**
  - ห้าม bypass หรือปิดกฎของ PHPStan โดยไม่จำเป็น
  - ต้องจัดฟอร์แมตโค้ดด้วย `./app.sh pint` ทุกครั้งก่อนส่งมอบงาน
  - ชุดทดสอบ `./app.sh test` ทั้ง 53 รายการต้องผ่านสมบูรณ์ 100% เสมอ
