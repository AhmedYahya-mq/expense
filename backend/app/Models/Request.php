<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Enums\ExpenseStatus;
use App\Enums\TransactionCategory;
use Illuminate\Database\Eloquent\Builder;

class Request extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'category',
        'amount',
        'description',
        'attachment',
        'status',
        'is_declined',
        'expense_id',
        'rejection_reason',
    ];

    protected $casts = [
        'status' => ExpenseStatus::class,
        'category' => TransactionCategory::class,
        'is_declined' => 'boolean',
    ];

    // العلاقات
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function expense()
    {
        return $this->belongsTo(Expense::class);
    }

    public function scopeStatus($query, $value = ExpenseStatus::PENDING)
    {
        return $query->where('status', $value)->where('is_declined', false);
    }

    protected static function boot()
    {
        parent::boot();

        static::addGlobalScope('orderByCreatedAt', function (Builder $builder) {
            $builder->orderBy('created_at', 'desc');
        });
    }
}
