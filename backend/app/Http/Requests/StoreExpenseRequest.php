<?php

namespace App\Http\Requests;

use App\Enums\TransactionCategory;
use App\Helpers\ImageHelper;
use Illuminate\Foundation\Http\FormRequest;

class StoreExpenseRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'description' => 'nullable|string|max:255',
            'image' => 'nullable|image|max:2048',
            'user_id' => 'required|integer|exists:users,id',
            'committee' => 'required|string|max:255',
            'destination' => 'required|string|max:255',
            'purpose' => 'required|string|max:255',
            'category' => 'required|string|in:' . implode(',', TransactionCategory::getValues()),
        ];
    }

    public function messages(): array
    {
        return [
            'committee.required' => 'اللجنة مطلوبة.',
            'committee.string' => 'اللجنة يجب أن تكون نص.',
            'committee.max' => 'اللجنة يجب ألا تتجاوز 255 حرف.',
            'destination.required' => 'الوجهة مطلوبة.',
            'destination.string' => 'الوجهة يجب أن تكون نص.',
            'destination.max' => 'الوجهة يجب ألا تتجاوز 255 حرف.',
            'purpose.required' => 'الغرض مطلوب.',
            'purpose.string' => 'الغرض يجب أن يكون نص.',
            'purpose.max' => 'الغرض يجب ألا يتجاوز 255 حرف.',
            'description.string' => 'سبب الرفض يجب أن يكون نص.',
            'description.max' => 'سبب الرفض يجب ألا يتجاوز 255 حرف.',
            'image.image' => 'الصورة يجب أن تكون من نوع صورة.',
            'image.max' => 'حجم الصورة يجب ألا يتجاوز 2048 كيلوبايت.',
            'user_id.required' => 'معرف المستخدم مطلوب.',
            'user_id.integer' => 'معرف المستخدم يجب أن يكون عدد صحيح.',
            'user_id.exists' => 'معرف المستخدم غير موجود.',
            'category.string' => 'الفئة يجب أن تكون نص.',
            'category.in' => 'الفئة يجب أن تكون إما :values.',
        ];
    }

    // تنفيذ دالة بعد نجاح تحقق
    protected function passedValidation()
    {
        $path = null;
        if ($this->hasFile('image')) {
            $path = ImageHelper::storeSingleImage($this->file('image'), 'attachments', disk: 'public');
        }
        $this->merge([
            'recipient_id' => (int) $this->recipient_id,
            'attachment' => $path,
        ]);
    }
}
