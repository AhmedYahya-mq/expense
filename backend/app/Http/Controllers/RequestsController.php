<?php

namespace App\Http\Controllers;

use App\Enums\ExpenseStatus;
use App\Enums\Role;
use App\Http\Requests\OrderRequest;
use App\Http\Resources\RequestResource;
use App\Models\Expense;
use Illuminate\Support\Facades\Log;
use App\Models\Transaction; // Add this line
use Illuminate\Http\UploadedFile; // Add this line
use App\Helpers\ImageHelper;
use Illuminate\Http\Request;

class RequestsController extends Controller
{

    /**
     * Store a newly created request in storage.
     *
     * @param  \App\Http\Requests\RequestModelRequest  $request
     * @return \Illuminate\Http\RedirectResponse
     */
    public function store(\App\Http\Requests\Request $request)
    {
        try {
            $expense = Expense::create([
                'purpose' => $request->purpose,
                'committee' => $request->committee,
                'destination' =>  $request->destination ?? "",
                'method' =>  $request->method ?? "",
            ]);

            $requestData = $request->all();
            $requestData['expense_id'] = $expense->id;
            $newRequest = \App\Models\Request::create($requestData);
            return new RequestResource($newRequest);
        } catch (\Exception $e) {
            Log::error('خطأ في تخزين الطلب: ' . $e->getMessage());
            return response()->json(['message' => 'حدث خطأ أثناء تخزين الطلب'], 500);
        }
    }


    public function index()
    {
        try {
            $filter = request('filter');
            $status = auth()->user()->role == Role::HEAD_OF_FINANCIAL_COMMITTEE
                ? [ExpenseStatus::APPROVED_BY_MANAGEMENT, ExpenseStatus::PAID]
                : [ExpenseStatus::PENDING, ExpenseStatus::APPROVED_BY_MANAGEMENT, ExpenseStatus::PAID];
            $query = \App\Models\Request::whereIn('status', $status);
            if ($filter !== "all") {
                $query->whereHas('expense', function ($query) use ($filter) {
                    $query->where('committee', $filter);
                });
            }
            $requests = $query->paginate(10);
            return RequestResource::collection($requests)->additional([
                'nextPage' => $requests->currentPage() + 1,
                'hasMore' => $requests->hasMorePages(),
            ]);
        } catch (\Exception $e) {
            Log::error('خطأ في جلب الطلبات: ' . $e->getMessage());
            return response()->json(['message' => 'حدث خطأ أثناء جلب الطلبات'], 500);
        }
    }


    public function getUserId($id)
    {
        try {
            $requests = \App\Models\Request::where('user_id', $id)->paginate(10);
            return RequestResource::collection($requests)->additional([
                'nextPage' => $requests->currentPage() + 1,
                'hasMore' => $requests->hasMorePages(),
            ]);
        } catch (\Exception $e) {
            Log::error('خطأ في جلب الطلبات للمستخدم: ' . $e->getMessage());
            return response()->json(['message' => 'حدث خطأ أثناء جلب الطلبات للمستخدم'], 500);
        }
    }

    public function approve(Request $request, $id)
    {
        try {
            $user = auth()->user();
            $userRole = $user->role;
            $requestModel = \App\Models\Request::findOrFail($id);
            $this->authorizeUser($user);

            if ($userRole == Role::HEAD_OF_PREPARATORY_COMMITTEE) {
                $requestModel->status = ExpenseStatus::APPROVED_BY_MANAGEMENT;
                $requestModel->expense->approved_by = $user->id;
                $requestModel->expense->save();
                $requestModel->save();
                return new RequestResource($requestModel);
            } else {
                $requestModel->status = ExpenseStatus::PAID;
                $requestModel->expense->paid_by = $user->id;
            }

            $transaction = Transaction::create([
                'user_id' => $requestModel->user_id,
                'amount' => $requestModel->amount,
                'transaction_type' => 'expense',
                'category' => $requestModel->category,
                'description' => $requestModel->description,
                'attachment' => $requestModel->attachment,
            ]);

            $expense = $requestModel->expense;
            $expense->transaction_id = $transaction->id;
            $expense->save();
            $requestModel->save();

            return new RequestResource($requestModel);
        } catch (\Illuminate\Auth\Access\AuthorizationException $e) {
            return response()->json(['message' => 'ليس لديك صلاحيات كافية'], 403);
        } catch (\Exception $e) {
            Log::error('خطأ في الموافقة على الطلب: ' . $e->getMessage());
            return response()->json(['message' => 'حدث خطأ أثناء الموافقة على الطلب'], 500);
        }
    }

    public function reject(Request $request, $id)
    {
        try {
            $user = auth()->user();
            $userRole = $user->role;
            $requestModel = \App\Models\Request::findOrFail($id);
            $this->authorizeUser($user);
            if (!$request->has('rejection_reason') || empty($request->rejection_reason)) {
                return response()->json(['message' => 'يرجى تقديم سبب الرفض'], 400);
            }
            $requestModel->is_declined = true;
            $requestModel->rejection_reason = $request->rejection_reason;
            if ($userRole == Role::HEAD_OF_PREPARATORY_COMMITTEE)
                $requestModel->expense->approved_by = $user->id;
            else
                $requestModel->expense->paid_by = $user->id;

            $requestModel->save();
            return new RequestResource($requestModel);
        } catch (\Illuminate\Auth\Access\AuthorizationException $e) {
            return response()->json(['message' => 'ليس لديك صلاحيات كافية'], 403);
        } catch (\Exception $e) {
            Log::error('خطأ في رفض الطلب: ' . $e->getMessage());
            return response()->json(['message' => 'حدث خطأ أثناء رفض الطلب'], 500);
        }
    }

    protected function authorizeUser($user)
    {
        if (!in_array($user->role, [Role::HEAD_OF_PREPARATORY_COMMITTEE, Role::HEAD_OF_FINANCIAL_COMMITTEE])) {
            throw new \Illuminate\Auth\Access\AuthorizationException();
        }
    }

    public function updateAttachment(Request $request, $id)
    {
        try {
            $requestModel = \App\Models\Request::findOrFail($id);
            $user = auth()->user();

            if (!($user->id == $requestModel->user_id || $user->role == Role::HEAD_OF_FINANCIAL_COMMITTEE || $user->role == Role::HEAD_OF_PREPARATORY_COMMITTEE)) {
                return response()->json(['message' => 'ليس لديك صلاحيات الكافية'], 403);
            }

            if ($request->hasFile('attachment') && $request->file('attachment')->isValid()) {
                // Delete the old attachment if it exists
                if ($requestModel->attachment) {
                    ImageHelper::deleteImage($requestModel->attachment);
                }

                // Store the new attachment
                $path = ImageHelper::storeSingleImage($request->file('attachment'), 'attachments', disk: 'public');
                Log::info($path);
                // Update the request model with the new attachment path
                $requestModel->attachment = $path;
                if ($requestModel->expense->transaction != null) {
                    $transaction = $requestModel->expense->transaction;
                    $transaction->attachment = $path;
                    $transaction->save();
                }
                $requestModel->save();
                return new RequestResource($requestModel);
            }
        } catch (\Exception $e) {
            Log::error('خطأ في تحديث المرفق: ' . $e->getMessage());
            return response()->json(['message' => 'حدث خطأ أثناء تحديث المرفق'], 500);
        }
        return response()->json(['message' => 'المرفق غير صالح'], 400);
    }
}
