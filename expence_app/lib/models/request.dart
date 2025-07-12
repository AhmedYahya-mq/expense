import 'package:party_planner/enums/expense_status.dart';
import 'package:party_planner/enums/transaction_category.dart';
import 'package:party_planner/models/expense.dart';
import 'package:party_planner/models/user.dart';

class Request {
  final int id;
  final int userId;
  final UserModel? user;
  final TransactionCategory category;
  final String amount;
  final String description;
  final String? attachment;
  final ExpenseStatus status;
  final bool isDeclined;
  final Expense? expense;
  final String? rejectionReason;
  final DateTime createdAt;

  Request({
    required this.id,
    required this.userId,
    this.user,
    required this.category,
    required this.amount,
    required this.description,
    this.attachment,
    required this.status,
    required this.isDeclined,
    this.expense,
    this.rejectionReason,
    required this.createdAt,
  });

  /// **تحويل JSON إلى `RequestModel`**
  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      id: json['id'],
      userId: json['user_id'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      category: TransactionCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => TransactionCategory.miscellaneous, // قيمة افتراضية
      ),
      amount: json['amount'],
      description: json['description'] ?? "",
      attachment: json['attachment'],
      status: ExpenseStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ExpenseStatus.pending, // قيمة افتراضية
      ),
      isDeclined: json['is_declined'] ?? false,
      expense:
          json['expense'] != null ? Expense.fromJson(json['expense']) : null,
      rejectionReason: json['rejection_reason'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  /// **تحويل `RequestModel` إلى JSON**
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'user': user?.toJson(),
      'category': category.name,
      'amount': amount,
      'description': description,
      'attachment': attachment,
      'status': status.name,
      'is_declined': isDeclined,
      'expense': expense?.toJson(),
      'rejection_reason': rejectionReason,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// **إنشاء نسخة معدلة من الكائن**
  Request copyWith({
    int? id,
    int? userId,
    UserModel? user,
    TransactionCategory? category,
    String? amount,
    String? description,
    String? attachment,
    ExpenseStatus? status,
    bool? isDeclined,
    Expense? expense,
    String? rejectionReason,
    DateTime? createdAt,
  }) {
    return Request(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      user: user ?? this.user,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      attachment: attachment ?? this.attachment,
      status: status ?? this.status,
      isDeclined: isDeclined ?? this.isDeclined,
      expense: expense ?? this.expense,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
