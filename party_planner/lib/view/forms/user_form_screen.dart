import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:party_planner/controller/users_form_controller.dart';
import 'package:party_planner/core/widgets/custom_pass_field.dart';
import 'package:party_planner/enums/role.dart';

class UserFormScreen extends StatelessWidget {
  final UsersFormController controller = Get.put(UsersFormController());
  UserFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("إضافة مستخدم جديد"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                onChanged: controller.setName,
                decoration: InputDecoration(
                  labelText: "اسم الطالب",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                onChanged: controller.setUserName,
                decoration: InputDecoration(
                  labelText: "اسم المستخدم",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<Role>(
                value: controller.userSession.value.role,
                onChanged: (Role? newRole) {
                  if (newRole != null) {
                    controller.setUserRole(newRole);
                  }
                },
                decoration: InputDecoration(
                  labelText: "دور المستخدم",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: Role.values.map((Role role) {
                  return DropdownMenuItem<Role>(
                    value: role,
                    child: Row(
                      children: [
                        Icon(role.icon, color: theme.primaryColor),
                        SizedBox(width: 8),
                        Text(role.description),
                      ],
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              CustomPasswordField(
                hintText: "كلمة السر",
                onChanged: controller.setPassword,
                toggleObscureText: controller.toggleObscureText,
                obscureText: controller.obscureText.value,
              ),
              SizedBox(height: 20),
              Obx(() {
                return controller.isLoading.value
                    ? CircularProgressIndicator()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              controller.isLoading.value = true;
                              bool success = await controller.saveUser();
                              controller.isLoading.value = false;
                              if (success) {
                                Navigator.pop(context);
                              }
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.green)),
                            child: Text(
                              "حفظ",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          TextButton(
                            onPressed: () => Get.back(),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.red)),
                            child: Text("إلغاء",
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      );
              }),
            ],
          ),
        ),
      ),
    );
  }
}