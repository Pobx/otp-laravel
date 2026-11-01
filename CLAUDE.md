# Agent Rules for OTP 2025

1. **Autonomous File Editing (แก้ไขไฟล์โดยอัตโนมัติ):**
   - AI Agent สามารถสร้าง แก้ไข ดัดแปลง หรือจัดโครงสร้างไฟล์ในโปรเจกต์ได้โดยตรงทันทีโดยไม่ต้องถามขอความยินยอม (Accept/Confirm) การเปลี่ยนแปลงจากผู้ใช้ซ้ำซ้อน
   - ดำเนินการแก้ไขไฟล์และบันทึกผลได้ทันที

2. **Git & Branching Workflow (กฎการส่งมอบงานอัตโนมัติ):**
   - แตก branch ใหม่เสมอ (เช่น `feat/...`, `fix/...`) ก่อนเริ่มพัฒนางานหรือแก้ไขฟีเจอร์ใดๆ
   - เมื่อพัฒนาและผ่านการทดสอบเสร็จสมบูรณ์แล้ว ให้ AI Agent ทำการ Commit, Push branch ขึ้นสู่ Remote Repository, Merge เข้าสู่ `main`, และ Push `main` ทันทีโดยไม่ต้องรอถามผู้ใช้ซ้ำ

3. **Docker & Environment Execution:**
   - ทุกคำสั่ง `php artisan`, `composer`, `npm`, `phpunit` ต้องรันผ่าน `./app.sh [command]` ห้ามรันตรงบน Host Machine

4. **UI/UX Standards:**
   - มาตรฐาน Senior-Friendly (อายุ 40+ ปี): พื้นหลังขาวสบายตา (`#FFFFFF`/`#F8FAFC`), Touch Target ขั้นต่ำ 44px–48px, และ Contrast สูงตามมาตรฐาน WCAG
   - ฟอร์มทุกตัวต้องมี `novalidate` และแสดงผลวันที่เป็นปี พ.ศ. เสมอ (จัดเก็บเป็น ค.ศ. `YYYY-MM-DD`)
   - ตารางขนาดใหญ่ต้องใช้ DataTables แบบ Server-Side Ajax (`serverSide: true`) เสมอ
