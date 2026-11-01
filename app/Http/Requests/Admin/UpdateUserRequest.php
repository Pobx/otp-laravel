<?php

namespace App\Http\Requests\Admin;

use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Foundation\Http\FormRequest;

class UpdateUserRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    /**
     * @return array<string, ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        $userId = $this->route('user_id') ?? $this->route('user') ?? $this->route('id');

        return [
            'username' => 'required|string|max:255|unique:users,username,'.$userId,
            'firstname' => 'required|string|max:255',
            'lastname' => 'required|string|max:255',
            'phone' => 'nullable|string|max:20|unique:users,phone,'.$userId,
            'id_card' => 'nullable|string|max:13|unique:users,id_card,'.$userId,
            'password' => 'nullable|min:6',
            'zone_id' => 'required',
            'subzone_id' => 'required',
            'prefix' => 'nullable|string|max:50',
            'address' => 'nullable|string',
            'svc_recycle' => 'nullable',
            'svc_food_waste' => 'nullable',
            'svc_annual_trash' => 'nullable',
        ];
    }

    /**
     * @return array<string, string>
     */
    public function messages(): array
    {
        return [
            'required' => 'กรุณากรอกข้อมูลในช่อง :attribute',
            'unique' => ':attribute นี้ถูกใช้งานแล้ว',
            'min' => ':attribute ต้องมีความยาวอย่างน้อย :min ตัวอักษร',
        ];
    }
}
