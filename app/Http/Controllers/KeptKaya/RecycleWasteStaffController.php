<?php

namespace App\Http\Controllers\KeptKaya;

use App\Http\Controllers\Controller;

class RecycleWasteStaffController extends Controller
{
    public function index()
    {
        return view('keptkayas.staffs.mobile.recycle.index');
    }
}
