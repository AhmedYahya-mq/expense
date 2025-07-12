import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SettingsController extends GetxController {
  final _box = GetStorage();
  bool isDarkMode = false;
  ThemeMode themeMode = ThemeMode.system;

  @override
  void onInit() {
    super.onInit();
    if (_box.hasData('isDarkMode')) {
      isDarkMode = _box.read<bool>('isDarkMode')!;
      themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    } else {
      final brightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      isDarkMode = brightness == Brightness.dark;
    }
    // Get.changeThemeMode(isDarkMode ? ThemeMode.dark : ThemeMode.light);
  }

  void toggleDarkMode() {
    isDarkMode = !isDarkMode;
    _box.write('isDarkMode', isDarkMode);
    themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    Get.changeThemeMode(themeMode);
    update();
  }
}
