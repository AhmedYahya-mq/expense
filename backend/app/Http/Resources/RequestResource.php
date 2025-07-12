<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class RequestResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'user_id' => $this->user_id,
            'category' => $this->category,
            'amount' => number_format($this->amount, 0, '.', ','),
            'description' => $this->description,
            'attachment' => ($this->attachment && !empty($this->attachment)) ? asset('storage/' . $this->attachment) : null,
            'status' => $this->status,
            'is_declined' => $this->is_declined,
            'expense' => new ExpenseResource($this->expense),
            'user' => new UserResource($this->user),
            'rejection_reason' => $this->rejection_reason,
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
        ];
    }
}
