import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:party_planner/controller/auth/login_screen_controller.dart';
import 'package:party_planner/controller/settings_controller.dart';
import 'package:party_planner/core/routes/app_routes.dart';
import 'package:party_planner/core/widgets/profile/forward_button.dart';
import 'package:party_planner/core/widgets/profile/setting_item.dart';
import 'package:party_planner/core/widgets/profile/setting_switch.dart';
import 'package:party_planner/enums/role.dart';

class AccountScreen extends StatelessWidget {
  AccountScreen({super.key});
  final LoginScreenController controller = Get.find<LoginScreenController>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "الإعدادات",
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            const Text(
              "الحساب",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  Obx(
                    () => ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: CachedNetworkImage(
                          width: 70,
                          height: 70,
                          imageUrl: controller.user.image!.isEmpty
                              ? "https://via.placeholder.com/150"
                              : controller.user.image!,
                          fit: BoxFit.cover,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) {
                            double progress = downloadProgress.progress ?? 0;
                            return Center(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    value: progress,
                                    strokeWidth: 3,
                                  ),
                                  Text(
                                    "${(progress * 100).toInt()}%",
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            );
                          },
                          errorWidget: (context, url, error) =>
                              Image.asset('assets/avatar.png')),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.user.getFullNameWithLastName(),
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        controller.user.id!,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      )
                    ],
                  ),
                  const Spacer(),
                  ForwardButton(
                    onTap: () {
                      Get.toNamed(AppRoutes.profile);
                    },
                  )
                ],
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              "الإعدادات",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            SettingItem(
              title: "سجل المدفوعات",
              icon: Icons.history,
              bgColor: Colors.blue.shade100,
              iconColor: Colors.blue,
              onTap: () {
                Get.toNamed(AppRoutes.payment);
              },
            ),
            const SizedBox(height: 20),
            GetBuilder<SettingsController>(
              builder: (controller) {
                return SettingSwitch(
                  title: "الوضع الليلي",
                  icon: controller.themeMode == ThemeMode.dark
                      ? Icons.mode_night
                      : Icons.wb_sunny,
                  bgColor: Colors.purple.shade100,
                  iconColor: Colors.purple,
                  value: controller.themeMode == ThemeMode.dark,
                  onTap: (value) {
                    controller.toggleDarkMode();
                  },
                );
              },
            ),
            const SizedBox(height: 20),
            if (controller.user.role == Role.head_of_financial_committee ||
                controller.user.role == Role.head_of_preparatory_committee)
              // زر تحكم في الإشعارات
              SettingItem(
                title: "الإشعارات",
                icon: Icons.notifications,
                bgColor: Colors.teal.shade100,
                iconColor: Colors.teal,
                onTap: () {
                  Get.toNamed(AppRoutes
                      .notification); // الانتقال إلى شاشة تحكم الإشعارات
                },
              ),
            const SizedBox(height: 20),
            if (controller.user.role == Role.head_of_financial_committee)
              SettingItem(
                title: "الإدارة",
                icon: Icons.manage_accounts,
                bgColor: Colors.brown.shade100,
                iconColor: Colors.brown,
                onTap: () {
                  Get.toNamed(AppRoutes.settings);
                },
              ),
            const SizedBox(height: 20),
            if (controller.user.role != Role.normal)
              SettingItem(
                title: "الطلبات",
                icon: Icons.request_page,
                bgColor: Colors.green.shade100,
                iconColor: Colors.green,
                onTap: () {
                  Get.toNamed(AppRoutes.request);
                },
              ),
            const SizedBox(height: 20),
            SettingItem(
              title: "أعدادات عامة",
              icon: Icons.settings,
              bgColor: Colors.orange.shade100,
              iconColor: Colors.orange,
              onTap: () {
                Get.toNamed(AppRoutes.editAccount);
              },
            ),
            const SizedBox(height: 40),
            // زر تسجيل الخروج
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // قم بتنفيذ عملية تسجيل الخروج هنا
                  Get.find<LoginScreenController>().logout();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Obx(
                  () => controller.isLoading.value
                      ? SizedBox(
                          height: 25,
                          width: 25,
                          child: const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          ),
                        )
                      : const Text(
                          "تسجيل الخروج",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
