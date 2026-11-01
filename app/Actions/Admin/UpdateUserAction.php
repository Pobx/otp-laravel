<?php

namespace App\Actions\Admin;

use App\Models\KeptKaya\KpUserWastePreference;
use App\Models\User;
use App\Services\UserService;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class UpdateUserAction
{
    public function __construct(
        protected UserService $userService
    ) {}

    /**
     * @param  array<string, mixed>  $data
     */
    public function execute(User $user, array $data): User
    {
        return DB::transaction(function () use ($user, $data) {
            $user->username = $data['username'];
            $user->prefix = $data['prefix'] ?? $user->prefix;
            $user->firstname = $data['firstname'];
            $user->lastname = $data['lastname'];
            $user->phone = $data['phone'] ?? $user->phone;
            $user->id_card = $data['id_card'] ?? $user->id_card;
            $user->address = $data['address'] ?? $user->address;
            $user->zone_id = $data['zone_id'];
            $user->subzone_id = $data['subzone_id'];

            if (! empty($data['password'])) {
                $user->password = Hash::make($data['password']);
            }
            $user->save();

            $serviceData = [
                'recycle' => ! empty($data['svc_recycle']) ? '1' : '0',
                'food_waste' => ! empty($data['svc_food_waste']) ? '1' : '0',
                'annual_trash' => ! empty($data['svc_annual_trash']) ? '1' : '0',
            ];

            $this->userService->syncUserServices($user, $serviceData);

            KpUserWastePreference::updateOrCreate(
                ['user_id' => $user->id],
                [
                    'org_id' => $user->org_id_fk,
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
