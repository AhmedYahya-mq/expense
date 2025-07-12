<?php

namespace App\Http\Requests;

use App\Helpers\ImageHelper;
use App\Models\Setting;
use Illuminate\Foundation\Http\FormRequest;
use App\Enums\TransactionCategory;

class StoreIncomeRequest extends FormRequest
{
    // السماح بتنفيذ الطلب
    public function authorize(): bool
    {
        return true;
    }

    // قواعد التحقق
    public function rules(): array
    {
        return [
            'recipient_id' => 'required|integer|exists:users,id',
            'supporter_name' => 'nullable|string|max:255',
            'category' => 'required|string|in:' . implode(',', TransactionCategory::getValues()),
            'amount' => 'required|integer',
            'description' => 'nullable|string|max:255',
            'image' => 'nullable|image|max:2048',
            'user_id' => 'required|integer|exists:users,id',
        ];
    }

    // رسائل التحقق
    public function messages(): array
    {
        return [
            'recipient_id.required' => 'معرف المستلم مطلوب.',
            'recipient_id.integer' => 'معرف المستلم يجب أن يكون عدد صحيح.',
            'recipient_id.exists' => 'معرف المستلم غير موجود.',
            'supporter_name.string' => 'اسم الداعم يجب أن يكون نص.',
            'supporter_name.max' => 'اسم الداعم يجب ألا يتجاوز 255 حرف.',
            'amount.required' => 'الفئة مطلوبة.',
            'amount.integer' => 'المبلغ يجب أن يكون عدد صحيح.',
            'category.string' => 'الفئة يجب أن تكون نص.',
            'category.in' => 'الفئة يجب أن تكون إما :values.',
            'supporter_name.max' => 'الفئة يجب ألا تتجاوز 255 حرف.',
            'amount.required' => 'المبلغ مطلوب.',
            'amount.integer' => 'المبلغ يجب أن يكون عدد صحيح.',
            'description.string' => 'الوصف يجب أن يكون نص.',
            'description.max' => 'الوصف يجب ألا يتجاوز 255 حرف.',
            'image.image' => 'الصورة يجب أن تكون من نوع صورة.',
            'image.max' => 'حجم الصورة يجب ألا يتجاوز 2048 كيلوبايت.',
            'user_id.required' => 'معرف المستخدم مطلوب.',
            'user_id.integer' => 'معرف المستخدم يجب أن يكون عدد صحيح.',
            'user_id.exists' => 'معرف المستخدم غير موجود.',

        ];
    }

    // تنفيذ دالة بعد نجاح تحقق
    protected function passedValidation()
    {
        $amount = $this->input('amount');
        $deducted_amount = 0;
        if ($this->category && $this->category == 'support') {
            $contributionPercentage = Setting::get('contributionPercentage');
            $deducted_amount = $this->input('amount') * ($contributionPercentage / 100);
            $amount = $this->input('amount') - $deducted_amount;
        }
        $path = null;
        if ($this->hasFile('image')) {
            $path = ImageHelper::storeSingleImage($this->file('image'), 'attachments', disk: 'public');
        }
        $this->merge([
            'recipient_id' => (int) $this->recipient_id,
            'amount' => (int) $amount,
            'deducted_amount' => (int) $deducted_amount,
            'attachment' => $path,
        ]);
    }
}
