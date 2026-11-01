# ADR 0001: การจัดสภาพแวดล้อมระบบและการพัฒนาด้วย Docker Container

## Status
Accepted (วันที่ 2026-10-31)

## Context
ระบบ OTP 2025 ในอดีตรันอยู่บนสภาพแวดล้อม Local Machine แบบกระจัดกระจาย ทำให้เกิดปัญหา "Works on my machine", เวอร์ชันของ PHP/Extensions ไม่ตรงกัน, และการติดตั้ง dependencies มีความซับซ้อนและเสี่ยงต่อการผิดพลาดระหว่างทีมพัฒนา

## Decision
กำหนดให้ระบบ OTP 2025 ทั้งหมดรันบน Docker Compose Container โดยแยก Services เป็น 3 ส่วนหลัก:
1. `app`: PHP 8.3-FPM พร้อม Extensions ครบถ้วน (pdo_mysql, gd, zip, intl, bcmath, redis)
2. `web`: Nginx Web Server ทำหน้าที่เป็น Reverse Proxy และจัดการ Static Assets
3. `db`: MySQL 8.0 สำหรับฐานข้อมูลหลัก พร้อมสคริปต์ `./app.sh` ในการรันคำสั่ง artisan, composer, npm และ testing ภายใน container โดยอัตโนมัติ

## Consequences
- **Positive:** สภาพแวดล้อมการพัฒนาและการทดสอบมีความเป็นเอกภาพ 100% สามารถ deploy หรือ onboard นักพัฒนาใหม่ได้ในคำสั่งเดียวผ่าน `./app.sh up -d`
- **Negative:** ใช้ทรัพยากรเครื่องเพิ่มขึ้นเล็กน้อย และต้องเรียกใช้คำสั่งผ่าน wrapper `./app.sh` แทนการเรียกคำสั่งตรงใน Host Machine
- **Constraints (สำหรับ AI Agent):**
  - ห้ามสั่งรัน `php artisan`, `composer`, `npm`, หรือเครื่องมือเทสท์บนเครื่อง Host โดยตรงเด็ดขาด ต้องรันผ่าน `./app.sh [command]` เสมอ
  - ห้ามแก้ไขการตั้งค่าพอร์ตและพาธของ Docker Compose โดยไม่ได้รับความยินยอมจากหัวหน้าทีมสถาปัตยกรรม
