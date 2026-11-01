<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Models\Admin\Organization;
use App\Models\User;
use Illuminate\Auth\Events\Registered;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\Rules;
use Illuminate\Validation\ValidationException;
use Illuminate\View\View;

class RegisteredUserController extends Controller
{
    /**
     * Display the registration view.
     *
     * @return View
     */
    public function create()
    {
        $organizations = Organization::all();

        return view('auth.register', compact('organizations'));
    }

    /**
     * Handle an incoming registration request.
     *
     * @return RedirectResponse
     *
     * @throws ValidationException
     */
    public function store(Request $request)
    {
        $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'email' => ['required', 'string', 'email', 'max:255', 'unique:users'],
            'password' => ['required', 'confirmed', Rules\Password::defaults()],
        ]);

        $user = User::create([
            'username' => $request->name,
            'firstname' => $request->name,
            'lastname' => '',
            'email' => $request->email,
            'password' => Hash::make($request->password),
            'id_card' => '1111111111111',
            'phone' => '0999999999',
            'gender' => 'm',
            'address' => 'x',
            'zone_id' => null,
            'subzone_id' => null,
            'tambon_code' => null,
            'district_code' => null,
            'province_code' => null,
        ]);

        event(new Registered($user));

        Auth::login($user);

        return redirect('/accessmenu');
    }
}
