import 'package:flutter/material.dart';
import 'package:party_planner/models/user.dart';

class StudentItem extends StatelessWidget {
  final UserModel user;
  final VoidCallback onDismissed;

  const StudentItem({
    super.key,
    required this.user,
    required this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: (user.image != null && user.image!.isNotEmpty)
              ? NetworkImage(user.image!)
              : AssetImage("assets/avatar.png") as ImageProvider,
        ),
        title: Text(
          user.name!,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('رقم الطالب: ${user.id}'),
      ),
    );
  }
}
