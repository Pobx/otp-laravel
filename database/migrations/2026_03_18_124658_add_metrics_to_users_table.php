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
        Schema::table('users', function (Blueprint $table) {
            // เพิ่มคอลัมน์ โดยตั้งค่าเป็น nullable เพื่อไม่ให้กระทบ User เก่าที่ยังไม่กรอก
            if (! Schema::hasColumn($table->getTable(), 'age')) {
                $table->integer('age')->default(0)->after('email');
            }
            if (! Schema::hasColumn($table->getTable(), 'weight')) {
                $table->float('weight')->default(0)->after('age');
            }
            if (! Schema::hasColumn($table->getTable(), 'height')) {
                $table->float('height')->default(0)->after('weight');
            }
        });
    }

    public function down()
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn(['age', 'weight', 'height']);
        });
    }
};
