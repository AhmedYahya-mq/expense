import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:party_planner/controller/normal_request_controller.dart';
import 'package:party_planner/controller/transport_request_controller.dart';
import 'package:party_planner/core/utils/image_compressor.dart';
import 'package:party_planner/core/utils/permissions_helper.dart';
import 'package:party_planner/enums/transaction_category.dart';
import 'package:permission_handler/permission_handler.dart';

class RequestEntryScreen extends StatelessWidget {
  final NormalRequestController normalController =
      Get.put(NormalRequestController());
  final TransportRequestController transportController =
      Get.put(TransportRequestController());

  RequestEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("إدخال الطلب"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "طلب عادي"),
              Tab(text: "طلب مواصلات"),
            ],
          ),
        ),
        body: Stack(
          children: [
            TabBarView(
              children: [
                _buildNormalRequestForm(theme),
                _buildTransportRequestForm(theme),
              ],
            ),
            Obx(() {
              if (normalController.isLoading.value ||
                  transportController.isLoading.value) {
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
        ),
      ),
    );
  }

  Widget _buildNormalRequestForm(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: normalController.formKey,
        child: ListView(
          children: [
            _buildDropdownFieldTypeRequest(
              controller: normalController,
              label: "نوع الطلب",
              theme: theme,
              items: TransactionCategory.values
                  .where((e) =>
                      e != TransactionCategory.students &&
                      e != TransactionCategory.support &&
                      e != TransactionCategory.transportation)
                  .map((e) => e)
                  .toList()
                  .obs,
            ),
            _buildTextField(
              controller: normalController.purposeController,
              label: "الغرض",
              theme: theme,
            ),
            _buildTextField(
              controller: normalController.amountController,
              label: "المبلغ",
              theme: theme,
              keyboardType: TextInputType.number,
            ),
            _buildImagePicker(
              controller: normalController,
              theme: theme,
            ),
            _buildTextFieldWithCounter(
              controller: normalController.descriptionController,
              label: "الوصف",
              theme: theme,
              maxLength: 255,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (normalController.formKey.currentState!.validate()) {
                  Get.find<NormalRequestController>().sendRequestData();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text(
                "إرسال",
                style: theme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransportRequestForm(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: transportController.formKey,
        child: ListView(
          children: [
            _buildTextField(
              controller: transportController.purposeController,
              label: "الغرض",
              theme: theme,
            ),
            _buildTextField(
              controller: transportController.destinationController,
              label: "الوجهة",
              theme: theme,
            ),
            _buildDropdownField(
              controller: transportController,
              label: "طريقة المواصلات",
              theme: theme,
              items: transportController.transportMethods,
            ),
            _buildTextField(
              controller: transportController.amountController,
              label: "المبلغ",
              theme: theme,
              keyboardType: TextInputType.number,
            ),
            _buildTextFieldWithCounter(
              controller: transportController.descriptionController,
              label: "الوصف",
              theme: theme,
              maxLength: 255,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (transportController.formKey.currentState!.validate()) {
                  await transportController.sendRequestData();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text(
                "إرسال",
                style: theme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required dynamic controller,
    required String label,
    required ThemeData theme,
    required RxList<String> items,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Obx(() {
        return DropdownButtonFormField<String>(
          value: controller is NormalRequestController
              ? controller.selectedType.value.isEmpty
                  ? null
                  : controller.selectedType.value
              : controller.selectedTransportMethod.value.isEmpty
                  ? null
                  : controller.selectedTransportMethod.value,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: theme.textTheme.labelLarge,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          items: items.map((String type) {
            return DropdownMenuItem<String>(
              value: type,
              child: Text(type),
            );
          }).toList(),
          onChanged: (newValue) {
            if (controller is NormalRequestController) {
              controller.selectedType.value = newValue!;
            } else {
              controller.selectedTransportMethod.value = newValue!;
            }
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'الرجاء اختيار $label';
            }
            return null;
          },
        );
      }),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required ThemeData theme,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: theme.textTheme.labelLarge,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'الرجاء إدخال $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDropdownFieldTypeRequest({
    required dynamic controller,
    required String label,
    required ThemeData theme,
    required List<TransactionCategory> items,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Obx(() {
        return DropdownButtonFormField<String>(
          value: controller is NormalRequestController
              ? controller.selectedType.value.isEmpty
                  ? null
                  : controller.selectedType.value
              : controller.selectedTransportMethod.value.isEmpty
                  ? null
                  : controller.selectedTransportMethod.value,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: theme.textTheme.labelLarge,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          items: items.map((TransactionCategory type) {
            return DropdownMenuItem<String>(
              value: type.name,
              child: Text(type.description),
            );
          }).toList(),
          onChanged: (newValue) {
            if (controller is NormalRequestController) {
              controller.selectedType.value = newValue ?? '';
            } else {
              controller.selectedTransportMethod.value = newValue ?? '';
            }
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'الرجاء اختيار $label';
            }
            return null;
          },
        );
      }),
    );
  }

  Widget _buildTextFieldWithCounter({
    required TextEditingController controller,
    required String label,
    required ThemeData theme,
    int maxLength = 255,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: theme.textTheme.labelLarge,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            maxLength: maxLength,
            maxLines: null,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'الرجاء إدخال $label';
              }
              return null;
            },
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }

  Widget _buildImagePicker({
    required NormalRequestController controller,
    required ThemeData theme,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Obx(() {
        return GestureDetector(
          onTap: () async {
            // التحقق من صلاحية الكاميرا وطلبها إذا لزم الأمر
            await checkCameraPermissionAndScan(controller);
          },
          child: Column(
            children: [
              Container(
                height: 150,
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
                        fit: BoxFit.fitHeight,
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

  Future<void> checkCameraPermissionAndScan(
      NormalRequestController controller) async {
    bool isGranted =
        await PermissionsHelper.checkAndRequestPermission(Permission.camera);

    if (isGranted) {
      // إذا تم منح الصلاحية، نبدأ عملية المسح
      List<File>? pictures = await ImageCompressor.scanAndCompressDocuments();

      if (pictures != null && pictures.isNotEmpty) {
        // إذا تم الحصول على صور، نقوم بتحديث القيمة في الـ controller
        controller.selectedImage.value = pictures.first;
        controller.imageError.value = '';
      }
    } else {
      // إذا لم يتم منح الصلاحية، نعرض رسالة خطأ
      PermissionsHelper.showSnackbar(
        "خطأ ❌",
        "لم يتم منح الأذونات اللازمة",
        Colors.red.withOpacity(0.5),
      );
    }
  }
}
