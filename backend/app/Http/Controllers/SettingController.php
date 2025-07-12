<?php

namespace App\Http\Controllers;

use App\Models\Setting;
use Illuminate\Http\Request;
use App\Http\Resources\SettingResource;
use App\Http\Requests\SettingRequest;
use Illuminate\Support\Facades\Log;

class SettingController extends Controller
{
    public function index()
    {
        try {
            return SettingResource::collection(Setting::allSettings());
        } catch (\Exception $e) {
            Log::error('خطأ في جلب الإعدادات: ' . $e->getMessage());
            return response()->json(['message' => 'حدث خطأ أثناء جلب الإعدادات'], 500);
        }
    }

    public function store(SettingRequest $request)
    {
        try {
            return SettingResource::collection(Setting::setArray($request->settings));
        } catch (\Exception $e) {
            Log::error('خطأ في تخزين الإعدادات: ' . $e->getMessage());
            return response()->json(['message' => 'حدث خطأ أثناء تخزين الإعدادات'], 500);
        }
    }
}
