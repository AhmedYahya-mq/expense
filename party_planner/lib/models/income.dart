import 'package:party_planner/models/user.dart';

class Income {
  UserModel? recipient;
  String? supporterName;
  String? deductedAmount;
  String? timeAgo;
  String? formatDate;
  String? createdAt;
  String? updatedAt;
  String? id;

  Income({
    this.recipient,
    this.supporterName,
    this.deductedAmount,
    this.timeAgo,
    this.createdAt,
    this.updatedAt,
    this.id,
  });

  Income.fromJson(Map<String, dynamic> json) {
    recipient = json['recipient'] != null
        ? UserModel.fromJson(json['recipient'])
        : null;
    supporterName = json['supporter_name'];
    deductedAmount = json['deducted_amount'].toString();
    timeAgo = json['time_ago'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    formatDate = json['formatDate'];
    id = json['id'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (recipient != null) {
      data['recipient'] = recipient!.toJson();
    }
    data['supporter_name'] = supporterName;
    data['deducted_amount'] = deductedAmount;
    data['time_ago'] = timeAgo;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['formatDate'] = formatDate;
    data['id'] = id;
    return data;
  }
}
