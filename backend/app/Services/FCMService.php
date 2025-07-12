<?php

namespace App\Services;

use Illuminate\Support\Facades\Log;

class FCMService
{
    private static function getApiUrl()
    {
        $projectId = "expense-our";
        return "https://fcm.googleapis.com/v1/projects/{$projectId}/messages:send";
    }

    public static function sendToToken($token, $title, $body, $data = [], $image = null)
    {
        return self::sendMessage(["token" => $token], $title, $body, $data, $image);
    }

    public static function sendToTokens(array $tokens, $title, $body, $data = [], $image = null)
    {
        return self::sendMessage(["tokens" => $tokens], $title, $body, $data);
    }

    public static function sendToTopic($topic, $title, $body, $data = [], $image = null)
    {
        return self::sendMessage(["topic" => $topic], $title, $body, $data, $image);
    }

    private static function sendMessage(array $target, $title, $body, $data = [], $image = null)
    {
        $url = self::getApiUrl();
        $accessToken = self::getAccessToken();
        if (!$accessToken) {
            throw new \Exception("لم يتم الحصول على access token");
        }
        Log::info(array_filter([
            "title" => $title,
            "body" => $body,
            "image" => $image
        ]));
        $message = [
            "message" => array_merge($target, [
                "notification" => array_filter([
                    "title" => $title,
                    "body" => $body,
                    "image" => $image
                ]),
                "android" => [
                    "priority" => "high",
                    "notification" => [
                        "channel_id" => "high_importance_channel",
                        "icon" => "@mipmap/launcher"
                    ]
                ],
                "apns" => [
                    "headers" => [
                        "apns-priority" => "10"
                    ],
                    "payload" => [
                        "aps" => [
                            "sound" => "default",
                            "content-available" => 1
                        ]
                    ]
                ],
                "data" => is_array($data) && !empty($data) ? (array) $data : ["v" => "v"]
            ])
        ];


        $headers = [
            "Authorization: Bearer {$accessToken}",
            "Content-Type: application/json"
        ];

        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($message));

        $response = curl_exec($ch);
        curl_close($ch);

        return json_decode($response, true);
    }

    private static function getAccessToken()
    {
        $serviceAccountPath = storage_path('app/expense-our-firebase-adminsdk-fbsvc-5880e8f5a9.json');
        if (!file_exists($serviceAccountPath)) {
            return null;
        }
        $serviceAccount = json_decode(file_get_contents($serviceAccountPath), true);
        if (!$serviceAccount) {
            return null;
        }

        $header = ["alg" => "RS256", "typ" => "JWT"];
        $now = time();
        $payload = [
            "iss" => $serviceAccount['client_email'],
            "scope" => "https://www.googleapis.com/auth/firebase.messaging",
            "aud" => "https://oauth2.googleapis.com/token",
            "iat" => $now,
            "exp" => $now + 3600
        ];

        $jwt = self::generateJWT($header, $payload, $serviceAccount['private_key']);

        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, "https://oauth2.googleapis.com/token");
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query([
            "grant_type" => "urn:ietf:params:oauth:grant-type:jwt-bearer",
            "assertion" => $jwt
        ]));

        $response = curl_exec($ch);
        curl_close($ch);

        $result = json_decode($response, true);
        return $result['access_token'] ?? null;
    }

    private static function generateJWT($header, $payload, $privateKey)
    {
        $headerEncoded = rtrim(strtr(base64_encode(json_encode($header)), '+/', '-_'), '=');
        $payloadEncoded = rtrim(strtr(base64_encode(json_encode($payload)), '+/', '-_'), '=');
        $signature = '';
        openssl_sign($headerEncoded . "." . $payloadEncoded, $signature, $privateKey, OPENSSL_ALGO_SHA256);
        $signatureEncoded = rtrim(strtr(base64_encode($signature), '+/', '-_'), '=');
        return $headerEncoded . "." . $payloadEncoded . "." . $signatureEncoded;
    }
}
