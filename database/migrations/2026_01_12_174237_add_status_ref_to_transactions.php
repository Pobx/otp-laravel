<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('inv_transactions', function (Blueprint $table) {
            if (! Schema::hasColumn($table->getTable(), 'ref_no')) {
                $table->string('ref_no')->nullable()->after('id');
            } // เลขที่ใบเบิก
            // status เรามีแล้ว (แต่จะเปลี่ยน Logic การใช้)
            if (! Schema::hasColumn($table->getTable(), 'approved_at')) {
                $table->timestamp('approved_at')->nullable();
            } // วันที่อนุมัติ
            if (! Schema::hasColumn($table->getTable(), 'approved_by')) {
                $table->unsignedBigInteger('approved_by')->nullable();
            } // ใครเป็นคนกดอนุมัติในระบบ
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('transactions', function (Blueprint $table) {
            //
        });
    }
};
