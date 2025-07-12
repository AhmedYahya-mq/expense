import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:party_planner/controllers/notificartion_controller.dart';
import 'package:party_planner/core/widgets/notificarton/custom_notification_tab.dart';
import 'package:party_planner/core/widgets/notificarton/general_notification_tab.dart';


class NotificationManagementScreen extends StatelessWidget {
  final NotificationController controller = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("إدارة الإشعارات"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "إشعار عام"),
              Tab(text: "إشعار مخصص"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            GeneralNotificationTab(),
            CustomNotificationTab(),
          ],
        ),
      ),
    );
  }
}
