import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:party_planner/controller/navigation_controller.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBarTheme(
          data: NavigationBarThemeData(
            labelTextStyle: MaterialStateProperty.all(
              TextStyle(
                fontWeight: FontWeight.w600, // جعل النصوص بالخط العريض
              ),
            ),
          ),
          child: NavigationBar(
            height: 60,
            elevation: 0,
            selectedIndex: controller.selectedIndex.value,
            onDestinationSelected: (index) =>
                controller.selectedIndex.value = index,
            indicatorColor: Theme.of(context).primaryColor,
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home), label: "الرئيسية"),
              NavigationDestination(
                  icon: Icon(Icons.trending_up), label: "الدخل"),
              NavigationDestination(
                  icon: Icon(Icons.trending_down), label: "المصروفات"),
              NavigationDestination(
                icon: Icon(Icons.person),
                label: "البروفيل",
              ),
            ],
          ),
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}
