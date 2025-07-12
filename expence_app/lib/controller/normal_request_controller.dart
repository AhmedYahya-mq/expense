import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:party_planner/controllers/request_controller.dart';
import 'package:party_planner/core/utils/api_service.dart';
import 'package:party_planner/models/request.dart' as req;
import 'dart:io'; // Import this to use File for the image

class NormalRequestController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final purposeController = TextEditingController();
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();

  var selectedType = "".obs;
  Rx<File> selectedImage =
      File("").obs; // This will hold the image file path or URL
  var textLength = 0.obs;
  var imageError = ''.obs;
  RxBool isLoading = false.obs;

  updateTextLength(length) {
    textLength.value = length;
  }

  Future<void> sendRequestData() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    if (!isValid()) {
      return;
    }

    isLoading.value = true;
    final data = {
      'amount': int.tryParse(amountController.text) ?? 0,
      'description': descriptionController.text,
      'category': selectedType.value,
      'purpose': purposeController.text,
    };
    dio.FormData formData = dio.FormData.fromMap(data);
    if (selectedImage.value.path.isNotEmpty &&
        selectedImage.value.existsSync() &&
        selectedImage.value.lengthSync() < 2 * 1024 * 1024) {
      formData.files.add(MapEntry(
        'image',
        await dio.MultipartFile.fromFile(selectedImage.value.path),
      ));
    }
    final response = await ApiService().multipartRequest(
        endpoint: '/request/store',
        method: "POST",
        formData: formData,
        fromJson: req.Request.fromJson);
    if (response != null) {
      Get.find<RequestController>().requests.insert(0, response);
      Get.back();
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
        content: Text('تم الرسال الطلب بنجاح'),
        backgroundColor: Colors.green,
      ));
    } else {
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
        content: Text('فشل ارسال الطلب'),
        backgroundColor: Colors.red,
      ));
    }
    isLoading.value = false;
  }

  @override
  void onClose() {
    purposeController.dispose();
    amountController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  // Add this method for validation
  String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال المبلغ';
    }
    if (int.tryParse(value) == null) {
      return 'الرجاء إدخال رقم صحيح';
    }
    return null;
  }

  bool isValid() {
    if (int.tryParse(amountController.text) == null) {
      Get.snackbar("خطأ", 'الرجاء إدخال المبلغ رقم صحيح',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    if (selectedType.value.isEmpty) {
      Get.snackbar("خطأ", 'الرجاء اختيار نوع الطلب',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    // size iamge should be less than 2MB
    if (selectedImage.value.path.isNotEmpty &&
        selectedImage.value.existsSync() &&
        selectedImage.value.lengthSync() > 2 * 1024 * 1024) {
      imageError.value = 'حجم الصورة يجب أن يكون أقل من 2 ميجا';
      return false;
    }

    return true;
  }
}
