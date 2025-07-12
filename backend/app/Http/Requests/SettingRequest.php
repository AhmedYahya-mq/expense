<?php

namespace App\Http\Requests;

use App\Enums\Role;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Support\Facades\Log;

class SettingRequest extends FormRequest
{
    public function authorize()
    {
        return $this->user()->role == Role::HEAD_OF_FINANCIAL_COMMITTEE;
    }

    public function rules()
    {
        return [
            'settings' => 'required|array',
            'settings.*.key' => 'required|string|distinct',
            'settings.*.value' => 'required|string',
        ];
    }

    public function messages()
    {
        return [
            'settings.required' => 'مصفوفة الإعدادات مطلوبة.',
            'settings.array' => 'يجب أن تكون الإعدادات مصفوفة.',
            'settings.*.key.required' => 'يجب أن يحتوي كل إعداد على مفتاح.',
            'settings.*.key.string' => 'يجب أن يكون مفتاح كل إعداد نصًا.',
            'settings.*.key.distinct' => 'يجب أن يكون مفتاح كل إعداد مميزًا.',
            'settings.*.value.required' => 'يجب أن يحتوي كل إعداد على قيمة.',
            'settings.*.value.string' => 'يجب أن تكون قيمة كل إعداد نصًا.',
        ];
    }
}
