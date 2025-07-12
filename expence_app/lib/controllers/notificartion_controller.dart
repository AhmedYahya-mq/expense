import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:party_planner/core/utils/api_error_type.dart';

import 'package:party_planner/core/utils/api_service.dart';
import 'package:party_planner/core/utils/image_compressor.dart';
import 'package:party_planner/core/utils/permissions_helper.dart';
import 'package:party_planner/models/user.dart';
import 'package:party_planner/models/user_list_model.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationController extends GetxController {
  var generalTitle = ''.obs;
  var generalBody = ''.obs;
  var generalImage = Rx<File?>(null);
  var isLoadingGeneral = false.obs;

  var customTitle = ''.obs;
  var customBody = ''.obs;
  var customImage = Rx<File?>(null);
  var selectedUsers = <UserModel>[].obs; // لتخزين المستخدمين المختارين
  var isLoadingCustom = false.obs;

  Rx<List<UserModel>> users = Rx<List<UserModel>>([]);
  final dropdownKey = GlobalKey<DropdownSearchState<String>>().obs;

  Future<void> sendGeneralNotification() async {
    if (isLoadingGeneral.value) return;
    isLoadingGeneral.value = true;
    try {
      if (generalTitle.isNotEmpty && generalBody.isNotEmpty) {
        dio.FormData formData = dio.FormData.fromMap({
          "title": generalTitle.value,
          "body": generalBody.value,
          "image":
              (generalImage.value != null && await generalImage.value!.exists())
                  ? await dio.MultipartFile.fromFile(generalImage.value!.path)
                  : null,
        });
        final response = await ApiService().multipartRequest(
            endpoint: '/all-send', formData: formData, method: "POST");
        Get.snackbar("تم", "تم إرسال الإشعار بنجاح");
        // reset form
        generalTitle.value = "";
        generalBody.value = "";
        generalImage.value = null;
      } else {
        Get.snackbar("خطأ", "الرجاء ملء جميع الحقول");
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
    isLoadingGeneral.value = false;
  }

  Future<void> sendCustomNotification() async {
    if (isLoadingCustom.value) return;
    isLoadingCustom.value = true;
    try {
      if (customTitle.isNotEmpty &&
          customBody.isNotEmpty &&
          selectedUsers.isNotEmpty) {
        dio.FormData formData = dio.FormData.fromMap({
          "title": customTitle.value,
          "body": customBody.value,
          "image":
              (customImage.value != null && await customImage.value!.exists())
                  ? await dio.MultipartFile.fromFile(customImage.value!.path)
                  : null,
          "users[]": List<String>.from(
              selectedUsers.map((e) => e.id!.replaceAll("#", ""))),
        });
        final response = await ApiService().multipartRequest(
            endpoint: '/customize-send', formData: formData, method: "POST");
        Get.snackbar("تم", response['message']);
        customBody.value = "";
        customTitle.value = "";
        customImage.value = null;
        selectedUsers.clear();
      } else {
        Get.snackbar("خطأ", "الرجاء ملء جميع الحقول");
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
    isLoadingCustom.value = false;
  }

  void _initDropDowns() async {
    var data =
        await ApiService().get('/user-role', fromJson: UserListModel.fromJson);
    if (data != null) {
      users.value = (data.committee! + data.normal!);
    }
  }

  @override
  void onInit() {
    _initDropDowns();
    super.onInit();
  }

  Future<void> pickImage(Rx<File?> imageFile) async {
    showModalBottomSheet(
      context: Get.context!,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera, color: Colors.blueAccent),
                title: const Text("الكاميرا"),
                onTap: () {
                  Navigator.pop(context);
                  _openCamera(imageFile);
                },
              ),
              ListTile(
                leading:
                    const Icon(Icons.photo_library, color: Colors.blueAccent),
                title: const Text("الاستوديو"),
                onTap: () {
                  Navigator.pop(context);
                  _openGallery(imageFile);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openCamera(Rx<File?> imageFile) async {
    bool isGranted =
        await PermissionsHelper.checkAndRequestPermission(Permission.camera);

    if (isGranted) {
      File? picture =
          await ImageCompressor.pickAndCompressImage("camera", quality: 80);

      if (picture != null) {
        imageFile.value = picture;
      }
    } else {
      PermissionsHelper.showSnackbar(
        "خطأ ❌",
        "لم يتم منح الأذونات اللازمة",
        Colors.red.withOpacity(0.5),
      );
    }
    print("فتح الكاميرا");
  }

  Future<void> _openGallery(Rx<File?> imageFile) async {
    bool isGranted = await PermissionsHelper.checkAndRequestPermissionPhoto();

    if (isGranted) {
      File? picture =
          await ImageCompressor.pickAndCompressImage("gallery", quality: 80);

      if (picture != null) {
        imageFile.value = picture;
      }
    } else {
      PermissionsHelper.showSnackbar(
        "خطأ ❌",
        "لم يتم منح الأذونات اللازمة",
        Colors.red.withOpacity(0.5),
      );
    }
    print("فتح الاستوديو");
  }
}
