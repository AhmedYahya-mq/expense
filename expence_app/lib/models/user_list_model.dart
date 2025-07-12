import 'package:party_planner/models/user.dart';

class UserListModel {
  List<UserModel>? committee;
  List<UserModel>? normal;

  UserListModel.fromJson(Map<String, dynamic> json) {
    committee = json['committee'] != null
        ? (json['committee'] as List).map((e) => UserModel.fromJson(e)).toList()
        : [];
    normal = json['normal'] != null
        ? (json['normal'] as List).map((e) => UserModel.fromJson(e)).toList()
        : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['committee'] = committee?.map((e) => e.toJson()).toList();
    data['normal'] = normal?.map((e) => e.toJson()).toList();
    return data;
  }
}
