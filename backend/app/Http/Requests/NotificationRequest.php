<?php

namespace App\Http\Requests;

use App\Helpers\ImageHelper;
use Illuminate\Foundation\Http\FormRequest;

class NotificationRequest extends FormRequest
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
            'title' => ['required', 'string'],
            'body' => ['required', 'string'],
            // image is optional file to send with the notification minimum 1 file max 1 file mx 1mb minum png ..
            'image' => ['nullable', 'file', 'max:1024'],
        ];
    }

    /**
     * Get the error messages for the defined validation rules.
     *
     * @return array<string, string>
     */
    public function messages(): array
    {
        return [
            'title.required' => 'حقل العنوان مطلوب.',
            'title.string' => 'حقل العنوان يجب أن يكون نص.',
            'body.required' => 'حقل النص مطلوب.',
            'body.string' => 'حقل النص يجب أن يكون نص.',
            'image.file' => 'حقل الصورة يجب أن يكون ملف.',
            'image.max' => 'حجم الصورة يجب أن لا يتجاوز 1 ميجابايت.',
        ];
    }

    protected function passedValidation()
    {
        $path = null;
        if ($this->hasFile('image')) {
            $path = ImageHelper::storeSingleImage($this->file('image'), 'notifications', disk: 'public');
        }
        $this->merge([
            'image' => $path,
        ]);
    }
}
