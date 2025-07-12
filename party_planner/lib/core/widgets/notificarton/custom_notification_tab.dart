// ignore_for_file: collection_methods_unrelated_type

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:party_planner/controllers/notificartion_controller.dart';
import 'package:party_planner/models/user.dart';

class CustomNotificationTab extends StatelessWidget {
  final NotificationController controller = Get.find<NotificationController>();

  CustomNotificationTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Obx(
          () => Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Obx(
                            () => DropdownSearch<UserModel>.multiSelection(
                              key: controller.dropdownKey.value,
                              items: (f, p) => controller.users.value,
                              itemAsString: (UserModel user) =>
                                  user.getFullNameWithLastName(),
                              selectedItems: controller.users.value
                                  .where((user) => controller.selectedUsers
                                      .contains(user.id))
                                  .toList(),
                              onChanged: (selectedUsers) {
                                controller.selectedUsers.addAll(selectedUsers);
                              },
                              decoratorProps: DropDownDecoratorProps(
                                decoration: InputDecoration(
                                  labelText: "حدد المستخدمين",
                                  labelStyle: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.color,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        12), // زوايا مستديرة
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blueAccent, width: 2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  filled: true,
                                  fillColor: Theme.of(context)
                                      .cardColor, // لون الخلفية
                                ),
                              ),
                              popupProps: PopupPropsMultiSelection.dialog(
                                textDirection:
                                    TextDirection.rtl, // اتجاه النص للعربية

                                showSearchBox: true,
                                dialogProps: DialogProps(
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                searchFieldProps: TextFieldProps(
                                  decoration: InputDecoration(
                                    hintText: "ابحث عن مستخدم...",
                                    hintStyle: TextStyle(
                                      color: Theme.of(context).hintColor,
                                      fontFamily: 'Tajawal', // خط عربي
                                    ),
                                    prefixIcon: Icon(Icons.search,
                                        color:
                                            Theme.of(context).iconTheme.color),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    filled: true,
                                    fillColor: Theme.of(context).cardColor,
                                  ),
                                  textDirection:
                                      TextDirection.rtl, // اتجاه النص للعربية
                                ),
                                itemBuilder: (context, user, isSelected, ais) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 8),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Colors.blueAccent.withOpacity(0.1)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.blueAccent,
                                        child: Text(
                                          user.name![0],
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        user.getFullNameWithLastName(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                        textDirection: TextDirection
                                            .rtl, // اتجاه النص للعربية
                                      ),
                                      subtitle: Text(
                                        user.id!,
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .labelSmall
                                              ?.color,
                                        ),
                                        textDirection: TextDirection
                                            .rtl, // اتجاه النص للعربية
                                      ),
                                      trailing: isSelected
                                          ? Icon(Icons.check_circle,
                                              color: Colors.green)
                                          : null,
                                    ),
                                  );
                                },
                              ),
                              compareFn: (item1, item2) {
                                return item1.id == item2.id;
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            onChanged: (value) =>
                                controller.customTitle.value = value,
                            decoration: const InputDecoration(
                              labelText: "العنوان",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            onChanged: (value) =>
                                controller.customBody.value = value,
                            decoration: const InputDecoration(
                              labelText: "المحتوى",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () =>
                                controller.pickImage(controller.customImage),
                            child: const Text("اختيار صورة"),
                          ),
                          if (controller.customImage.value != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Image.file(controller.customImage.value!,
                                  height: 100),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      controller.sendCustomNotification();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                    ),
                    child: const Text("إرسال إشعار عام"),
                  ),
                ],
              ),
            ),
          ),
        ),
        Obx(() {
          if (controller.isLoadingCustom.value ||
              controller.isLoadingCustom.value) {
            return Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }
}
