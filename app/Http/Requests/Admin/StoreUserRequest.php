<?php

namespace App\Http\Requests\Admin;

use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Foundation\Http\FormRequest;

class StoreUserRequest extends FormRequest
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
        return [
            'username' => 'required|string|max:255|unique:users,username',
            'password' => 'required|string|min:6',
            'firstname' => 'required|string|max:255',
            'lastname' => 'required|string|max:255',
            'phone' => 'nullable|string|max:20',
            'id_card' => 'nullable|string|max:13|unique:users,id_card',
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
            'unique' => ':attribute นี้มีอยู่ในระบบแล้ว',
            'min' => ':attribute ต้องมีความยาวอย่างน้อย :min ตัวอักษร',
        ];
    }

    /**
     * @return array<string, string>
     */
    public function attributes(): array
    {
        return [
            'username' => 'ชื่อผู้ใช้งาน',
            'password' => 'รหัสผ่าน',
            'firstname' => 'ชื่อจริง',
            'lastname' => 'นามสกุล',
            'phone' => 'เบอร์โทรศัพท์',
            'id_card' => 'เลขบัตรประชาชน',
            'zone_id' => 'โซน',
            'subzone_id' => 'ซอย/ชุมชนย่อย',
        ];
    }
}
