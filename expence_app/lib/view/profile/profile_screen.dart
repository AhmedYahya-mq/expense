import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:party_planner/controller/auth/login_screen_controller.dart';
import 'package:party_planner/core/utils/image_compressor.dart';
import 'package:party_planner/core/utils/permissions_helper.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final LoginScreenController controller = Get.find<LoginScreenController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(child: getBody(context)),
    );
  }

  Widget getBody(context) {
    var size = MediaQuery.of(context).size;
    ThemeData theme = Theme.of(context);
    bool isDarkMode = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDarkMode
                      ? [
                          Colors.purple[800]!,
                          Colors.indigo[900]!
                        ] // تدرج للوضع الليلي
                      : [
                          Colors.blueAccent,
                          Colors.purpleAccent
                        ], // تدرج للوضع النهاري
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 20, right: 20, left: 20, bottom: 30),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "الملف الشخصي",
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: const Icon(Icons.arrow_forward_ios_outlined,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Profile Image and Info
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Profile Image with Edit Button
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            if (controller.isUploadImage.value)
                              const Center(child: CircularProgressIndicator())
                            else
                              imageProfile(),
                            GestureDetector(
                              onTap: () {
                                _showImagePickerBottomSheet(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Colors.blueAccent,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 20),
                        // User Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.user.name ?? "",
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "المبلغ في حسابك: ${controller.user.balance} ريال",
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Remaining Amount Card
                    if (int.parse(controller.user.remaining_amount!
                            .replaceAll(',', "")) >
                        0)
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color:
                              isDarkMode ? Colors.red[800] : Colors.redAccent,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.redAccent.withOpacity(0.2),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "يرجى دفع المبلغ المتبقي",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "${controller.user.remaining_amount} ريال",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const Icon(
                                Icons.warning_amber_rounded,
                                color: Colors.white,
                                size: 30,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Budget Progress Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  PercentBudget(
                    size: size,
                    theme: theme,
                    paidAmount: controller.user.balance!,
                    totalBudget: controller.user.total_due_amount!,
                    title: "المبلغ المدفوع",
                    percent: controller.user.percent_balance!,
                  ),
                  const SizedBox(height: 20),
                  PercentBudget(
                    size: size,
                    theme: theme,
                    paidAmount: controller.user.total_due_amount!,
                    totalBudget: controller.user.total_due_amount!,
                    title: "المبلغ المتبقي",
                    percent: controller.user.percent_remaining_amount!,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container imageProfile() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 3,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: CachedNetworkImage(
          width: 100,
          height: 100,
          imageUrl: controller.user.image!,
          fit: BoxFit.cover,
          progressIndicatorBuilder: (context, url, downloadProgress) {
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
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          },
          errorWidget: (context, url, error) => Image.asset('assets/avatar.png'),
        ),
      ),
    );
  }

  // دالة لعرض القائمة (BottomSheet)
  void _showImagePickerBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
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
                  _openCamera();
                },
              ),
              ListTile(
                leading:
                    const Icon(Icons.photo_library, color: Colors.blueAccent),
                title: const Text("الاستوديو"),
                onTap: () {
                  Navigator.pop(context);
                  _openGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openCamera() async {
    bool isGranted =
        await PermissionsHelper.checkAndRequestPermission(Permission.camera);

    if (isGranted) {
      File? picture =
          await ImageCompressor.pickAndCompressImage("camera", quality: 80);

      if (picture != null) {
        controller.changeImage(picture.path);
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

  Future<void> _openGallery() async {
    bool isGranted = await PermissionsHelper.checkAndRequestPermissionPhoto();

    if (isGranted) {
      File? picture =
          await ImageCompressor.pickAndCompressImage("gallery", quality: 80);

      if (picture != null) {
        controller.changeImage(picture.path);
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

class PercentBudget extends StatelessWidget {
  const PercentBudget({
    super.key,
    required this.size,
    required this.theme,
    required this.paidAmount,
    required this.totalBudget,
    required this.title,
    required this.percent,
  });

  final Size size;
  final ThemeData theme;
  final String paidAmount;
  final String totalBudget;
  final String percent;
  final String title;

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = theme.brightness == Brightness.dark;

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "$paidAmount ريال",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "$percent%",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Stack(
                children: [
                  Container(
                    width: (size.width - 40),
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                    ),
                  ),
                  Container(
                    width: max(
                        0, (size.width - 40) * (double.parse(percent) / 100)),
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: isDarkMode
                            ? [Colors.purple[800]!, Colors.indigo[900]!]
                            : [Colors.blueAccent, Colors.purpleAccent],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
