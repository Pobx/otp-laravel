# Architectural Decision Record (ADR) Pattern Template

> **คำแนะนำสำหรับ AI Agent และผู้พัฒนา:**  
> ก่อนเขียนหรือแก้ไขเอกสาร ADR ใดๆ ในระบบ OTP 2025 **ต้องอ่านไฟล์นี้ก่อนเสมอ** และใช้โครงสร้างหัวข้อ (Headers) ตาม Pattern นี้อย่างเคร่งครัดโดยไม่มีข้อยกเว้น

---

## Pattern โครงสร้างเอกสาร ADR

```markdown
# ADR [NUMBER]: [ชื่อเรื่องการตัดสินใจเป็นภาษาไทยที่กระชับและชัดเจน]

## Status
[สถานะ เช่น Accepted, Proposed, Deprecated, Superseded] (วันที่ YYYY-MM-DD)

## Context
[อธิบายบริบท ที่มาของปัญหา ข้อจำกัด หรือความต้องการทางธุรกิจ/เทคโนโลยีที่นำไปสู่การตัดสินใจนี้ เช่น เฟรมเวิร์กเดิมขาดความสามารถ, ผู้ใช้งานอายุ 40+ ประสบปัญหาการใช้งาน, ปัญหา Performance หรือความปลอดภัย]

## Decision
[อธิบายรายละเอียดการตัดสินใจทางสถาปัตยกรรมอย่างชัดเจนและเป็นรูปธรรม ระบุเทคโนโลยี, มาตรฐาน, กฎเกณฑ์, ฟังก์ชัน หรือสถาปัตยกรรมที่นำมาใช้ทดแทนหรือแก้ไขปัญหา]

## Consequences
- **Positive:** [ผลเชิงบวกและประโยชน์ที่ระบบ, ทีมพัฒนา หรือผู้ใช้งานจะได้รับ]
- **Negative:** [ผลกระทบเชิงลบ, ข้อจำกัด, Overhead, หรือภาระงานที่ทีมต้องดูแลเพิ่มขึ้น]
- **Constraints (สำหรับ AI Agent):** [ข้อห้าม กฎเหล็ก และข้อพึงระวังเชิงเทคนิคที่ AI Agent และนักพัฒนาต้องปฏิบัติตามอย่างเคร่งครัดในการเขียนโค้ด]
```

---

## ตัวอย่างการใช้งานจริง (Reference Example)

```markdown
# ADR 0001: การจัดการ Database Transaction ใน Go Hexagonal

## Status
Accepted (วันที่ 2026-10-31)

## Context
ระบบพัฒนาด้วยโครงสร้าง Hexagonal Architecture แต่เดิม Echo Framework ไม่ได้จัดการเรื่อง Database Transaction ให้ตั้งแต่เริ่มต้น ทำให้ Use Case แต่ละตัวต้องจัดการ transaction เอง เกิดโค้ดซ้ำซ้อนและเสี่ยงต่อการเกิด dirty reads หรือ data inconsistency

## Decision
เราจะใช้ Middleware ฝัง database transaction ลงใน `context.Context` ของทุก HTTP Request ที่เป็น Method POST/PUT/DELETE และให้ Unit of Work ดึง transaction ไปใช้โดยอัตโนมัติ

## Consequences
- **Positive:** Business logic (Use Case) ไม่ต้องผูกติดกับ library ของ database และโค้ดมีความเป็นอิสระ
- **Negative:** ต้องระวังการ mock `context` ในตอนเขียน Unit Test
- **Constraints (สำหรับ AI Agent):** ห้ามเรียกใช้ `sql.DB` หรือ `pgxpool` โดยตรงในระดับ Use Case เด็ดขาด
```

---

## Checklist การตรวจสอบก่อน Commit ADR ใหม่
1. [ ] รหัส ADR ต้องเป็น 4 หลัก เช่น `ADR 0001`, `ADR 0002`, `ADR 0005`, `ADR 0006`
2. [ ] ชื่อไฟล์ต้องอยู่ในโฟลเดอร์ `docs/adr/` และตั้งชื่อเป็น `ADR-000X-[slug-in-english].md`
3. [ ] ต้องมีหัวข้อครบทั้ง 4 ส่วน: `## Status`, `## Context`, `## Decision`, `## Consequences`
4. [ ] ใน `## Consequences` ต้องมีครบทั้ง 3 bullet points:
   - `- **Positive:**`
   - `- **Negative:**`
   - `- **Constraints (สำหรับ AI Agent):`
5. [ ] ต้องอัปเดตสารบัญใน [`docs/adr/README.md`](README.md) ทุกครั้งที่มีการเพิ่ม ADR ใหม่
