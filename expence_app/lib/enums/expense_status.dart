import 'package:flutter/material.dart';

// ignore_for_file: constant_identifier_names

enum ExpenseStatus {
  pending,
  approved_by_management,
  paid,
}

extension ExpenseStatusExtension on ExpenseStatus {
  String get description {
    switch (this) {
      case ExpenseStatus.pending:
        return 'قيد الانتظار';
      case ExpenseStatus.approved_by_management:
        return 'موافقة الإدارة';
      case ExpenseStatus.paid:
        return 'مدفوع';
    }
  }

  IconData get icon {
    switch (this) {
      case ExpenseStatus.pending:
        return Icons.hourglass_empty; // رمز الانتظار
      case ExpenseStatus.approved_by_management:
        return Icons.check_circle_outline; // رمز الموافقة
      case ExpenseStatus.paid:
        return Icons.payment; // رمز الدفع
    }
  }

  Color get color {
    switch (this) {
      case ExpenseStatus.pending:
        return Colors.orange; // اللون البرتقالي
      case ExpenseStatus.approved_by_management:
        return Colors.green; // اللون الأخضر
      case ExpenseStatus.paid:
        return Colors.blue; // اللون الأزرق
    }
  }
}
