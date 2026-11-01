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
        if (! Schema::hasTable('undertaker_subzones')) {
            Schema::create('undertaker_subzones', function (Blueprint $table) {
                $table->bigIncrements('id');
                $table->unsignedBigInteger('org_id_fk')->nullable();
                $table->unsignedBigInteger('twman_id')->nullable();
                $table->foreignId('subzone_id')->constrained('subzones')->onDelete('cascade');

                $table->timestamps();
            });
        }

    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('undertaker_subzones');
    }
};
