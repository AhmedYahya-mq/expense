<?php

namespace App\Models;

use Illuminate\Support\Facades\Log;
use Illuminate\Database\Eloquent\Model;

class Setting extends Model
{
    protected $fillable = ['key', 'value'];

    public static function get($key)
    {
        return static::where('key', $key)->value('value');
    }

    public static function set($key, $value)
    {
        return static::updateOrCreate(['key' => $key], ['value' => $value]);
    }

    public static function setArray(array $data)
    {
        foreach ($data as  $item) {
            static::updateOrInsert(['key' => $item['key']], ['value' => $item['value']]);
        }
        return static::all();
    }


    public static function forget($key)
    {
        return static::where('key', $key)->delete();
    }

    public static function has($key)
    {
        return static::where('key', $key)->exists();
    }

    public static function allSettings()
    {
        return static::all();
    }
}
