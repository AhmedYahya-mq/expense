<?php

namespace App\Http\Controllers;

use App\Enums\TransactionCategory;
use App\Helpers\ImageHelper;
use App\Http\Requests\StoreIncomeRequest;
use App\Http\Resources\IncomeResource;
use App\Http\Resources\TransactionResource;
use App\Models\Income;
use App\Models\Transaction;
use App\Models\User;
use Illuminate\Container\Attributes\Auth;
use Illuminate\Support\Facades\Log;

class IncomeController extends Controller
{
    // دالة لتخزين الدخل
    public function store(StoreIncomeRequest $request)
    {
        try {
            // إنشاء العملية
            $transaction = Transaction::create(
                $request->only(['category', 'user_id', 'amount', 'description', 'attachment']) + ['transaction_type' => 'income']
            );

            // إنشاء بيانات الدخل المرتبطة مباشرة بالعلاقة
            $transaction->income()->create($request->only(['recipient_id', 'supporter_name', 'deducted_amount']));

            return new TransactionResource($transaction);
        } catch (\Exception $e) {
            Log::error('خطأ في تخزين الدخل: ' . $e->getMessage());
            return response()->json(['message' => 'حدث خطأ أثناء تخزين الدخل'], 500);
        }
    }

    // دالة لحذف الدخل
    public function destroy(Income $income)
    {
        try {
            // التحقق من عمر الدخل
            if ($income->created_at->diffInMinutes(now()) > 60) {
                return response()->json([
                    'errors' => [
                        'outTime' => ['لا يمكن حذف الدخل بعد مرور 60 دقيقة من إنشائه.']
                    ]
                ], 422);
            }

            // حذف الصورة إذا كانت موجودة
            if ($income->image_path) {
                ImageHelper::deleteImage($income->image_path);
            }

            // حذف الدخل
            $income->transaction->delete();
            $income->delete();

            return response()->json(['message' => 'تم حذف الدخل بنجاح.']);
        } catch (\Exception $e) {
            Log::error('خطأ في حذف الدخل: ' . $e->getMessage());
            return response()->json(['message' => 'حدث خطأ أثناء حذف الدخل'], 500);
        }
    }

    // دالة لعرض دخل محدد
    public function show(Income $income)
    {
        try {
            return new IncomeResource($income);
        } catch (\Exception $e) {
            Log::error('خطأ في جلب الدخل: ' . $e->getMessage());
            return response()->json(['message' => 'حدث خطأ أثناء جلب الدخل'], 500);
        }
    }

    // دالة لعرض جميع الدخل
    public function index()
    {
        try {
            $transactions = Transaction::where('transaction_type', "income")->paginate(10);
            return TransactionResource::collection($transactions)->additional(
                [
                    'nextPage' => $transactions->currentPage() + 1,
                    'hasMore' => $transactions->hasMorePages(),
                ]
            );
        } catch (\Exception $e) {
            Log::error('خطأ في جلب الدخل: ' . $e->getMessage());
            return response()->json(['message' => 'حدث خطأ أثناء جلب الدخل'], 500);
        }
    }

    public function userIncomes()
    {
        try {
            $user = auth()->user();
            if (!$user) {
                return response()->json(['message' => 'المستخدم غير مسجل دخول'], 401);
            }
            return TransactionResource::collection($user->transactions()->where('transaction_type', 'income')->where('category', TransactionCategory::STUDENTS)->get());
        } catch (\Exception $e) {
            Log::error('خطأ في جلب دخل المستخدم: ' . $e->getMessage());
            return response()->json(['message' => 'حدث خطأ أثناء جلب دخل المستخدم'], 500);
        }
    }

    public function __invoke()
    {
        try {
            $transactions = Transaction::where('transaction_type', 'income')
                ->selectRaw('
                    SUM(CASE WHEN category = ? THEN amount ELSE 0 END) as student,
                    SUM(CASE WHEN category = ? THEN amount ELSE 0 END) as support,
                    SUM(amount) as total
                ', [TransactionCategory::STUDENTS, TransactionCategory::SUPPORT])
                ->first();
            $transactionsX = Transaction::where('transaction_type', 'income')->paginate(10);
            return TransactionResource::collection($transactionsX)->additional([
                'isTransaction' => false,
                'total' => [
                    'total' => $transactions->total,
                    'students' => optional($transactions)->student ?? 0,
                    'support' => optional($transactions)->support ?? 0,
                ],
                'nextPage' => $transactionsX->currentPage() + 1,
                'hasMore' => $transactionsX->hasMorePages(),
            ]);
        } catch (\Exception $e) {
            Log::error('خطأ في جلب الدخل: ' . $e->getMessage());
            return response()->json(['message' => 'حدث خطأ أثناء جلب الدخل'], 500);
        }
    }
}
