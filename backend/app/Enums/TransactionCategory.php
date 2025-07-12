<?php

namespace App\Enums;

use BenSampo\Enum\Enum;

final class TransactionCategory extends Enum
{
    const MISCELLANEOUS = 'miscellaneous'; // تأكد من وجود هذه القيمة
    const TRANSPORTATION = 'transportation';
    const SERVICES = 'services';
    const RENT_ASSETS = 'rent_assets';
    const PURCHASES = 'purchases';
    const STUDENTS = 'students';
    const SUPPORT = 'support';

    public static function getDescription($value): string
    {
        switch ($value) {
            case self::MISCELLANEOUS:
                return 'نثريات';
            case self::TRANSPORTATION:
                return 'مواصلات';
            case self::SERVICES:
                return 'خدمات';
            case self::RENT_ASSETS:
                return 'أصول إيجار';
            case self::PURCHASES:
                return 'مشتريات';
            case self::STUDENTS:
                return 'طلاب';
            case self::SUPPORT:
                return 'دعم';
            default:
                return self::getKey($value);
        }
    }
}
