<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use App\Enums\TransactionCategory; // Add this line
use Illuminate\Database\Eloquent\Builder; // Add this line

class Transaction extends Model
{
    protected $fillable = [
        'user_id',
        'amount',
        'transaction_type',
        'category',
        'description',
        'attachment',
    ];

    protected $casts = [
        'category' => TransactionCategory::class, // Add this line
    ];

    protected static function boot()
    {
        parent::boot();

        static::addGlobalScope('orderByCreatedAt', function (Builder $builder) {
            $builder->orderBy('created_at', 'desc');
        });
    }


    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public static function getAllTransactions()
    {
        return self::all();
    }


    // علاقة بالدخل
    public function income()
    {
        return $this->hasOne(Income::class);
    }

    // علاقة بالمصروف
    public function expense()
    {
        return $this->hasOne(Expense::class);
    }

    // جلب حسب نوع
    public static function getTransactionsByType($type)
    {
        return self::where('transaction_type', $type)->get();
    }

    // Add this method
    public static function getTransactionsByCategory(TransactionCategory $category)
    {
        return self::where('category', $category->value)->get();
    }

    // Add this method
    public function getCategoryLabel()
    {
        return TransactionCategory::getLabel($this->category);
    }

    public function scopeIncomes($query)
    {
        return $query->where('transaction_type', 'income');
    }

    public function scopeExpenses($query)
    {
        return $query->where('transaction_type', 'expense');
    }

    public function scopeIncomeCategory($query, string $category)
    {
        return $query->where('transaction_type', 'income')->where('category', $category);
    }

    public function scopeIncomeSum($query)
    {
        return $query->where('transaction_type', 'income')->sum('amount');
    }

    public function scopeExpenseSum($query)
    {
        return $query->where('transaction_type', 'expense')->sum('amount');
    }


    public function scopeIncomeCategorySum($query, TransactionCategory $category)
    {
        return $query->where('transaction_type', 'income')->where('category', $category)->sum('amount');
    }

    public function scopeExpenseCategorySum($query, TransactionCategory $category)
    {
        return $query->where('transaction_type', 'expense')->where('category', $category)->sum('amount');
    }

    public function scopeByCommittee($query, $committee)
    {
        return $query->whereHas('expense', function ($query) use ($committee) {
            $query->where('committee', $committee);
        });
    }
}
