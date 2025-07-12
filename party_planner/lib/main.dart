import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:party_planner/controller/settings_controller.dart';
import 'package:party_planner/core/routes/app_pages.dart';
import 'package:party_planner/core/routes/app_routes.dart';
import 'package:party_planner/core/services/notification_service.dart';
import 'package:party_planner/core/utils/subscribe_to_topic.dart';
import 'firebase_options.dart';
import 'package:party_planner/core/themes/app_theme.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService.instance.init();
  await GetStorage.init();
  subscribeToTopic();
  Get.lazyPut(() => SettingsController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(
      builder: (settingsController) {
        return GetMaterialApp(
            title: 'مصاريفنا',
            debugShowCheckedModeBanner: false,
            themeMode: settingsController.themeMode,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            initialRoute: AppRoutes.splash,
            getPages: AppPages.routes,
            locale: const Locale('ar'),
            fallbackLocale: const Locale('en'));
      },
    );
  }
}
