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
        Schema::table('kp_tbank_items_groups', function (Blueprint $table) {
            if (! Schema::hasColumn($table->getTable(), 'kp_items_group_code')) {
                $table->string('kp_items_group_code')->after('kp_items_groupname');
            }
            if (! Schema::hasColumn($table->getTable(), 'sequence_number')) {
                $table->integer('sequence_number')->default(1);
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
        Schema::table('kp_tbank_items_groups', function (Blueprint $table) {
            $table->dropColumn('kp_items_group_code');
            $table->dropColumn('sequence_num');
        });
    }
};
