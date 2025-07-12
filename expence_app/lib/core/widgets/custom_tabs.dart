// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:party_planner/controller/tab_controller.dart';
import 'package:party_planner/core/widgets/tab_item.dart';
import 'package:party_planner/enums/role.dart';

class CustomTabsList extends StatelessWidget {
  CustomTabsList({
    super.key,
    required this.theme,
  });

  final ThemeData theme;

  CustomTabsController controller = Get.put(CustomTabsController());
  @override
  Widget build(BuildContext context) {
    // الحصول على عرض الشاشة باستخدام MediaQuery
    double screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: 31,
      child: Stack(
        children: [
          // التحريك باستخدام AnimatedPositioned مع Obx
          Obx(() {
            return AnimatedPositioned(
              width:
                  screenWidth / 4, // عرض الـ Container بناءً على عدد التبويبات
              height: 3,
              right: controller.containerPosition
                  .value, // يتم تحديد الموضع بناءً على حساب دقيق
              bottom: 0,
              duration: Duration(milliseconds: 300), // مدة التحريك
              child: Container(
                decoration: BoxDecoration(
                    color: theme.primaryColor,
                    borderRadius: BorderRadius.circular(5)),
              ),
            );
          }),

          Row(
            children: [
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.24,
                child: InkWell(
                  onTap: () {
                    controller.updatePosition(0, screenWidth, 4);
                  },
                  child: Obx(
                    () => Text(
                      "يومي",
                      style: theme.textTheme.titleMedium?.copyWith(
                          color: controller.index.value == 0
                              ? theme.primaryColor
                              : null),
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.24,
                child: InkWell(
                  onTap: () {
                    controller.updatePosition(1, screenWidth, 4);
                  },
                  child: Obx(
                    () => Text(
                      "أسبوعي",
                      style: theme.textTheme.titleMedium?.copyWith(
                          color: controller.index.value == 1
                              ? theme.primaryColor
                              : null),
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.23,
                child: InkWell(
                  onTap: () {
                    controller.updatePosition(2, screenWidth, 4);
                  },
                  child: Obx(
                    () => Text(
                      "شهري",
                      style: theme.textTheme.titleMedium?.copyWith(
                          color: controller.index.value == 2
                              ? theme.primaryColor
                              : null),
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.24,
                child: InkWell(
                  onTap: () {
                    controller.updatePosition(3, screenWidth, 4);
                  },
                  child: Obx(
                    () => Text(
                      "سنوي",
                      style: theme.textTheme.titleMedium?.copyWith(
                          color: controller.index.value == 3
                              ? theme.primaryColor
                              : null),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomTabs extends StatelessWidget {
  CustomTabs({
    super.key,
    required this.theme,
  });

  final ThemeData theme;

  CustomTabsController controller = Get.put(CustomTabsController());
  @override
  Widget build(BuildContext context) {
    // الحصول على عرض الشاشة باستخدام MediaQuery
    double screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: 31,
      child: Stack(
        children: [
          // التحريك باستخدام AnimatedPositioned مع Obx
          ListView(
            scrollDirection: Axis.horizontal,
            children: [
              TabItem(
                controller: controller,
                screenWidth: screenWidth,
                theme: theme,
                index: 0,
                label: "الكل",
                filter: 'all',
              ),
              TabItem(
                controller: controller,
                screenWidth: screenWidth,
                theme: theme,
                index: 1,
                label: "للجنة الأعلامية",
                filter: Role.head_of_media_committee.toString(),
              ),
              TabItem(
                controller: controller,
                screenWidth: screenWidth,
                theme: theme,
                index: 2,
                label: Role.head_of_supervisory_committee.description,
                filter: Role.head_of_supervisory_committee.name,
              ),
              TabItem(
                controller: controller,
                screenWidth: screenWidth,
                theme: theme,
                index: 3,
                label: Role.head_of_technical_committee.description,
                filter: Role.head_of_technical_committee.name,
              ),
              TabItem(
                controller: controller,
                screenWidth: screenWidth,
                theme: theme,
                index: 4,
                label: Role.head_of_relations_committee.description,
                filter: Role.head_of_relations_committee.name,
              ),
              TabItem(
                controller: controller,
                screenWidth: screenWidth,
                theme: theme,
                index: 5,
                label: Role.head_of_financial_committee.description,
                filter: Role.head_of_financial_committee.name,
              ),
              TabItem(
                controller: controller,
                screenWidth: screenWidth,
                theme: theme,
                index: 6,
                label: Role.head_of_preparatory_committee.description,
                filter: Role.head_of_preparatory_committee.name,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
