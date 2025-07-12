import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:party_planner/controller/users_form_controller.dart';
import 'package:party_planner/core/widgets/header.dart';
import 'package:party_planner/core/widgets/student_item.dart';
import 'package:party_planner/view/forms/user_form_screen.dart';

class UsersForm extends StatelessWidget {
  const UsersForm({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final controller = Get.put(UsersFormController());

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => UserFormScreen());
        },
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 30, bottom: 10, left: 10, right: 10),
          child: Column(
            children: [
              Header(theme: theme, title: "المستخدمين"),
              const SizedBox(height: 25),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value &&
                      controller.students.isEmpty) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (scrollInfo.metrics.pixels ==
                                scrollInfo.metrics.maxScrollExtent &&
                            !controller.isLoading.value) {
                          controller.loadMoreStudents();
                        }
                        return true;
                      },
                      child: Stack(
                        children: [
                          ListView.builder(
                            itemCount: controller.students.length + 1,
                            itemBuilder: (context, index) {
                              if (index == controller.students.length) {
                                return controller.isLoading.value
                                    ? Center(child: CircularProgressIndicator())
                                    : SizedBox.shrink();
                              }
                              final student = controller.students[index];
                              return Dismissible(
                                key: Key(student.id ?? ''),
                                confirmDismiss: (direction) async {
                                  bool confirm = await controller
                                      .confirmDeleteStudent(index);
                                  if (!confirm) {
                                    return false;
                                  }
                                  confirm =
                                      await controller.removeStudent(index);
                                  return confirm;
                                },
                                child: StudentItem(
                                  user: student,
                                  onDismissed: () =>
                                      controller.confirmDeleteStudent(index),
                                ),
                              );
                            },
                          ),
                          if (controller.isDeleting.value)
                            Center(
                              child: CircularProgressIndicator(),
                            ),
                        ],
                      ),
                    );
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
