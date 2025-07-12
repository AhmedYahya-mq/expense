import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:party_planner/core/routes/app_routes.dart';
import 'package:party_planner/core/utils/api_error_type.dart';
import 'package:party_planner/core/utils/api_service.dart';
import 'package:party_planner/core/utils/subscribe_to_topic.dart';
import 'package:party_planner/models/user.dart';
import 'package:dio/dio.dart' as dio;

class LoginScreenController extends GetxController {
  Rx<UserModel> userSession = UserModel().obs;
  UserModel get user => userSession.value;
  final ApiService _apiService = ApiService();
  final RxBool obscureText = true.obs;
  final RxBool rememberMe = false.obs;

  RxBool isLoading = false.obs;

  RxBool isUploadImage = false.obs; // This will hold the image file path or URL

  // دوال لتحديث القيم
  void setEmail(String value) {
    userSession.value.username = value;
  }

  void setPassword(String value) {
    userSession.value.password = value;
  }

  void toggleObscureText() {
    obscureText.value = !obscureText.value;
  }

  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }

  void redirctRegister() {
    Get.offNamed(AppRoutes.register);
  }

  // دالة تسجيل الدخول
  void login() async {
    if ((userSession.value.username?.isEmpty ?? true) ||
        (userSession.value.password!.isEmpty)) {
      Get.snackbar("خطأ", "يرجى إدخال البريد الإلكتروني وكلمة المرور",
          colorText: Colors.red);
      return;
    }

    signUp();
  }

  Future<void> signUp() async {
    if (isLoading.value) return;
    isLoading.value = true;

    final GetStorage storage = GetStorage();
    String? fcmToken;
    if (storage.hasData('token')) {
      fcmToken = storage.read('token');
    } else {
      fcmToken = await getFCMToken();
    }
    if (fcmToken != null && fcmToken.isNotEmpty) {
      final response = await _apiService.post('/login',
          data: {
            'username': userSession.value.username,
            'password': userSession.value.password,
            'remember': rememberMe.value,
            'token': fcmToken
          },
          fromJson: UserModel.fromJson);
      isLoading.value = false;
      if (response == null) return;
      final token = response.token!;
      if (rememberMe.value) _apiService.saveToken(token);
      userSession.value = response;
      Get.offNamed(AppRoutes.home);
    } else {
      isLoading.value = false;
      Get.snackbar("خطأ", "يرجى إعادة تشغيل التطبيق", colorText: Colors.red);
    }
  }

  Future<bool> autoLogin() async {
    final token = _apiService.getToken();
    if (token != null) {
      try {
        isLoading.value = true;
        final response =
            await _apiService.get('/user', fromJson: UserModel.fromJson);
        isLoading.value = false;
        if (response != null) {
          userSession.value = response;
          print(userSession.value.name);
          return true;
        }
      } on ApiError catch (e) {
        if (e.type == ApiErrorType.unauthorized) {
          _apiService.clearToken();
        } else {
          Get.snackbar('خطأ', e.message, snackPosition: SnackPosition.BOTTOM);
        }
      }
    }
    isLoading.value = false;
    return false;
  }

  Future<void> logout() async {
    if (isLoading.value) return;
    isLoading.value = true;
    final response = await _apiService.post('/logout', data: {});
    isLoading.value = false;
    if (response != null) {
      _apiService.clearToken();
      Get.offAllNamed(AppRoutes.login);
    }
  }

  // api change image
  Future<void> changeImage(String image) async {
    if (isUploadImage.value) return;
    if (!await isValidImage(File(image))) return;
    isUploadImage.value = true;
    try {
      final response = await _apiService.multipartRequest(
          endpoint: '/user/image',
          method: "POST",
          formData: dio.FormData.fromMap({
            'image': await dio.MultipartFile.fromFile(image),
          }),
          fromJson: UserModel.fromJson);
      if (response != null) {
        userSession.value = response;
      }
    } on ApiError catch (e) {
      if (e.type == ApiErrorType.validationError) {
        if (e.errors != null) {
          for (var error in e.errors!.values) {
            Get.snackbar('خطأ في التحقق', error.join(', '),
                snackPosition: SnackPosition.BOTTOM);
          }
        } else {
          Get.snackbar('خطأ في التحقق', e.message,
              snackPosition: SnackPosition.BOTTOM);
        }
      } else {
        Get.snackbar('خطأ', e.message, snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ غير متوقع.',
          snackPosition: SnackPosition.BOTTOM);
    }
    isUploadImage.value = false;
  }

  Future<bool> isValidImage(File image) async {
    if (!await image.exists()) {
      Get.snackbar('خطأ', 'الملف غير موجود',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    // size 2MB
    if (await image.length() > 2 * 1024 * 1024) {
      Get.snackbar('خطأ', 'الحجم الأقصى للصورة 2 ميجابايت',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    return true;
  }
}
