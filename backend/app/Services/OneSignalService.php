<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;

class OneSignalService
{
    private static function getApiUrl()
    {
        return "https://onesignal.com/api/v1/notifications";
    }

    private static function getAppId()
    {
        return "56c5704f-f106-4478-8fad-2ff1a3346bc3";
    }

    private static function getApiKey()
    {
        return env('ONESIGNAL_API_KEY', "os_v2_app_k3cxat7razchrd5nf7y2gndlymrm53d63liedefm5xhdtlope5kukrm6y44l2l76yytkwqq7knzftwwv6ir4xe3al2265qdcthxyqcq");
    }

    public static function sendToToken($token, $title, $body, $data = [])
    {
        return self::sendMessage([
            "include_player_ids" => [$token]
        ], $title, $body, $data);
    }

    public static function sendToTokens(array $tokens, $title, $body, $data = [])
    {
        return self::sendMessage([
            "include_player_ids" => $tokens
        ], $title, $body, $data);
    }

    public static function sendToSegment($segment, $title, $body, $data = [])
    {
        return self::sendMessage([
            "included_segments" => [$segment]
        ], $title, $body, $data);
    }

    private static function sendMessage(array $target, $title, $body, $data = [])
    {
        $url = self::getApiUrl();
        $appId = self::getAppId();
        $apiKey = self::getApiKey();

        if (!$apiKey || !$appId) {
            return ["error" => "لم يتم العثور على API Key أو App ID"];
        }

        $message = array_merge($target, [
            "app_id" => $appId,
            "headings" => ["en" => $title],
            "contents" => ["en" => $body],
            "data" => $data,
            "priority" => 10,
        ]);

        $response = Http::withHeaders([
            "Authorization" => "Basic {$apiKey}",
            "Content-Type" => "application/json"
        ])->post($url, $message);

        return $response->json();
    }
}
