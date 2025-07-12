<?php

namespace App\Enums;

use BenSampo\Enum\Enum;

final class ExpenseStatus extends Enum
{
    const PENDING = 'pending';
    const APPROVED_BY_MANAGEMENT = 'approved_by_management';
    const PAID = 'paid';

    public static function getDescription($value): string
    {
        switch ($value) {
            case self::PENDING:
                return 'قيد الانتظار';
            case self::APPROVED_BY_MANAGEMENT:
                return 'موافقة الإدارة';
            case self::PAID:
                return 'مدفوع';
            default:
                return self::getKey($value);
        }
    }
}
