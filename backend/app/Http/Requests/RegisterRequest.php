<?php

namespace App\Http\Requests;

use App\Enums\Role;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Support\Facades\Log;

class RegisterRequest extends FormRequest
{
    public function authorize()
    {
        return $this->user()->role == Role::HEAD_OF_FINANCIAL_COMMITTEE;
    }

    public function rules()
    {
        return [
            'name' => 'required|string|max:255',
            'username' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'password' => 'required|string|min:8',
            'role' => 'required|string|max:255',
        ];
    }

    public function messages()
    {
        return [
            'name.required' => 'اسم طالب مطلوب',
            'name.string' => 'اسم الطالب يجب أن يكون نصًا',
            'name.max' => 'اسم الطالب يجب ألا يتجاوز 255 حرفًا',
            'name.required' => 'اسم المستخدم مطلوب',
            'name.string' => 'اسم المستخدم يجب أن يكون نصًا',
            'name.max' => 'اسم المستخدم يجب ألا يتجاوز 255 حرفًا',
            'email.required' => 'البريد الإلكتروني مطلوب',
            'email.string' => 'البريد الإلكتروني يجب أن يكون نصًا',
            'email.email' => 'البريد الإلكتروني يجب أن يكون بصيغة صحيحة',
            'email.max' => 'البريد الإلكتروني يجب ألا يتجاوز 255 حرفًا',
            'email.unique' => 'البريد الإلكتروني مستخدم بالفعل',
            'password.required' => 'كلمة المرور مطلوبة',
            'password.string' => 'كلمة المرور يجب أن تكون نصًا',
            'password.min' => 'كلمة المرور يجب أن تكون على الأقل 8 أحرف',
            'role.required' => 'الدور مطلوب',
            'role.string' => 'الدور يجب أن يكون نصًا',
            'role.max' => 'الدور يجب ألا يتجاوز 255 حرفًا',
        ];
    }

    protected function prepareForValidation()
    {
        if (!$this->username) {
            return response()->json(['message' => 'اسم المستخدم مطلوب'], 422);
        }

        $this->merge([
            'email' => $this->username . '@ahmed.com',
            'balance' => 0,
        ]);
    }
}
