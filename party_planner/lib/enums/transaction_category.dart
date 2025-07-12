import 'package:flutter/material.dart';

// ignore_for_file: constant_identifier_names

enum TransactionCategory {
  miscellaneous,
  transportation,
  services,
  rent_assets,
  purchases,
  students,
  support,
}

extension TransactionCategoryExtension on TransactionCategory {
  String get description {
    switch (this) {
      case TransactionCategory.miscellaneous:
        return 'نثريات';
      case TransactionCategory.transportation:
        return 'مواصلات';
      case TransactionCategory.services:
        return 'خدمات';
      case TransactionCategory.rent_assets:
        return 'أصول إيجار';
      case TransactionCategory.purchases:
        return 'مشتريات';
      case TransactionCategory.students:
        return 'طلاب';
      case TransactionCategory.support:
        return 'دعم';
    }
  }

  IconData get icon {
    switch (this) {
      case TransactionCategory.miscellaneous:
        return Icons.receipt_long; // أيقونة النثريات
      case TransactionCategory.transportation:
        return Icons.directions_car; // أيقونة المواصلات
      case TransactionCategory.services:
        return Icons.miscellaneous_services_sharp; // أيقونة الخدمات
      case TransactionCategory.rent_assets:
        return Icons.apartment  ; // أيقونة أصول الإيجار
      case TransactionCategory.purchases:
        return Icons.shopping_cart; // أيقونة المشتريات
      case TransactionCategory.students:
        return Icons.people_alt; // أيقونة الطلاب
      case TransactionCategory.support:
        return Icons.volunteer_activism; // أيقونة الدعم
    }
  }
}
