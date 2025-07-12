<?php

namespace App\Http\Controllers;

use App\Helpers\ImageHelper;
use App\Http\Requests\NotificationRequest;
use App\Http\Requests\NotificationUserRequest;
use App\Models\User;
use App\Services\FCMService;
use Illuminate\Support\Facades\Log;

class SendNotification extends Controller
{
    public function sendAllNotification(NotificationRequest $request)
    {

        try {
            $path = null;
            Log::info($request->file('image'));
            if ($request->hasFile('image')) {
                $path = ImageHelper::storeSingleImage($request->file('image'), 'notifications', disk: 'public');
            }
            $title = $request->title;
            $body = $request->body;
            // path to the image asset storage
            $image = $path != null ? asset('storage/' . $path) : null;
            $topicId = "all_users";

            $response = FCMService::sendToTopic($topicId, $title, $body, image: $image);
            Log::info($response);
            if ($response == null) {
                throw new \Exception('Failed to send notification');
            }
            return response()->json([$response, 'message' => 'تم إرسال الإشعار بنجاح']);
        } catch (\Exception $e) {
            Log::error($e->getMessage());
            return response()->json(['message' => 'Failed to send notification', 'message' => $e->getMessage()], 500);
        }
    }


    public function sendCustomNotification(NotificationUserRequest $request)
    {
        $path = null;
        Log::info($request->file('image'));
        if ($request->hasFile('image')) {
            $path = ImageHelper::storeSingleImage($request->file('image'), 'notifications', disk: 'public');
        }
        $title = $request->title;
        $body = $request->body;
        $image = $path != null ? asset('storage/' . $path) : null;
        $successful = 0;
        $failed = 0;
        $users = User::find($request->users);
        foreach ($users as  $user) {
            if ($user->fcm_token == null) {
                Log::warning("⚠️ المستخدم ID: {$user->fcm_token} ليس لديه `fcm_token`، تم التجاوز.");
                $failed++;
                continue;
            }
            $response = FCMService::sendToToken($user->fcm_token, $title, $body, image: $image);

            if ($response && (!isset($response['error']) || $response['error'] === null)) {
                $successful++;
            } else {
                $failed++;
            }
        }
        Log::info("✅ إشعارات ناجحة: $successful | ❌ فشل: $failed");

        return response()->json([
            'message' => "✅ تم إرسال الإشعارات بنجاح: $successful | ❌ فشل: $failed",
            'successful' => $successful,
            'failed' => $failed
        ]);
    }
}
