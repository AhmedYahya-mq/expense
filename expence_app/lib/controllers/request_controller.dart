import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:party_planner/core/utils/api_error_type.dart';
import 'package:party_planner/core/utils/api_service.dart';
import 'package:party_planner/core/utils/image_compressor.dart';
import 'package:party_planner/core/utils/permissions_helper.dart';
import 'package:party_planner/models/request.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart' as dio;

class RequestController extends GetxController {
  RxList<Request> requests = <Request>[].obs;
  RxBool isLoading = false.obs;
  RxBool isUpdate = false.obs;
  RxInt page = 1.obs;
  RxBool hasMore = true.obs;
  String filter = "all";
  Rx<TextEditingController> rejectionReason = TextEditingController().obs;

  Future<void> initRequest({bool reset = false}) async {
    if (reset) {
      requests.clear();
      page.value = 1;
      hasMore.value = true;
    }

    if (!hasMore.value || isLoading.value) return;

    isLoading.value = true;
    final response = await ApiService()
        .get('/get/request?page=${page.value}&filter=$filter');
    if (response != null && response['data'] != null) {
      var listRequests = List<Request>.from(
          response['data'].map((request) => Request.fromJson(request)));
      if (listRequests.isNotEmpty) {
        requests.addAll(listRequests);
        page.value = response['nextPage'];
        hasMore.value = response['hasMore'];
      }
    }
    isLoading.value = false;
  }

  void loadMore() {
    if (hasMore.value) {
      initRequest();
    }
  }

  void loadMoreUserId(String id) {
    if (hasMore.value) {
      initRequestUser(id: id);
    }
  }

  Future<void> initRequestUser({bool reset = false, required String id}) async {
    if (reset) {
      requests.clear();
      page.value = 1;
      hasMore.value = true;
    }

    if (!hasMore.value || isLoading.value) return;
    isLoading.value = true;
    var url = '/get/request/${id.replaceAll("#", "")}?page=${page.value}';
    final response = await ApiService().get(url);
    if (response != null && response['data'] != null) {
      var listRequests = List<Request>.from(
          response['data'].map((request) => Request.fromJson(request)));
      if (listRequests.isNotEmpty) {
        requests.addAll(listRequests);
        page.value = response['nextPage'];
        hasMore.value = response['hasMore'];
      }
    }
    isLoading.value = false;
  }

  Future<void> updateAttachment(int index) async {
    if (isUpdate.value) return;
    isUpdate.value = true;
    try {
      bool isGranted =
        await PermissionsHelper.checkAndRequestPermission(Permission.camera);
      if (isGranted) {
      List<File>? pictures = await ImageCompressor.scanAndCompressDocuments();
      if (pictures != null && pictures.isNotEmpty) {
        var formData = dio.FormData.fromMap({
        'attachment': await dio.MultipartFile.fromFile(pictures.first.path),
        });
        try {
        var response = await ApiService().multipartRequest(
          endpoint: '/request/${requests[index].id}/attachment',
          method: 'POST',
          formData: formData,
          fromJson: Request.fromJson);
        if (response != null) {
          requests[index] = response;
            Get.snackbar("نجاح", "تم تحديث المرفق بنجاح",
            backgroundColor: Colors.green.withOpacity(0.5));
        } else {
            Get.snackbar("خطأ", "فشل في تحديث المرفق",
            backgroundColor: Colors.red.withOpacity(0.5));
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
      } else {
        print("لم يتم التقاط أي صورة");
      }
      } else {
      Get.snackbar("خطأ ❌", "لم يتم منح الأذونات اللازمة",
        backgroundColor: Colors.red.withOpacity(0.5));
      }
    } catch (e) {
      Get.snackbar('خطأ', "لم يتم التقاط أي صورة",
        snackPosition: SnackPosition.BOTTOM);
    }
    isUpdate.value = false;
  }

  Future<void> approveRequest(int index) async {
    isUpdate.value = true;
    var response = await ApiService().patch(
        '/request/${requests[index].id}/approve',
        fromJson: Request.fromJson);
    if (response != null) {
      requests[index] = response;
      Get.snackbar("نجاح", "تمت الموافقة على الطلب بنجاح",
          backgroundColor: Colors.green.withOpacity(0.5));
    } else {
      Get.snackbar("خطأ", "فشل في الموافقة على الطلب",
          backgroundColor: Colors.red.withOpacity(0.5));
    }
    isUpdate.value = false;
  }

  Future<void> rejectRequest(int index) async {
    if (rejectionReason.value.text.isEmpty) {
      Get.snackbar("خطأ", "يرجى إدخال سبب الرفض",
          backgroundColor: Colors.red.withOpacity(0.5));
      return;
    }
    isUpdate.value = true;
    var response = await ApiService().patch(
        '/request/${requests[index].id}/reject',
        data: {'rejection_reason': rejectionReason.value.text},
        fromJson: Request.fromJson);
    if (response != null) {
      requests[index] = response;
      Get.snackbar("نجاح", "تمت الموافقة على الطلب بنجاح",
          backgroundColor: Colors.green.withOpacity(0.5));
    } else {
      Get.snackbar("خطأ", "فشل في الموافقة على الطلب",
          backgroundColor: Colors.red.withOpacity(0.5));
    }
    isUpdate.value = false;
  }
}
