<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ExpenseResource extends JsonResource
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
            'committee' => $this->committee,
            'purpose' => $this->purpose,
            'destination' => $this->destination,
            'method' => $this->method,
            'paid_by' => new UserResource($this->paidBy),
            'approved_by' => new UserResource($this->approvedBy),
            'time_ago' => $this->created_at->diffForHumans(),
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
        ];
    }
}
