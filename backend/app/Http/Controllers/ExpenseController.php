<?php

namespace App\Http\Controllers;

use App\Http\Requests\StoreExpenseRequest;
use App\Http\Resources\ExpenseResource;
use App\Http\Resources\TransactionResource;
use App\Models\Expense;
use App\Models\Transaction;
use Illuminate\Http\Request;
use App\Enums\ExpenseStatus;
use App\Enums\TransactionCategory;
use Illuminate\Support\Facades\Log; // Add this line

class ExpenseController extends Controller
{
    public function store(StoreExpenseRequest $request)
    {
        try {
            $transaction = Transaction::create([
                'category' => $request->category,
                'transaction_type' => 'expense',
                'user_id' => $request->user()->id,
                'amount' => $request->amount,
                'description' => $request->description,
                'attachment' => $request->attachment,
            ]);

            $transaction->expense()->create([
                'transaction_id' => $transaction->id,
                'committee' => $request->committee,
                'destination' => $request->destination,
                'purpose' => $request->purpose,
            ]);

            return new TransactionResource($transaction);
        } catch (\Exception $e) {
            Log::error('خطأ في تخزين المصروف: ' . $e->getMessage());
            return response()->json(['message' => 'حدث خطأ أثناء تخزين المصروف'], 500);
        }
    }

    public function destroy(Expense $expense)
    {
        try {
            if ($expense->created_at->diffInMinutes(now()) > 60) {
                return response()->json(['error' => 'لا يمكن حذف المصروف بعد مرور 60 دقيقة من إنشائه.'], 403);
            }

            $expense->delete();

            return response()->json(['message' => 'تم حذف المصروف بنجاح.']);
        } catch (\Exception $e) {
            Log::error('خطأ في حذف المصروف: ' . $e->getMessage());
            return response()->json(['message' => 'حدث خطأ أثناء حذف المصروف'], 500);
        }
    }

    public function show(Expense $expense)
    {
        try {
            return new ExpenseResource($expense);
        } catch (\Exception $e) {
            Log::error('خطأ في جلب المصروف: ' . $e->getMessage());
            return response()->json(['message' => 'حدث خطأ أثناء جلب المصروف'], 500);
        }
    }

    public function index()
    {
        try {
            return TransactionResource::collection(Transaction::getTransactionsByType('expense'));
        } catch (\Exception $e) {
            Log::error('خطأ في جلب المصروفات: ' . $e->getMessage());
            return response()->json(['message' => 'حدث خطأ أثناء جلب المصروفات'], 500);
        }
    }

    public function updateStatus(Request $request, Expense $expense)
    {
        try {
            $request->validate([
                'status' => ['required', 'in:' . implode(',', ExpenseStatus::getValues())],
            ], [
                'status.required' => 'حقل الحالة مطلوب.',
                'status.in' => 'الحالة يجب أن تكون من القيم التالية: ' . implode(',', ExpenseStatus::getValues()),
            ]);

            $expense->status = $request->status;
            $expense->save();

            return response()->json(['message' => 'تم تحديث حالة المصروف بنجاح.']);
        } catch (\Exception $e) {
            Log::error('خطأ في تحديث حالة المصروف: ' . $e->getMessage());
            return response()->json(['message' => 'حدث خطأ أثناء تحديث حالة المصروف'], 500);
        }
    }

