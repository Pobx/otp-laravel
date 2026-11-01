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
        Schema::table('users', function (Blueprint $table) {
            //            if (!Schema::hasColumn($table->getTable(), 'org_id_fk')) {  $table->foreignId('org_id_fk')->constrained('organizations')
            //     ->after('id')->onDelete('cascade'); }

            if (! Schema::hasColumn($table->getTable(), 'zone_id')) {
                $table->foreignId('zone_id')->nullable()->after('lastname')->constrained('zones')->onDelete('cascade')->comment('หมู่หรือชุมชน แล้วแต่พื้นที่จะแยก');
            }

            if (! Schema::hasColumn($table->getTable(), 'subzone_id')) {
                $table->foreignId('subzone_id')->nullable()->after('lastname')->constrained('subzones')->onDelete('cascade');
            }

            if (! Schema::hasColumn($table->getTable(), 'tambon_code')) {
                $table->foreignId('tambon_code')->nullable()->after('lastname')->constrained('tambons')->onDelete('cascade');
            }
            if (! Schema::hasColumn($table->getTable(), 'district_code')) {
                $table->foreignId('district_code')->nullable()->after('lastname')->constrained('districts')->onDelete('cascade');
            }
            if (! Schema::hasColumn($table->getTable(), 'province_code')) {
                $table->foreignId('province_code')->nullable()->after('lastname')->constrained('provinces')->onDelete('cascade');
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
        Schema::table('users', function (Blueprint $table) {
            // $table->dropForeign(['org_id_fk']);
            // $table->dropColumn('org_id_fk');

            $table->dropForeign(['zone_id']);
            $table->dropColumn('zone_id');

            $table->dropForeign(['subzone_id']);
            $table->dropColumn('subzone_id');

            $table->dropForeign(['tambon_code']);
            $table->dropColumn('tambon_code');
            $table->dropForeign(['district_code']);
            $table->dropColumn('district_code');
            $table->dropForeign(['province_code']);
            $table->dropColumn('province_code');
        });
    }
};
