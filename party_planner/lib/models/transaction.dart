import 'package:party_planner/enums/transaction_category.dart';
import 'package:party_planner/models/expense.dart';
import 'package:party_planner/models/income.dart';
import 'package:party_planner/models/user.dart';

class Transaction {
  String? id;
  String? amount;
  String? description;
  String? timeAgo;
  String? createdAt;
  String? updatedAt;
  TransactionCategory? category;
  String? attachment;
  UserModel? user;
  String? transactionType;
  dynamic _transaction;

  bool get isIncome => transactionType == 'income';

  Income get income => (_transaction as Income);
  Expense get expense => (_transaction);
  set transaction(dynamic value) => _transaction = value;

  Transaction({
    this.id,
    this.amount,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.category,
    this.attachment,
    this.user,
    this.transactionType,
  });

  Transaction.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    amount = json['amount'].toString();
    description = json['description'];
    
    timeAgo = json['time_ago'];
    createdAt = json['formatDate'];

    updatedAt = json['updated_at'];
    category = TransactionCategory.values.firstWhere(
            (e) => e.toString() == "TransactionCategory.${json['category']}",
            orElse: () => TransactionCategory.transportation)
        as TransactionCategory?;
    attachment = json['attachment'];
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
    transactionType = json['transaction_type'];
    transaction = transactionType == 'income'
        ? json['transaction'] != null
            ? Income.fromJson(json['transaction'])
            : null
        : json['transaction'] != null
            ? Expense.fromJson(json['transaction'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['description'] = description;
    data['category'] = category?.toString().split('.').last;
    data['attachment'] = attachment;
    data['transaction_type'] = transactionType;
    
    
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (_transaction != null) {
      data['transaction'] =
          transactionType == 'income' ? income.toJson() : expense.toJson();
    }
    return data;
  }
}
