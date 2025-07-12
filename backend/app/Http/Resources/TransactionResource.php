<?php

namespace App\Http\Resources;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class TransactionResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $transaction = $this->transaction_type === 'income' ? new IncomeResource($this->income) : new ExpenseResource($this->expense);
        return [
            'id' => $this->id,
            'amount' => number_format($this->amount, 0, '.', ','),
            'transaction_type' => $this->transaction_type,
            'category' => $this->category,
            'description' => $this->description,
            'attachment' => ($this->attachment && !empty($this->attachment)) ? asset('storage/' . $this->attachment) : null,
            'user' => new UserResource($this->user),
            'transaction' => $transaction,
            'time_ago' => $this->created_at->diffForHumans(),
            'formatDate' => $this->created_at->locale('ar')->translatedFormat('Y-F-d'),
        ];
    }
}
