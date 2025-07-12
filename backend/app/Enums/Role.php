<?php

namespace App\Enums;

use BenSampo\Enum\Enum;

final class Role extends Enum
{
    const HEAD_OF_PREPARATORY_COMMITTEE = 'head_of_preparatory_committee';
    const HEAD_OF_FINANCIAL_COMMITTEE = 'head_of_financial_committee';
    const HEAD_OF_RELATIONS_COMMITTEE = 'head_of_relations_committee';
    const HEAD_OF_TECHNICAL_COMMITTEE = 'head_of_technical_committee';
    const HEAD_OF_SUPERVISORY_COMMITTEE = 'head_of_supervisory_committee';
    const HEAD_OF_MEDIA_COMMITTEE = 'head_of_media_committee';
    const NORMAL = 'normal';

    public static function getDescription($value): string
    {
        switch ($value) {
            case self::HEAD_OF_PREPARATORY_COMMITTEE:
                return 'رئيس اللجنة التحضيرية';
            case self::HEAD_OF_FINANCIAL_COMMITTEE:
                return 'رئيس اللجنة المالية';
            case self::HEAD_OF_RELATIONS_COMMITTEE:
                return 'رئيس لجنة العلاقات';
            case self::HEAD_OF_TECHNICAL_COMMITTEE:
                return 'رئيس اللجنة الفنية';
            case self::HEAD_OF_SUPERVISORY_COMMITTEE:
                return 'رئيس اللجنة الرقابية';
            case self::HEAD_OF_MEDIA_COMMITTEE:
                return 'رئيس اللجنة الإعلامية';
            case self::NORMAL:
                return 'عادي';
            default:
                return self::getKey($value);
        }
    }
}
