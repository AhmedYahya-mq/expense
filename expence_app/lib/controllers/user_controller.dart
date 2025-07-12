import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:party_planner/controller/auth/login_screen_controller.dart';
import 'package:party_planner/core/utils/api_service.dart'; // Add this line

class ProfileController extends GetxController {
  // استخدام TextEditingController لإدارة الحقول النصية
  final usernameController = TextEditingController();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  RxBool isLoading = false.obs;
  @override
  void onInit() {
    usernameController.text = Get.find<LoginScreenController>().user.username!;

    super.onInit();
  }

  void changeUsername() async {
    if (usernameController.text.isEmpty ||
        usernameController.text ==
            Get.find<LoginScreenController>().user.username) {
      Get.snackbar('خطأ', 'الرجاء إدخال اسم مستخدم جديد');
      return;
    }
    if(isLoading.value) return;
    isLoading.value = true;
    bool success = await ApiService().changeUsername(usernameController.text);
    if (success) {
      Get.find<LoginScreenController>().user.username = usernameController.text;
    }
    isLoading.value = false;
  }

  void changePassword() async {
    if (currentPasswordController.text.isEmpty ||
        newPasswordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      Get.snackbar('خطأ', 'الرجاء ملء جميع الحقول');
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      Get.snackbar('خطأ', 'كلمة السر الجديدة غير متطابقة');
      return;
    }

    if(isLoading.value) return;
    isLoading.value = true;
    bool success = await ApiService().changePassword(
      currentPasswordController.text,
      newPasswordController.text,
      confirmPasswordController.text,
    );
    if (success) {
      Get.find<LoginScreenController>().user.password =
          newPasswordController.text;
      currentPasswordController.text = '';
      newPasswordController.text = '';
      confirmPasswordController.text = '';
    }
    isLoading.value = false;
  }

  @override
  void onClose() {
    // تنظيف الـ controllers عند إغلاق الشاشة
    usernameController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
