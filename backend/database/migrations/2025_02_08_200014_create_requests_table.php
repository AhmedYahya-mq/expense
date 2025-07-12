<?php

use App\Enums\TransactionCategory;
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use App\Enums\ExpenseStatus;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('requests', function (Blueprint $table) {
            $table->id()->startingValue(2026000);
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
            $table->enum('category', TransactionCategory::getValues());
            $table->integer('amount');
            $table->string('description')->nullable();
            $table->string('attachment')->nullable();
            $table->enum('status', ExpenseStatus::getValues())
            ->default(ExpenseStatus::PENDING);
            $table->boolean('is_declined')->default(false);
            $table->foreignId('expense_id')->constrained('expenses')->onDelete('cascade');
            $table->text('rejection_reason')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('requests');
    }
};
