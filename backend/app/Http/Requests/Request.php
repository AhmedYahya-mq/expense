<?php

namespace App\Http\Requests;

use App\Helpers\ImageHelper;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Support\Facades\Log;

class Request extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true; // تعديلها حسب الصلاحيات المناسبة للمستخدم
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {

        return [
            'category' => 'required|in:' . implode(',', \App\Enums\TransactionCategory::getValues()),
            'amount' => 'required|integer|min:1',
            'description' => 'required|string|max:255',
            'image' => 'nullable|file|mimes:jpg,png',
            'purpose' => 'required|string|max:255',
            'destination' => 'nullable|string|max:255',
            'method' => 'nullable|string|max:255',
        ];
    }

    /**
     * Get the custom validation messages.
     *
     * @return array
     */
    public function messages(): array
    {
        return [

            'category.required' => 'يجب تحديد الفئة.',
            'category.in' => 'الفئة المختارة غير صالحة.',
            'amount.required' => 'يجب إدخال المبلغ.',
            'amount.integer' => 'يجب أن يكون المبلغ عددًا صحيحًا.',
            'amount.min' => 'يجب أن يكون المبلغ أكبر من 0.',
            'description.string' => 'الوصف يجب أن يكون نصًا.',
            'description.max' => 'الوصف يجب ألا يتجاوز 255 حرفًا.',
            'image.file' => 'يجب تحميل ملف.',
            'image.mimes' => 'الملف يجب أن يكون من نوع صورة: jpg, png.',
            'purpose.string' => 'الغرض يجب أن يكون نصًا.',
            'purpose.max' => 'الغرض يجب ألا يتجاوز 255 حرفًا.',
            'destination.string' => 'الوجهة يجب أن تكون نصًا.',
            'destination.max' => 'الوجهة يجب ألا تتجاوز 255 حرفًا.',
            'method.string' => 'الطريقة يجب أن تكون نصًا.',
            'method.max' => 'الطريقة يجب ألا تتجاوز 255 حرفًا.',
        ];
    }

    // تنفيذ دالة بعد نجاح تحقق
    protected function passedValidation()
    {
        $path = null;
        if ($this->hasFile('image')) {
            $path = ImageHelper::storeSingleImage($this->file('image'), 'attachments', disk: 'public');
        }
        Log::info($this->user());
        $this->merge([
            'attachment' => $path,
            'committee' => $this->user()->role,
            'user_id' => $this->user()->id,
        ]);
    }
}
