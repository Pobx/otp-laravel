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
        Schema::table('inv_transactions', function (Blueprint $table) {
            // 1. สถานะ PENDING (ถ้ายังไม่มีฟิลด์บันทึกคนสร้าง สามารถเพิ่มตรงนี้ได้)
            //            if (!Schema::hasColumn($table->getTable(), 'requested_by')) {  $table->unsignedBigInteger('requested_by')->nullable()->after('user_id_fk'); }
            //            if (!Schema::hasColumn($table->getTable(), 'requested_at')) {  $table->timestamp('requested_at')->nullable(); }

            // 2. สถานะ APPROVED (อนุมัติ)
            if (! Schema::hasColumn('inv_transactions', 'approved_by')) {
                if (! Schema::hasColumn($table->getTable(), 'approved_by')) {
                    $table->unsignedBigInteger('approved_by')->nullable();
                }
                if (! Schema::hasColumn($table->getTable(), 'approved_at')) {
                    $table->timestamp('approved_at')->nullable();
                }
            }

            // 3. สถานะ REJECTED (ไม่อนุมัติ)
            if (! Schema::hasColumn($table->getTable(), 'rejected_by')) {
                $table->unsignedBigInteger('rejected_by')->nullable();
            }
            if (! Schema::hasColumn($table->getTable(), 'rejected_at')) {
                $table->timestamp('rejected_at')->nullable();
            }

            // 4. สถานะ CANCELED (ยกเลิก)
            if (! Schema::hasColumn($table->getTable(), 'canceled_by')) {
                $table->unsignedBigInteger('canceled_by')->nullable();
            }
            if (! Schema::hasColumn($table->getTable(), 'canceled_at')) {
                $table->timestamp('canceled_at')->nullable();
            }

            // 5. สถานะ DISPENSED (จ่ายพัสดุ / ตัดสต็อก)
            if (! Schema::hasColumn('inv_transactions', 'dispensed_by')) {
                if (! Schema::hasColumn($table->getTable(), 'dispensed_by')) {
                    $table->unsignedBigInteger('dispensed_by')->nullable();
                }
                if (! Schema::hasColumn($table->getTable(), 'dispensed_at')) {
                    $table->timestamp('dispensed_at')->nullable();
                }
            }

            // 6. สถานะ COMPLETED (ผู้ขอเบิกกดยืนยันรับของ)
            if (! Schema::hasColumn($table->getTable(), 'completed_by')) {
                $table->unsignedBigInteger('completed_by')->nullable();
            }
            if (! Schema::hasColumn($table->getTable(), 'completed_at')) {
                $table->timestamp('completed_at')->nullable();
            }

            // 7. สถานะ RETURNED (คืนพัสดุเข้าคลัง)
            if (! Schema::hasColumn($table->getTable(), 'returned_by')) {
                $table->unsignedBigInteger('returned_by')->nullable();
            }
            if (! Schema::hasColumn($table->getTable(), 'returned_at')) {
                $table->timestamp('returned_at')->nullable();
            }
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('inv_transactions', function (Blueprint $table) {
            $table->dropColumn([
                'approved_by', 'approved_at',
                'rejected_by', 'rejected_at',
                'canceled_by', 'canceled_at',
                'dispensed_by', 'dispensed_at',
                'completed_by', 'completed_at',
                'returned_by', 'returned_at',
            ]);
        });
    }
};
