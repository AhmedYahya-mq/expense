// ignore_for_file: non_constant_identifier_names

import 'package:party_planner/enums/role.dart';

class UserModel {
  String? id;
  String? name;
  Role? role;
  String? balance;
  String? total_due_amount;
  String? remaining_amount;
  String? percent_remaining_amount;
  String? percent_balance;
  String? image;
  String? _username;
  String? token;

  String? get username => _username;

  set username(String? value) {
    _username = value;
    UserModel._username1 = value;
  }

  String? _password;

  String? get password => _password;

  set password(String? value) {
    _password = value;
    UserModel._password1 = value;
  }

  static String? _username1;
  static String? _password1;

  UserModel({this.name, this.role, this.balance, this.image});

  UserModel.fromJson(Map<String, dynamic> json) {
    var user = json['user'] ?? json;
    id = user['id'];
    name = user['name'] ?? "";
    role = Role.values.firstWhere(
        (e) => e.toString() == "Role.${user['role'] ?? "normal"}",
        orElse: () => Role.normal) as Role?;
    balance = user['balance'].toString();
    image = user['image'] ?? "";
    balance = user['balance'].toString();
    total_due_amount = user['total_due_amount'].toString();
    remaining_amount = user['remaining_amount'].toString();
    percent_remaining_amount = user['percent_remaining_amount'].toString();
    percent_balance = user['percent_balance'].toString();

    username = UserModel._username1 ?? json['username'];
    password = UserModel._password1 ?? "";

    if (json['token'] != null) {
      token = json['token']!;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['username'] = username;
    data['password'] = password;
    data['role'] = role?.toString().split('.').last;
    data['balance'] = balance;
    data['image'] = image;
    return data;
  }

  String getFullNameWithLastName() {
    List<String> names = name!.split(' ');
    if (names.length >= 2) {
      String firstName = names[0];
      String secondName = names[1];
      String lastName = names.last;
      return '$firstName $secondName $lastName';
    } else {
      return name!;
    }
  }
}
