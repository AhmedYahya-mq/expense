<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class ChangeUsernameRequest extends FormRequest
{
    public function authorize()
    {
        return true;
    }

    public function rules()
    {
        return [
            'new_username' => 'required|string|max:255|unique:users,username',
        ];
    }

    public function messages()
    {
        return [
            'new_username.required' => 'اسم المستخدم الجديد مطلوب',
            'new_username.string' => 'اسم المستخدم الجديد يجب أن يكون نصًا',
            'new_username.max' => 'اسم المستخدم الجديد يجب ألا يتجاوز 255 حرفًا',
            'new_username.unique' => 'اسم المستخدم الجديد مستخدم بالفعل',
        ];
    }
}
