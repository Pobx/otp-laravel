<?php

namespace App\Services\Navigation;

use ColorlibHQ\AdminLte\Menu\Filters\FilterInterface;
use Illuminate\Support\Facades\Auth;

class RoleMenuFilter implements FilterInterface
{
    /**
     * Transforms a menu item, restricting it if the authenticated user lacks the required role.
     *
     * @param  array<string, mixed>  $item
     * @return array<string, mixed>
     */
    public function transform($item)
    {
        if (isset($item['role'])) {
            $roles = is_array($item['role']) ? $item['role'] : explode('|', (string) $item['role']);
            if (! $this->userHasAnyRole($roles)) {
                $item['restricted'] = true;
            }
        }

        if (isset($item['roles'])) {
            $roles = is_array($item['roles']) ? $item['roles'] : explode('|', (string) $item['roles']);
            if (! $this->userHasAnyRole($roles)) {
                $item['restricted'] = true;
            }
        }

        return $item;
    }

    /**
     * Check if the currently authenticated user possesses any of the provided roles.
     *
     * @param  array<int, string>  $roles
     */
    protected function userHasAnyRole(array $roles): bool
    {
        $user = Auth::user();
        if (! $user) {
            return false;
        }

        if (method_exists($user, 'hasAnyRole')) {
            return $user->hasAnyRole($roles);
        }

        if (method_exists($user, 'hasRole')) {
            foreach ($roles as $role) {
                if ($user->hasRole($role)) {
                    return true;
                }
            }
        }

        return false;
    }
}
