<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use App\Enums\ExpenseStatus; // Add this line
use App\Enums\Role;
use Illuminate\Support\Facades\DB;

class Expense extends Model
{
    use HasFactory;

    protected $fillable = [
        'transaction_id',
        'committee',
        'purpose',
        'destination',
        'method',
        'paid_by',
        'approved_by',
    ];

    protected $casts = [
        'status' => ExpenseStatus::class, // Add this line
    ];

    public function transaction(): BelongsTo
    {
        return $this->belongsTo(Transaction::class);
    }

    public function paidBy(): BelongsTo
    {
        return $this->belongsTo(User::class, 'paid_by');
    }

    public function approvedBy(): BelongsTo
    {
        return $this->belongsTo(User::class, 'approved_by');
    }

    public static function getAllExpenses()
    {
        return self::all();
    }

    public static function getExpensesByStatus(ExpenseStatus $status)
    {
        return self::where('status', $status->value)->get();
    }


    public static function getExpensesGroupedByCommittee()
    {
        return DB::transaction(function () {
            // قائمة اللجان بناءً على الـ Enum
            $committees = [
                Role::HEAD_OF_PREPARATORY_COMMITTEE => Role::HEAD_OF_PREPARATORY_COMMITTEE,
                Role::HEAD_OF_FINANCIAL_COMMITTEE => Role::HEAD_OF_FINANCIAL_COMMITTEE,
                Role::HEAD_OF_RELATIONS_COMMITTEE => Role::HEAD_OF_RELATIONS_COMMITTEE,
                Role::HEAD_OF_TECHNICAL_COMMITTEE => Role::HEAD_OF_TECHNICAL_COMMITTEE,
                Role::HEAD_OF_SUPERVISORY_COMMITTEE => Role::HEAD_OF_SUPERVISORY_COMMITTEE,
                Role::HEAD_OF_MEDIA_COMMITTEE => Role::HEAD_OF_MEDIA_COMMITTEE,
            ];

            // جلب النفقات الفعلية من قاعدة البيانات
            $expenses = self::select('committee')
                ->join('transactions', 'expenses.transaction_id', '=', 'transactions.id')
                ->selectRaw('SUM(transactions.amount) as total_expense')
                ->groupBy('committee')
                ->get();

            // تحويل البيانات إلى مصفوفة key => value
            $result = $expenses->pluck('total_expense', 'committee')->toArray();

            // التأكد من أن كل اللجان موجودة وإذا لم تكن موجودة يتم تعيينها إلى 0
            foreach ($committees as $committee_name => $committee_key) {
                if (!isset($result[$committee_name])) {
                    $result[$committee_name] = 0;
                }
            }

            // إعادة النتيجة
            return $result;
        });
    }

    public function scopeByCommittee($query, $committee)
    {
        return $query->whereHas('expense', function ($query) use ($committee) {
            $query->where('committee', $committee);
        });
    }
}
