import 'package:party_planner/enums/role.dart';
import 'package:party_planner/models/user.dart';

class Expense {
  String? id;
  String? committee;
  Role? committee_label;
  String? destination;
  String? method;
  String? purpose;
  UserModel? paidBy;
  UserModel? approvedBy;
  String? timeAgo;
  String? createdAt;

  Expense({
    this.id,
    this.committee,
    this.destination,
    this.purpose,
    this.paidBy,
    this.approvedBy,
    this.timeAgo,
    this.createdAt,
  });

  Expense.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    committee = json['committee'] ?? "";
    committee_label = Role.values.firstWhere(
      (e) => e.name == json['committee'],
      orElse: () => Role.head_of_financial_committee, // قيمة افتراضية
    );
    destination = json['destination'] ?? "";
    method = json['method'] ?? "";
    purpose = json['purpose'] ?? "";
    paidBy =
        json['paid_by'] != null ? UserModel.fromJson(json['paid_by']) : null;
    approvedBy = json['approved_by'] != null
        ? UserModel.fromJson(json['approved_by'])
        : null;
    timeAgo = json['time_ago'] ?? "";
    createdAt = json['created_at'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['committee'] = committee;
    data['destination'] = destination;
    data['purpose'] = purpose;

    if (paidBy != null) {
      data['paid_by'] = paidBy!.toJson();
    }

    if (approvedBy != null) {
      data['approved_by'] = approvedBy!.toJson();
    }

    data['time_ago'] = timeAgo;
    data['created_at'] = createdAt;
    return data;
  }
}
