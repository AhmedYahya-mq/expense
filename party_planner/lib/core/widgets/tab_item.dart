import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:party_planner/controller/tab_controller.dart';
import 'package:party_planner/controllers/request_controller.dart';

class TabItem extends StatelessWidget {
  TabItem({
    super.key,
    required this.controller,
    required this.screenWidth,
    required this.theme,
    required this.index,
    required this.label,
    required this.filter,
  });

  final CustomTabsController controller;
  final double screenWidth;
  final ThemeData theme;
  final int index;
  final String label;
  final String filter;
  final RequestController _controller = Get.find<RequestController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 5),
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: colorBorder(),
            ),
            borderRadius: BorderRadius.circular(20)),
        child: InkWell(
          onTap: () {
            controller.index.value = index;
            _controller.filter = filter;
            _controller.initRequest(reset: true);
          },
          child: Text(
            label,
            maxLines: 1,
            softWrap: false,
            style: theme.textTheme.titleMedium?.copyWith(
                color: controller.index.value == index
                    ? theme.primaryColor
                    : null),
          ),
        ),
      ),
    );
  }

  Color colorBorder() => controller.index.value == index
      ? theme.primaryColor
      : theme.textTheme.titleLarge!.color ?? const Color(0xFF000000);
}