    public function __invoke()
    {
        try {
            $categories = [
                TransactionCategory::SERVICES => 'SUM(CASE WHEN category = ? THEN amount ELSE 0 END) AS ' . TransactionCategory::SERVICES,
                TransactionCategory::MISCELLANEOUS => 'SUM(CASE WHEN category = ? THEN amount ELSE 0 END) AS ' . TransactionCategory::MISCELLANEOUS,
                TransactionCategory::TRANSPORTATION => 'SUM(CASE WHEN category = ? THEN amount ELSE 0 END) AS ' . TransactionCategory::TRANSPORTATION,
                TransactionCategory::RENT_ASSETS => 'SUM(CASE WHEN category = ? THEN amount ELSE 0 END) AS ' . TransactionCategory::RENT_ASSETS,
                TransactionCategory::PURCHASES => 'SUM(CASE WHEN category = ? THEN amount ELSE 0 END) AS ' . TransactionCategory::PURCHASES,
                'total' => 'SUM(amount) AS total',
            ];

            $categoryValues = [
                TransactionCategory::SERVICES,
                TransactionCategory::MISCELLANEOUS,
                TransactionCategory::TRANSPORTATION,
                TransactionCategory::RENT_ASSETS,
                TransactionCategory::PURCHASES,
            ];

            $transactions = Transaction::where('transaction_type', 'expense')
                ->selectRaw(implode(', ', $categories), $categoryValues)
                ->first();

            $transactionsX = Transaction::where('transaction_type', 'expense')->paginate(10);
            return TransactionResource::collection(
                $transactionsX
            )->additional(
                [
                    'isTransaction' => false,
                    'total' =>
                    collect($categories)
                        ->keys()
                        ->mapWithKeys(fn($key) => [$key => optional($transactions)->$key ?? 0])
                        ->toArray(),
                    'nextPage' => $transactionsX->currentPage() + 1,
                    'hasMore' => $transactionsX->hasMorePages(),
                ]
            );
        } catch (\Exception $e) {
            Log::error('خطأ في جلب المصروفات: ' . $e->getMessage());
            return response()->json(['message' => 'حدث خطأ أثناء جلب المصروفات'], 500);
        }
    }

    public function getExpenseCommittee($committee)
    {
        try {
            $categories = [
                TransactionCategory::SERVICES => 'SUM(CASE WHEN category = ? THEN amount ELSE 0 END) AS ' . TransactionCategory::SERVICES,
                TransactionCategory::MISCELLANEOUS => 'SUM(CASE WHEN category = ? THEN amount ELSE 0 END) AS ' . TransactionCategory::MISCELLANEOUS,
                TransactionCategory::TRANSPORTATION => 'SUM(CASE WHEN category = ? THEN amount ELSE 0 END) AS ' . TransactionCategory::TRANSPORTATION,
                TransactionCategory::RENT_ASSETS => 'SUM(CASE WHEN category = ? THEN amount ELSE 0 END) AS ' . TransactionCategory::RENT_ASSETS,
                TransactionCategory::PURCHASES => 'SUM(CASE WHEN category = ? THEN amount ELSE 0 END) AS ' . TransactionCategory::PURCHASES,
                'total' => 'SUM(amount) AS total',
            ];

            $categoryValues = [
                TransactionCategory::SERVICES,
                TransactionCategory::MISCELLANEOUS,
                TransactionCategory::TRANSPORTATION,
                TransactionCategory::RENT_ASSETS,
                TransactionCategory::PURCHASES,
            ];

            // تطبيق الفلترة على اللجنة
            $transactions = Transaction::where('transaction_type', 'expense')
                ->byCommittee($committee) // تطبيق Scope
                ->selectRaw(implode(', ', $categories), $categoryValues)
                ->first();
            $transactionsX = Transaction::where('transaction_type', 'expense')
                ->byCommittee($committee) // تطبيق Scope
                ->paginate(10);
            return TransactionResource::collection(
                $transactionsX
            )->additional([
                'isTransaction' => false,
                'total' => collect($categories)
                    ->keys()
                    ->mapWithKeys(fn($key) => [$key => optional($transactions)->$key ?? 0])
                    ->toArray(),
                'nextPage' => $transactionsX->currentPage() + 1,
                'hasMore' => $transactionsX->hasMorePages(),
            ]);
        } catch (\Exception $e) {
            Log::error('خطأ في جلب المصروفات للجنة: ' . $e->getMessage());
            return response()->json(['message' => 'حدث خطأ أثناء جلب المصروفات للجنة'], 500);
        }
    }
}
