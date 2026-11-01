<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('foodwaste_waste_logs', function (Blueprint $table) {
            // ข้อมูลจากชาวบ้าน (Estimated)
            if (! Schema::hasColumn($table->getTable(), 'estimated_weight')) {
                $table->decimal('estimated_weight', 8, 2);
            }

            // ข้อมูลจากเจ้าหน้าที่/IoT (Verified)
            if (! Schema::hasColumn($table->getTable(), 'actual_moisture_avg')) {
                $table->decimal('actual_moisture_avg', 5, 2)->nullable();
            } // ค่าเฉลี่ยจากจุ่ม 3 จุด
            if (! Schema::hasColumn($table->getTable(), 'verified_dry_weight')) {
                $table->decimal('verified_dry_weight', 8, 2)->nullable();
            } // น้ำหนักแห้งที่แท้จริง
            if (! Schema::hasColumn($table->getTable(), 'is_verified')) {
                $table->boolean('is_verified')->default(false);
            } // สถานะว่าเจ้าหน้าที่ตรวจสอบหรือยัง
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        //
    }
};
