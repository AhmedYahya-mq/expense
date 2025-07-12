<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\Log;

class LogMessage extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'log:message';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Log a message every minute';

    public function __construct()
    {
        parent::__construct();
    }

    /**
     * Execute the console command.
     *
     * @return int
     */
    public function handle()
    {
        Log::info('🚀 تم تشغيل المهمة المجدولة!');
        return 0;
    }
}
