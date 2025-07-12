<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Income extends Model
{
    // الحقول القابلة للتعبئة
    protected $fillable = [
        'recipient_id',
        'supporter_name',
        "transaction_id",
        'deducted_amount',
    ];

    // علاقة المستلم
    public function recipient(): BelongsTo
    {
        return $this->belongsTo(User::class, 'recipient_id');
    }


    // علاقة بالمعاملة
    public function transaction(): BelongsTo
    {
        return $this->belongsTo(Transaction::class);
    }

    // جلب جميع الدخل
    public static function getAllIncomes()
    {
        return self::all();
    }

}
