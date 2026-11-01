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
        if (! Schema::hasTable('inv_units')) {
            Schema::create('inv_units', function (Blueprint $table) {
                $table->id();

                // 1. สร้างคอลัมน์เก็บ ID
                $table->unsignedBigInteger('org_id_fk');

                // 2. กำหนดให้เป็น Foreign Key เชื่อมไปยังตาราง organizations
                $table->foreign('org_id_fk')
                    ->references('id')
                    ->on('organizations')
                    ->onDelete('cascade'); // 👈 สำคัญ: ถ้าลบ Org ทิ้ง -> Unit ของ Org นั้นจะหายไปด้วย

                $table->string('name');
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
        Schema::dropIfExists('inv_units');
    }
};
