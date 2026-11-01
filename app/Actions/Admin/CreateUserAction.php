<?php

namespace App\Actions\Admin;

use App\Models\Admin\Organization;
use App\Models\KeptKaya\KpUserWastePreference;
use App\Models\User;
use App\Services\UserService;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class CreateUserAction
{
    public function __construct(
        protected UserService $userService
    ) {}

    /**
     * @param  array<string, mixed>  $data
     */
    public function execute(array $data, ?int $orgId = null): User
    {
        return DB::transaction(function () use ($data, $orgId) {
            $effectiveOrgId = $orgId ?? Auth::user()?->org_id_fk;
            $org = $effectiveOrgId ? Organization::find($effectiveOrgId) : null;

            $user = User::create([
                'username' => $data['username'],
                'password' => Hash::make($data['password']),
                'prefix' => $data['prefix'] ?? 'นาย',
                'firstname' => $data['firstname'],
                'lastname' => $data['lastname'],
                'phone' => $data['phone'] ?? null,
                'id_card' => $data['id_card'] ?? null,
                'address' => $data['address'] ?? null,
                'zone_id' => $data['zone_id'],
                'subzone_id' => $data['subzone_id'],
                'tambon_code' => $org?->org_tambon_id_fk,
                'district_code' => $org?->org_district_id_fk,
                'province_code' => $org?->org_province_id_fk,
                'org_id_fk' => $effectiveOrgId,
                'status' => 'active',
            ]);

            $user->assignRole('User');

            $serviceData = [
                'recycle' => ! empty($data['svc_recycle']) ? '1' : '0',
                'food_waste' => ! empty($data['svc_food_waste']) ? '1' : '0',
                'annual_trash' => ! empty($data['svc_annual_trash']) ? '1' : '0',
            ];

            $this->userService->syncUserServices($user, $serviceData);

            KpUserWastePreference::firstOrCreate(
                ['user_id' => $user->id],
                [
                    'org_id' => $effectiveOrgId,
                    'zone_id' => $user->zone_id,
                    'subzone_id' => $user->subzone_id,
                    'is_annual_collection' => ! empty($data['svc_annual_trash']) ? 1 : 0,
                    'is_recycle_bank' => ! empty($data['svc_recycle']) ? 1 : 0,
                ]
            );

            return $user;
        });
    }
}
