<?php

namespace App\Helpers;

use Illuminate\Support\Facades\Storage;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Str;

class ImageHelper
{
    // تخزين صورة واحدة في المجلد المحدد
    public static function storeSingleImage(UploadedFile $image, $folder = 'images', $start = null, $imageName = null, $disk = 'local')
    {
        if ($image->isValid()) {
            $imageName = $imageName ?: Str::random(40) . '.' . $image->getClientOriginalExtension();
            if (!is_null($start)) {
                $imageName = $start . '_' . Str::random(40) . '.' . $image->getClientOriginalExtension();
            }

            if (!Storage::disk($disk)->exists($folder)) {
                Storage::disk($disk)->makeDirectory($folder);
            }

            $path = $image->storeAs($folder, $imageName, $disk);

            return $path;
        }

        return null;
    }

    // تخزين مجموعة من الصور في المجلد المحدد
    public static function storeMultipleImages(array $images, $folder = 'images')
    {
        $paths = [];

        foreach ($images as $image) {
            if ($image instanceof UploadedFile && $image->isValid()) {
                $paths[] = self::storeSingleImage($image, $folder);
            }
        }

        return $paths;
    }

    // حذف صورة من الـ Storage
    public static function deleteImage($imagePath)
    {
        if (Storage::exists($imagePath)) {
            return Storage::delete($imagePath);
        }

        return false;
    }

    // حذف الصورة والمجلد إذا كان فارغًا
    public static function deleteImageAndFolder($imagePath)
    {
        if (!Storage::disk('public')->exists($imagePath)) {
            return false;
        }
        if (Storage::disk('public')->delete($imagePath)) {
            $folderPath = dirname($imagePath);
            if (empty(Storage::disk('public')->files($folderPath))) {
                Storage::disk('public')->deleteDirectory($folderPath);
            }
            return true;
        }
        return false;
    }

    // نقل الصورة إلى المجلد العام
    public static function moveToPublic($path, $start = null, $folder = 'images', $imageName = null, $isDelete = true)
    {
        $imageName = $imageName ?: Str::random(40) . '.' . pathinfo($path, PATHINFO_EXTENSION);
        if (!is_null($start)) {
            $imageName = $start . '_' . Str::random(40) . '.' . pathinfo($path, PATHINFO_EXTENSION);
        }

        $privatePath = $path;
        $publicPath = "/{$folder}/{$imageName}";
        if (Storage::disk('local')->exists($privatePath)) {
            $imageContents = Storage::disk('local')->get($privatePath);
            Storage::disk('public')->put($publicPath, $imageContents);
            if ($isDelete) {
                Storage::disk('local')->delete($privatePath);
            }
            return $publicPath;
        }

        return null;
    }
}
