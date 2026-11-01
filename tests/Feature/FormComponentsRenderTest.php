<?php

namespace Tests\Feature;

use Illuminate\Support\Facades\Blade;
use Tests\TestCase;

class FormComponentsRenderTest extends TestCase
{
    /**
     * Test x-form.card component rendering.
     */
    public function test_form_card_renders_title_and_slot(): void
    {
        $rendered = Blade::render('<x-form.card title="ข้อมูลผู้ใช้น้ำ">เนื้อหาแบบฟอร์ม</x-form.card>');

        $this->assertStringContainsString('ข้อมูลผู้ใช้น้ำ', $rendered);
        $this->assertStringContainsString('เนื้อหาแบบฟอร์ม', $rendered);
        $this->assertStringContainsString('senior-card', $rendered);
    }

    /**
     * Test x-form.input component rendering.
     */
    public function test_form_input_renders_with_label_and_senior_height(): void
    {
        $rendered = Blade::render('<x-form.input name="test_field" label="ชื่อสมาชิก" :required="true" />');

        $this->assertStringContainsString('ชื่อสมาชิก', $rendered);
        $this->assertStringContainsString('name="test_field"', $rendered);
        $this->assertStringContainsString('min-height: 50px', $rendered);
        $this->assertStringContainsString('required', $rendered);
    }

    /**
     * Test x-form.thai-date component rendering and dual-binding hidden input.
     */
    public function test_form_thai_date_renders_display_and_hidden_iso_inputs(): void
    {
        $rendered = Blade::render('<x-form.thai-date name="event_date" label="วันเริ่มสัญญา" value="2026-11-05" />');

        $this->assertStringContainsString('วันเริ่มสัญญา', $rendered);
        // Hidden input storing ISO-8601
        $this->assertStringContainsString('type="hidden"', $rendered);
        $this->assertStringContainsString('name="event_date"', $rendered);
        $this->assertStringContainsString('value="2026-11-05"', $rendered);
        // Visible Thai Buddhist Era input
        $this->assertStringContainsString('data-thai-datepicker', $rendered);
        $this->assertStringContainsString('value="05/11/2569"', $rendered);
        $this->assertStringContainsString('พ.ศ.', $rendered);
    }

    /**
     * Test x-form.action-bar component rendering.
     */
    public function test_form_action_bar_renders_cancel_and_submit_buttons(): void
    {
        $rendered = Blade::render('<x-form.action-bar cancelText="ย้อนกลับ" submitText="บันทึกข้อมูล" />');

        $this->assertStringContainsString('ย้อนกลับ', $rendered);
        $this->assertStringContainsString('บันทึกข้อมูล', $rendered);
        $this->assertStringContainsString('senior-action-bar', $rendered);
    }
}
