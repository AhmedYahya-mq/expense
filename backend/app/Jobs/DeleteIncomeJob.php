<?php

namespace App\Jobs;

use App\Models\Income;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;

class DeleteIncomeJob implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    protected $incomeId;

    /**
     * Create a new job instance.
     */
    public function __construct($incomeId)
    {
        $this->incomeId = $incomeId;
    }

    /**
     * Execute the job.
     */
    public function handle(): void
    {
        $income = Income::find($this->incomeId);

        if ($income) {
            $income->delete();
        }
    }
}
