<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class NotificationUserRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            'users' => ['required', 'array', 'min:1'],
            'users.*' => ['required', 'integer', 'exists:users,id'],
            'title' => ['required', 'string', 'max:255'],
            'body' => ['required', 'string', 'min:10'],
            'image' => [
                'nullable',
                'file',
                'max:1024' // 1MB
            ],
        ];
    }

    public function messages(): array
    {
        return [
            'users.required' => 'يجب تحديد المستخدمين المستلمين للإشعار.',
            'users.array' => 'قيمة المستخدمين يجب أن تكون في صيغة مصفوفة.',
            'users.min' => 'يجب تحديد مستخدم واحد على الأقل.',
            'users.*.required' => 'كل مستخدم في القائمة يجب أن يكون معرفًا صحيحًا.',
            'users.*.integer' => 'يجب أن يكون معرف المستخدم رقمًا صحيحًا.',
            'users.*.exists' => 'أحد المستخدمين المحددين غير موجود.',

            'title.required' => 'العنوان مطلوب.',
            'title.string' => 'يجب أن يكون العنوان نصًا.',
            'title.max' => 'يجب ألا يتجاوز العنوان 255 حرفًا.',

            'body.required' => 'المحتوى مطلوب.',
            'body.string' => 'يجب أن يكون المحتوى نصيًا.',
            'body.min' => 'يجب أن يحتوي المحتوى على 10 أحرف على الأقل.',

            'image.file' => 'يجب أن يكون الملف المرفق صورة.',
            'image.mimes' => 'يجب أن تكون الصورة بصيغة PNG فقط.',
            'image.max' => 'يجب ألا يتجاوز حجم الصورة 1 ميغابايت.',
        ];
    }

}
