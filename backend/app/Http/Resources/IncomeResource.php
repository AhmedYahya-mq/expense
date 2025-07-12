<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class IncomeResource extends JsonResource
{
    // تحويل البيانات إلى مصفوفة
    public function toArray($request): array
    {
        return [
            'id' => $this->id,
            'recipient' => new UserResource($this->recipient),
            'supporter_name' => $this->supporter_name,
            'deducted_amount' => number_format($this->deducted_amount, 0, '.', ','),
            'time_ago' => $this->created_at->diffForHumans(),
            'formatDate' => $this->created_at->locale('ar')->translatedFormat('Y-F-d'),
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
        ];
    }
}
