# ADR 0004: การย้ายโครงสร้าง UI ทั้งระบบสู่ AdminLTE 4 และ Bootstrap 5.3

## Status
Accepted (วันที่ 2026-11-01)

## Context
ระบบเดิมใช้เทมเพลตและ CSS ผสมผสานหลายเวอร์ชัน ทั้ง AdminLTE 2/3 เดิม, สคริปต์สไตล์เก่า และบางส่วนพยายามใช้ Tailwind CSS ทำให้เกิดปัญหา CSS Conflict, ไฟล์ asset มีขนาดใหญ่, สไตล์ปุ่มและฟอร์มไม่สม่ำเสมอ, และยากต่อการบำรุงรักษาในระยะยาว

## Decision
ตัดสินใจ Migrate โครงสร้าง UI ทั้งหมดสู่แพ็กเกจทางการ **`colorlibhq/adminlte-laravel` (AdminLTE 4) ร่วมกับ Bootstrap 5.3 และ Vite Asset Bundler**:
1. ใช้ Layout หลัก `adminlte::page` และถอด Legacy CSS Layouts เดิมออกทั้งหมด
2. คอมไพล์ CSS/JS ผ่าน Vite (`resources/css/adminlte.css`, `resources/js/adminlte.js`) เพื่อประสิทธิภาพสูงสุดและขนาด bundle ที่กะทัดรัด
3. ตกแต่งครอบทับด้วย Custom Senior-White Theme เพื่อให้สอดคล้องกับ ADR 0003
4. รองรับ Responsive Viewport ทั้งระดับ Desktop (1440px), Tablet (768px), และ Mobile (390px)

## Consequences
- **Positive:** โครงสร้าง UI ทั่วทั้งระบบกลายเป็นมาตรฐานเดียวกัน มีคอมโพเนนต์ Bootstrap 5.3 ที่เสถียร รองรับอุปกรณ์มือถือและแท็บเล็ตได้สมบูรณ์ และตัด dependencies ที่ซ้ำซ้อนออกไป
- **Negative:** ต้องเขียนปรับแต่ง Blade Views หลายหน้าเพื่อแปลงคลาสจาก AdminLTE รุ่นเก่าหรือ Tailwind มาเป็น Bootstrap 5 Grid & Utility Classes
- **Constraints (สำหรับ AI Agent):**
  - หน้าจอ Admin และพอร์ทัลหลักทั้งหมดต้องสืบทอดจาก `@extends('adminlte::page')` หรือ `@extends('layouts.super-admin')` เท่านั้น
  - ห้ามติดตั้งหรือผสมผสาน CSS Framework อื่น (เช่น Tailwind) เข้ามาในส่วนที่ใช้ Bootstrap 5.3 เพื่อป้องกัน Style Collision
  - ทุกการเปลี่ยนแปลง CSS/JS ใน `resources/` ต้องผ่านการรันคอมไพล์ `npm run build` เสมอ
