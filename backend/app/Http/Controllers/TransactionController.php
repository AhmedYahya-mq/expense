<?php

namespace App\Http\Controllers;

use App\Enums\Role;
use App\Models\Expense;
use App\Models\Request;
use App\Models\Setting;
use App\Models\Transaction;
use App\Enums\TransactionCategory;
use App\Http\Resources\SettingResource;
use App\Http\Resources\TransactionResource;
use Illuminate\Support\Facades\Log; // Add this line

class TransactionController extends Controller
{

    public function index()
    {
        try {
            // جلب مجموع الدخل والنفقات في استعلام واحد
            $totals = Transaction::selectRaw("
                SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as income_sum,
                SUM(CASE WHEN transaction_type = 'expense' THEN amount ELSE 0 END) as expense_sum
            ")->first();

            $ExpensesGroupedByCommittee = Expense::getExpensesGroupedByCommittee();

            // جلب جميع الإعدادات مرة واحدة
            $settings = Setting::allSettings();
            $settingValue = $settings->first()->value ?? 1; // تجنب القسمة على صفر
            $percent = $totals->income_sum / $settingValue;

            return TransactionResource::collection(
                Transaction::limit(10)->get()
            )->additional([
                'settings' => SettingResource::collection($settings),
                'income_sum' => $totals->income_sum,
                'expense_sum' => $totals->expense_sum,
                'expense_income' => $totals->income_sum - $totals->expense_sum,
                'percent' => round($percent, 2),
                'ExpensesGroupedByCommittee' => $ExpensesGroupedByCommittee,
                'isNew' => auth()->user()->role == Role::HEAD_OF_FINANCIAL_COMMITTEE ?
                    \App\Models\Request::status(\App\Enums\ExpenseStatus::APPROVED_BY_MANAGEMENT)->exists() :
                    \App\Models\Request::status(\App\Enums\ExpenseStatus::PENDING)->exists(),
            ]);
        } catch (\Exception $e) {
            Log::error('خطأ في جلب البيانات: ' . $e->getMessage());
            return response()->json(['message' => 'حدث خطأ أثناء جلب البيانات'], 500);
        }
    }

    public function transaction()
    {
        try {
            $transaction =  Transaction::paginate(10);
            Log::info($transaction);
            return TransactionResource::collection(
                $transaction
            )->additional([
                'nextPage' => $transaction->currentPage() + 1,
                'hasMore' => $transaction->hasMorePages(),
            ]);
        } catch (\Exception $e) {
            Log::error('خطأ في جلب المعاملات: ' . $e->getMessage());
            return response()->json(['message' => 'حدث خطأ أثناء جلب المعاملات'], 500);
        }
    }

    public function show($id)
    {
        try {
            return new TransactionResource(Transaction::find($id));
        } catch (\Exception $e) {
            Log::error('خطأ في جلب المعاملة: ' . $e->getMessage());
            return response()->json(['message' => 'حدث خطأ أثناء جلب المعاملة'], 500);
        }
    }

    public function __invoke()
    {
        try {
            // جلب مجموع الدخل والنفقات في استعلام واحد
            $totals = Transaction::selectRaw("
                SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as income_sum,
                SUM(CASE WHEN transaction_type = 'expense' THEN amount ELSE 0 END) as expense_sum
            ")->first();
            $transactions = Transaction::paginate(10);
            return TransactionResource::collection(
                $transactions
            )->additional([
                'isTransaction' => true,
                'total' => [
                    'expense_sum' => $totals->expense_sum,
                    'income_sum' => $totals->income_sum,
                    'total' => $totals->income_sum + $totals->expense_sum,
                ],
                'nextPage' => $transactions->currentPage() + 1,
                'hasMore' => $transactions->hasMorePages(),
            ]);
        } catch (\Exception $e) {
            Log::error('خطأ في جلب البيانات: ' . $e->getMessage());
            return response()->json(['message' => 'حدث خطأ أثناء جلب البيانات'], 500);
        }
    }
}
