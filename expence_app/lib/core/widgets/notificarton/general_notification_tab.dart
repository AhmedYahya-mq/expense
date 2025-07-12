import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:party_planner/controllers/notificartion_controller.dart';

class GeneralNotificationTab extends StatelessWidget {
  final NotificationController controller = Get.find<NotificationController>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Obx(
                  () => Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          TextField(
                            onChanged: (value) =>
                                controller.generalTitle.value = value,
                            decoration: const InputDecoration(
                              labelText: "العنوان",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            onChanged: (value) =>
                                controller.generalBody.value = value,
                            decoration: const InputDecoration(
                              labelText: "المحتوى",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () =>
                                controller.pickImage(controller.generalImage),
                            child: const Text("اختيار صورة"),
                          ),
                          if (controller.generalImage.value != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Image.file(controller.generalImage.value!,
                                  height: 100),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    controller.sendGeneralNotification();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                  ),
                  child: const Text("إرسال إشعار عام"),
                ),
              ],
            ),
          ),
        ),
        Obx(() {
          if (controller.isLoadingGeneral.value ||
              controller.isLoadingGeneral.value) {
            return Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }
}
