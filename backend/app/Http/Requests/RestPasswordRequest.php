<?php

namespace App\Http\Requests;

use Illuminate\Container\Attributes\Auth;
use Illuminate\Foundation\Http\FormRequest;

class RestPasswordRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return auth()->check();
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            'current_password' => ['required', 'string', 'min:8'],
            'new_password' => ['required', 'string', 'min:8', 'confirmed'],
        ];
    }

    public function messages()
    {
        return [
            'current_password.required' => 'كلمة السر الحالية مطلوبة',
            'current_password.string' => 'كلمة السر الحالية يجب أن تكون نصًا',
            'current_password.min' => 'كلمة السر الحالية يجب ألا تقل عن 8 أحرف',
            'new_password.required' => 'كلمة السر الجديدة مطلوبة',
            'new_password.string' => 'كلمة السر الجديدة يجب أن تكون نصًا',
            'new_password.min' => 'كلمة السر الجديدة يجب ألا تقل عن 8 أحرف',
            'new_password.confirmed' => 'تأكيد كلمة السر الجديدة غير متطابق',
        ];
    }
}
