<?php

namespace App\Listeners;

use App\Services\Navigation\RoleMenuService;
use ColorlibHQ\AdminLte\Events\BuildingMenu;
use Illuminate\Support\Facades\Auth;

class BuildRoleSidebarMenu
{
    protected RoleMenuService $roleMenuService;

    public function __construct(RoleMenuService $roleMenuService)
    {
        $this->roleMenuService = $roleMenuService;
    }

    /**
     * Handle the BuildingMenu event by dynamically injecting role-based menu items.
     */
    public function handle(BuildingMenu $event): void
    {
        $user = Auth::user();
        $menuItems = $this->roleMenuService->getMenuForUser($user);

        foreach ($menuItems as $item) {
            $event->menu->add($item);
        }
    }
}
