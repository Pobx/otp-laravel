<?php

namespace App\Http\Controllers\FoodWaste;

use App\Http\Controllers\Controller;

class RecycleWasteStaffController extends Controller
{
    public function index()
    {
        return view('foodwaste.staffs.mobile.recycle.index');
    }
}
