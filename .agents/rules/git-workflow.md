# Git & Branching Workflow Rule

- **Branch Creation:** ก่อนเริ่มพัฒนางานหรือแก้ไขฟีเจอร์ใดๆ ให้แตก branch ใหม่เสมอ (เช่น `feat/...`, `fix/...`)
- **Automatic Push & Merge Upon Completion:** หลังจากพัฒนางานและผ่านการทดสอบ (Verification) เสร็จสิ้น ให้ดำเนินการส่งมอบงานอัตโนมัติดังนี้:
  1. Stage และ Commit การเปลี่ยนแปลงทั้งหมดด้วยข้อความ commit ที่สื่อความหมาย
  2. Push branch ปัจจุบันขึ้นสู่ Remote Repository (`git push -u origin <branch>`)
  3. สลับกลับไปที่ branch หลัก (`git checkout main`)
  4. Merge branch ฟีเจอร์เข้าสู่ `main` (`git merge <branch>`)
  5. Push branch `main` ขึ้นสู่ Remote Repository (`git push origin main`) โดยอัตโนมัติ
