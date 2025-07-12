import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:party_planner/controllers/income_form_controller.dart';
import 'package:party_planner/core/utils/image_compressor.dart';
import 'package:party_planner/core/utils/permissions_helper.dart';
import 'package:party_planner/models/user.dart';
import 'package:permission_handler/permission_handler.dart';

class IncomeFormScreen extends StatelessWidget {
  const IncomeFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<IncomeFormController>();

    return Scaffold(
      appBar: AppBar(
        title: Text("تسجيل دخل"),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DefaultTabController(
              length: 2,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TabBar(
                      indicatorColor: Colors.blueAccent,
                      tabs: const [
                        Tab(text: "من الطلاب"),
                        Tab(text: "من الداعمين"),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.77,
                      child: TabBarView(
                        children: [
                          _buildStudentIncomeForm(controller, context),
                          _buildSupporterIncomeForm(controller, context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Obx(() {
            if (controller.isLoading.value) {
              return Container(
                color: Colors.black.withOpacity(0.5),
                width: double.infinity,
                height: double.infinity,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return SizedBox.shrink();
            }
          }),
        ],
      ),
    );
  }

  Widget _buildStudentIncomeForm(IncomeFormController controller, context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Obx(() {
                    return Column(
                      children: [
                        studentDropdown(
                          context: context,
                          userList: controller.mergedList,
                          selectedUser: controller.student.value,
                          onChanged: (UserModel? newValue) {
                            controller.setSelectStudent(newValue!);
                          },
                          label: "أختر الطالب",
                        ),
                        if (controller.studentError.value.isNotEmpty)
                          Text(
                            controller.studentError.value,
                            style: TextStyle(color: Colors.red),
                          ),
                      ],
                    );
                  }),
                  SizedBox(height: 20),
                  Obx(() {
                    return Column(
                      children: [
                        studentDropdown(
                          context: context,
                          userList: controller.committee,
                          selectedUser: controller.selectCommittee.value,
                          onChanged: (UserModel? newValue) {
                            controller.setSelectCommittee(newValue!);
                          },
                          label: "أختر المستلم",
                        ),
                        if (controller.selectCommitteeError.value.isNotEmpty)
                          Text(
                            controller.selectCommitteeError.value,
                            style: TextStyle(color: Colors.red),
                          ),
                      ],
                    );
                  }),
                  SizedBox(height: 20),
                  Obx(() {
                    return Column(
                      children: [
                        TextField(
                          controller: controller.studentAmountController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "المبلغ",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        if (controller.studentAmountError.value.isNotEmpty)
                          Text(
                            controller.studentAmountError.value,
                            style: TextStyle(color: Colors.red),
                          ),
                      ],
                    );
                  }),
                  SizedBox(height: 20),
                  Obx(() {
                    return Column(
                      children: [
                        TextField(
                          controller: controller.studentDescriptionController,
                          decoration: InputDecoration(
                            labelText: "الوصف",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        if (controller.studentDescriptionError.value.isNotEmpty)
                          Text(
                            controller.studentDescriptionError.value,
                            style: TextStyle(color: Colors.red),
                          ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  controller.saveIncomeStudent();
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.green)),
                child: Text(
                  "حفظ",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () => controller.resetForm(),
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.orange)),
                child: Text("إعادة ضبط", style: TextStyle(color: Colors.white)),
              ),
              TextButton(
                onPressed: () => Get.back(),
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.red)),
                child: Text("إلغاء", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSupporterIncomeForm(IncomeFormController controller, context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Obx(() {
                    return Column(
                      children: [
                        TextField(
                          controller: controller.supporterNameController,
                          decoration: InputDecoration(
                            labelText: "اسم الداعم",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        if (controller.supporterNameError.value.isNotEmpty)
                          Text(
                            controller.supporterNameError.value,
                            style: TextStyle(color: Colors.red),
                          ),
                      ],
                    );
                  }),
                  SizedBox(height: 20),
                  Obx(() {
                    return Column(
                      children: [
                        studentDropdown(
                          context: context,
                          userList: controller.committee,
                          selectedUser: controller.selectCommittee2.value,
                          onChanged: (UserModel? newValue) {
                            controller.setSelectCommittee2(newValue!);
                          },
                          label: "أختر المستلم",
                        ),
                        if (controller.selectCommittee2Error.value.isNotEmpty)
                          Text(
                            controller.selectCommittee2Error.value,
                            style: TextStyle(color: Colors.red),
                          ),
                      ],
                    );
                  }),
                  SizedBox(height: 20),
                  Obx(() {
                    return Column(
                      children: [
                        studentDropdown(
                          context: context,
                          userList: controller.mergedList,
                          selectedUser: controller.student2.value,
                          onChanged: (UserModel? newValue) {
                            controller.setSelectStudent2(newValue!);
                          },
                          label: "أختر جالب الدعم",
                        ),
                        if (controller.student2Error.value.isNotEmpty)
                          Text(
                            controller.student2Error.value,
                            style: TextStyle(color: Colors.red),
                          ),
                      ],
                    );
                  }),
                  SizedBox(height: 20),
                  Obx(() {
                    return Column(
                      children: [
                        TextField(
                          controller: controller.supporterAmountController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "المبلغ",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        if (controller.supporterAmountError.value.isNotEmpty)
                          Text(
                            controller.supporterAmountError.value,
                            style: TextStyle(color: Colors.red),
                          ),
                      ],
                    );
                  }),
                  SizedBox(height: 20),
                  Obx(() {
                    return Column(
                      children: [
                        TextField(
                          controller: controller.supporterDescriptionController,
                          decoration: InputDecoration(
                            labelText: "الوصف",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        if (controller
                            .supporterDescriptionError.value.isNotEmpty)
                          Text(
                            controller.supporterDescriptionError.value,
                            style: TextStyle(color: Colors.red),
                          ),
                      ],
                    );
                  }),
                  SizedBox(height: 20),
                  _buildImagePicker(
                    controller: controller,
                    theme: Theme.of(context),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  controller.saveIncomeSupport();
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.green)),
                child: Text(
                  "حفظ",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () => controller.resetForm(),
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.orange)),
                child: Text("إعادة ضبط", style: TextStyle(color: Colors.white)),
              ),
              TextButton(
                onPressed: () => Get.back(),
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.red)),
                child: Text("إلغاء", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImagePicker({
    required IncomeFormController controller,
    required ThemeData theme,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Obx(() {
        return GestureDetector(
          onTap: () async {
            await checkCameraPermissionAndScan(controller);
          },
          child: Column(
            children: [
              Container(
                height: 150,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: controller.imageError.value.isEmpty
                        ? theme.colorScheme.primary
                        : Colors.red,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: controller.selectedImage.value.path.isEmpty
                    ? Center(
                        child: Text("اختر صورة",
                            style: theme.textTheme.labelLarge))
                    : Image.file(
                        controller.selectedImage.value,
                        fit: BoxFit.fill,
                      ),
              ),
              if (controller.imageError.value.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    controller.imageError.value,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  Future<void> checkCameraPermissionAndScan(controller) async {
    bool isGranted =
        await PermissionsHelper.checkAndRequestPermission(Permission.camera);

    if (isGranted) {
      List<File>? pictures = await ImageCompressor.scanAndCompressDocuments();

      if (pictures != null) {
        controller.selectedImage.value = pictures.first;
        controller.imageError.value = '';
      }
    } else {
      PermissionsHelper.showSnackbar(
        "خطأ ❌",
        "لم يتم منح الأذونات اللازمة",
        Colors.red.withOpacity(0.5),
      );
    }
  }

  Widget studentDropdown({
    required List<UserModel> userList,
    required UserModel? selectedUser,
    required Function(UserModel?) onChanged,
    required String label,
    required context,
  }) {
    return DropdownSearch<UserModel>(
      items: (filter, loadProps) => Future.value(userList),
      onChanged: onChanged,
      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      itemAsString: (UserModel user) => "${user.name}",
      filterFn: (UserModel user, String searchText) {
        return user.name!.contains(searchText) ||
            user.name!.contains(searchText);
      },
      popupProps: PopupProps.menu(
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            filled: true,
            fillColor: Theme.of(context).inputDecorationTheme.fillColor,
            labelText: "بحث",
            border: OutlineInputBorder(),
          ),
        ),
      ),
      compareFn: (item1, item2) {
        return item1.id == item2.id;
      },
    );
  }
}
