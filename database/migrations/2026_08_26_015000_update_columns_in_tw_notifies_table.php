<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up()
    {
        Schema::table('tw_notifies', function (Blueprint $table) {
            // 1. เปลี่ยน user_id ให้เป็น nullable (สำหรับผู้แจ้งที่ไม่ใช่สมาชิก)
            if (! Schema::hasColumn($table->getTable(), 'user_id')) {
                $table->unsignedBigInteger('user_id')->nullable()->change();
            }

            // 2. เพิ่มคอลัมน์ใหม่สำหรับเก็บข้อมูลผู้แจ้ง
            if (! Schema::hasColumn($table->getTable(), 'org_id_fk')) {
                $table->string('org_id_fk')->nullable()->after('user_id');
            }
            if (! Schema::hasColumn($table->getTable(), 'reporter_name')) {
                $table->string('reporter_name')->after('org_id_fk');
            }
            if (! Schema::hasColumn($table->getTable(), 'reporter_phone')) {
                $table->string('reporter_phone')->after('reporter_name');
            }

            // 3. ลบคอลัมน์ staff_id ออก (ถ้ามีอยู่ในตารางเดิม)
            if (Schema::hasColumn('tw_notifies', 'staff_id')) {
                $table->dropColumn('staff_id');
            }
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('tw_notifies', function (Blueprint $table) {
            $table->dropColumn(['org_id_fk', 'reporter_name', 'reporter_phone']);
            if (! Schema::hasColumn($table->getTable(), 'user_id')) {
                $table->unsignedBigInteger('user_id')->nullable(false)->change();
            }

            // ใส่คืนกรณี Rollback
            if (! Schema::hasColumn($table->getTable(), 'staff_id')) {
                $table->unsignedBigInteger('staff_id')->nullable();
            }
        });
    }
};
