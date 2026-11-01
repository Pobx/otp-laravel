<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('kp_welfare_configs', function (Blueprint $table) {
            if (! Schema::hasColumn('kp_welfare_configs', 'workflow_id')) {
                if (! Schema::hasColumn($table->getTable(), 'workflow_id')) {
                    $table->foreignId('workflow_id')->nullable()->constrained('approval_workflows')->onDelete('set null');
                }
            }
            if (! Schema::hasColumn('kp_welfare_configs', 'contribution_fee_per_case')) {
                if (! Schema::hasColumn($table->getTable(), 'contribution_fee_per_case')) {
                    $table->decimal('contribution_fee_per_case', 10, 2)->default(60.00);
                }
            }
        });

        Schema::table('kp_welfare_payouts', function (Blueprint $table) {
            if (! Schema::hasColumn('kp_welfare_payouts', 'current_step_id')) {
                if (! Schema::hasColumn($table->getTable(), 'current_step_id')) {
                    $table->foreignId('current_step_id')->nullable()->constrained('approval_workflow_steps')->onDelete('set null');
                }
            }
        });
    }

    public function down(): void
    {
        Schema::table('kp_welfare_configs', function (Blueprint $table) {
            $table->dropColumn(['workflow_id', 'contribution_fee_per_case']);
        });
        Schema::table('kp_welfare_payouts', function (Blueprint $table) {
            $table->dropColumn('current_step_id');
        });
    }
};
