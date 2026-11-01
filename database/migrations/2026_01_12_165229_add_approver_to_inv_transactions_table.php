<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::table('inv_transactions', function (Blueprint $table) {
            if (! Schema::hasColumn($table->getTable(), 'requester_name')) {
                $table->string('requester_name')->after('requester_id_fk')->nullable();
            }
            if (! Schema::hasColumn($table->getTable(), 'approver_name')) {
                $table->string('approver_name')->after('requester_name')->nullable();
            }
        });
    }

    public function down()
    {
        Schema::table('inv_transactions', function (Blueprint $table) {
            $table->dropColumn(['requester_name', 'approver_name']);
        });
    }
};
