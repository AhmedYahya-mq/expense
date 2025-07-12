import 'package:flutter/material.dart';

// ignore_for_file: constant_identifier_names

enum Role {
  head_of_preparatory_committee,
  head_of_financial_committee,
  head_of_relations_committee,
  head_of_technical_committee,
  head_of_supervisory_committee,
  head_of_media_committee,
  normal,
}

extension RoleExtension on Role {
  String get description {
    switch (this) {
      case Role.head_of_preparatory_committee:
        return 'رئيس اللجان';
      case Role.head_of_financial_committee:
        return 'اللجنة المالية';
      case Role.head_of_relations_committee:
        return 'لجنة العلاقات';
      case Role.head_of_technical_committee:
        return 'اللجنة الفنية';
      case Role.head_of_supervisory_committee:
        return 'اللجنة الرقابية';
      case Role.head_of_media_committee:
        return 'اللجنة الإعلامية';
      case Role.normal:
        return 'عادي';
    }
  }

  IconData get icon {
    switch (this) {
      case Role.head_of_preparatory_committee:
        return Icons.supervisor_account; // أيقونة الفريق
      case Role.head_of_financial_committee:
        return Icons.account_balance; // أيقونة المالية
      case Role.head_of_relations_committee:
        return Icons.handshake; // أيقونة العلاقات
      case Role.head_of_technical_committee:
        return Icons.build; // أيقونة التقنية
      case Role.head_of_supervisory_committee:
        return Icons.shield; // أيقونة الإشراف
      case Role.head_of_media_committee:
        return Icons.camera_alt; // أيقونة الإعلام
      case Role.normal:
        return Icons.person; // أيقونة الشخص العادي
    }
  }
}
