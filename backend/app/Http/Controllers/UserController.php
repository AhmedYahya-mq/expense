<?php

namespace App\Http\Controllers;

use App\Helpers\ImageHelper;
use App\Http\Resources\UserResource;
use App\Http\Resources\UserRoleResource;
use App\Models\User;
use App\Services\FCMService;
use App\Services\FirebaseService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log; // Add this line

class UserController extends Controller
{

    // protected $firebaseService;

    // public function __construct(FirebaseService $firebaseService)
    // {
    //     $this->firebaseService = $firebaseService;
    // }

    // public function sendTestNotification()
    // {
    //     $token = "cG064c59RLap7CUgVBJfWS:APA91bFSFoFmCp_pFQQU-F2oB8KK28Q0pGf4cl20ax5o2_cHV1Cw3AaBXjgjAQMaayKSWLSBbEzxRyKRPt7QRkaIit2O04EiiSFkV_mvaFHmB4cSmBMFkhs"; // توكن الجهاز المستهدف
    //     $title = "إشعار جديد";
    //     $body = "هذا هو محتوى الإشعار";
    //     $data = ["key1" => "value1", "key2" => "value2"];

    //     $response = $this->firebaseService->sendNotification($token, $title, $body, $data);

    //     return response()->json($response);
    // }

    public function getUserRole()
    {
        try {
            $users = User::getUsersByRole();
            return new UserRoleResource($users);
        } catch (\Exception $e) {
            Log::error('خطأ في جلب دور المستخدم: ' . $e->getMessage());
            return response()->json(['message' => 'حدث خطأ أثناء جلب دور المستخدم'], 500);
        }
    }

    // change image profile
    public function changeImageProfile(Request $request)
    {
        try {
            $user = auth()->user();
            if ($request->hasFile('image')) {
                if ($user->image != null) {
                    ImageHelper::deleteImage($user->image);
                }
                $image = $request->file('image');
                $imageName = ImageHelper::storeSingleImage($image, 'users', disk: 'public');
                $user->image = $imageName;
                $user->save();
                return new UserResource($user);
            }
            Log::info('الرجاء تحديد صورة');
            return response()->json(['message' => 'الرجاء تحديد صورة'], 400);
        } catch (\Exception $e) {
            Log::error('خطأ في تغيير الصورة الشخصية: ' . $e->getMessage());
            return response()->json(['message' => 'حدث خطأ أثناء تغيير الصورة الشخصية'], 500);
        }
    }


}
