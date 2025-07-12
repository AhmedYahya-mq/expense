<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\SettingController;
use App\Http\Controllers\IncomeController;
use App\Http\Controllers\ExpenseController;
use App\Http\Controllers\RequestsController;
use App\Http\Controllers\TransactionController;
use App\Http\Controllers\UserController;

// ...existing code...

Route::post('/login', [AuthController::class, 'login'])->name('login'); // إضافة روات لتسجيل الدخول
Route::post('/logout', [AuthController::class, 'logout'])->middleware('auth:sanctum');
Route::post('/register', [AuthController::class, 'register'])->middleware('auth:sanctum'); // إضافة روات لإنشاء حساب
Route::get('/users', [AuthController::class, 'getAllUsers'])->middleware('auth:sanctum'); // إضافة روات لجلب بيانات الطلاب
Route::delete('/users/{id}', [AuthController::class, 'deleteUser'])->middleware('auth:sanctum'); // إضافة روات لحذف مستخدم
Route::get('/user', [AuthController::class, 'show'])->middleware('auth:sanctum');
Route::post('/user/image', [UserController::class, 'changeImageProfile'])->middleware('auth:sanctum');

Route::post('settings/init', [SettingController::class, 'store'])->middleware('auth:sanctum');
Route::get('/settings', [SettingController::class, 'index'])->middleware('auth:sanctum');

Route::post('/incomes', [IncomeController::class, 'store']); // مسار لتخزين الدخل
Route::delete('/incomes/{income}', [IncomeController::class, 'destroy']); // مسار لحذف الدخل
Route::get('/incomes', [IncomeController::class, 'index']); // مسار لجلب البيانات المخزنة
Route::get('/incomes/{income}', [IncomeController::class, 'show']); // مسار لجلب البيانات المخزنة
Route::get('/user/incomes', [IncomeController::class, 'userIncomes'])->middleware('auth:sanctum'); // مسار لجلب البيانات المخزنة
Route::get('/get/incomes', IncomeController::class)->middleware('auth:sanctum');

Route::get('/expenses', [ExpenseController::class, 'index'])->middleware('auth:sanctum'); // مسار لجلب البيانات المخزنة
Route::get('/expenses/{expense}', [ExpenseController::class, 'show'])->middleware('auth:sanctum'); // مسار لجلب البيانات المخزنة
Route::patch('/expenses/{expense}/status', [ExpenseController::class, 'updateStatus'])->middleware('auth:sanctum'); // مسار لتحديث حالة المصروف
Route::get('/get/expenses', ExpenseController::class); // مسار لتحديث حالة المصروف
Route::get('/get/expenses/{committee}', [ExpenseController::class, 'getExpenseCommittee']); // مسار لتحديث حالة المصروف

Route::get('/user-role', [UserController::class, 'getUserRole']); // مسار لتحديث حالة المصروف

Route::get('/home', [TransactionController::class, 'index'])->middleware('auth:sanctum');
Route::get('/transactions', [TransactionController::class, 'transaction'])->middleware('auth:sanctum');
Route::get('/get/transactions', TransactionController::class)->middleware('auth:sanctum');
Route::delete('/transactions/{id}', [TransactionController::class, 'destroy'])->middleware('auth:sanctum');


Route::post('/request/store', [RequestsController::class, 'store'])->middleware('auth:sanctum');
Route::get('/get/request', [RequestsController::class, 'index'])->middleware('auth:sanctum');
Route::get('/get/request/{id}', [RequestsController::class, 'getUserId'])->middleware('auth:sanctum');

// Add these routes
Route::patch('/request/{id}/approve', [RequestsController::class, 'approve'])->middleware('auth:sanctum');
Route::patch('/request/{id}/reject', [RequestsController::class, 'reject'])->middleware('auth:sanctum');

Route::post('/request/{id}/attachment', [RequestsController::class, 'updateAttachment'])->middleware('auth:sanctum');

Route::post('/change-username', [AuthController::class, 'changeUsername'])->middleware('auth:sanctum');
Route::post('/change-password', [AuthController::class, 'changePassword'])->middleware('auth:sanctum');
Route::post('/all-send', [\App\Http\Controllers\SendNotification::class, 'sendAllNotification'])->middleware('auth:sanctum');
Route::post('/customize-send', [\App\Http\Controllers\SendNotification::class, 'sendCustomNotification'])->middleware('auth:sanctum');
