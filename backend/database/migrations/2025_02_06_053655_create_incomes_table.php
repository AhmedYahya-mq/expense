<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        // إنشاء جدول incomes
        Schema::create('incomes', function (Blueprint $table) {
            $table->id()->startingValue(2026000);
            $table->integer('recipient_id')->constrained('users')->onDelete('cascade');
            $table->string('supporter_name')->nullable();
            $table->foreignId('transaction_id')->constrained('transactions')->onDelete('cascade');
            $table->integer('deducted_amount')->nullable();

            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        // حذف جدول incomes
        Schema::dropIfExists('incomes');
    }
};
