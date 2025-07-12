<?php

use Illuminate\Support\Facades\Route;

Route::get("/", [\App\Http\Controllers\UserCardController::class, "generatePdf"]);

