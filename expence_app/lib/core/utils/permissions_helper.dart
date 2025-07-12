import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:party_planner/core/utils/device_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class PermissionsHelper {
  static final _box = GetStorage(); // تخزين حالة الصلاحيات

  /// التحقق من حالة الصلاحية مباشرة من النظام
  static Future<bool> isPermissionGranted(Permission permission) async {
    final status = await permission.status;
    return status.isGranted;
  }

  /// طلب الإذن بناءً على إصدار النظام
  static Future<PermissionStatus> requestPermission(
      Permission permission) async {
    return await permission.request();
  }

  /// التعامل مع حالة الإذن بعد الطلب
  static void handlePermissionStatus(PermissionStatus status,
      {String? permissionName}) {
    if (status.isGranted) {
      _box.write('${permissionName}_permission', true);
    } else if (status.isDenied) {
      showSnackbar("⚠️ الصلاحيات مطلوبة",
          "يرجى منح إذن $permissionName لإكمال العملية.", Colors.orange);
    } else if (status.isPermanentlyDenied) {
      showSnackbar(
          "🚫 الصلاحيات مرفوضة", "يجب تفعيل الإذن من الإعدادات.", Colors.red);
      openAppSettings();
    }
  }

  /// دالة رئيسية للتحقق وطلب الإذن إذا لزم الأمر
  static Future<bool> checkAndRequestPermission(Permission permission) async {
    if (await isPermissionGranted(permission)) return true;
    final status = await requestPermission(permission);
    handlePermissionStatus(status, permissionName: permission.toString());
    return status.isGranted;
  }

  static Future<bool> checkAndRequestPermissionPhoto() async {
    final version = await DeviceInfo.getAndroidVersion();
    Permission permission =
        version >= 13 ? Permission.photosAddOnly : Permission.mediaLibrary;
    if (await isPermissionGranted(permission)) return true;
    final status = await requestPermission(permission);
    handlePermissionStatus(status, permissionName: permission.toString());
    return status.isGranted;
  }

  /// عرض رسالة للمستخدم
  static void showSnackbar(String title, String message, Color color) {
    Get.snackbar(title, message, backgroundColor: color);
  }

  /// الحصول على الصلاحية المناسبة بناءً على إصدار النظام
  static Future<Permission> getStoragePermission() async {
    if (Platform.isAndroid) {
      final version = await DeviceInfo.getAndroidVersion();
      return version >= 11
          ? Permission.manageExternalStorage
          : Permission.storage;
    }
    return Permission.storage;
  }
}
