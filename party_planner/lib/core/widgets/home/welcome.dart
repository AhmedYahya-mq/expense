import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:party_planner/controller/animation_controller.dart';
import 'package:party_planner/core/routes/app_routes.dart';

class Welcome extends StatelessWidget {
  final String name;
  final String welcome;
  final ThemeData theme;
  final bool isMessage;
  final bool isShowMessage;

  const Welcome({
    super.key,
    required this.theme,
    required this.name,
    required this.welcome,
    this.isMessage = false,
    this.isShowMessage = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isMessage) Get.put(AnimationControllerX());
    print(isMessage);
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: theme.textTheme.titleMedium,
            ),
            Text(
              welcome,
              style: theme.textTheme.labelMedium,
            ),
          ],
        ),
        const Spacer(),
        !isShowMessage
            ? const SizedBox.shrink()
            :
        Material(
          child: InkWell(
            onTap: () => Get.toNamed(AppRoutes.managerRequests),
            child: isMessage ? MessagesAnimation() : MessagesIcon(opacity: 0),
          ),
        ),
      ],
    );
  }
}

class MessagesAnimation extends StatelessWidget {
  const MessagesAnimation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AnimationControllerX>(
      builder: (controller) {
        return AnimatedBuilder(
          animation: controller.controller,
          builder: (context, child) {
            double progress = controller.controller.value;
            double shakeAngle = (progress < 0.5)
                ? sin(progress * pi * 4) * 0.1
                : 0; // اهتزاز ثم توقف

            return Transform.rotate(
              angle: shakeAngle,
              child: MessagesIcon(
                opacity: 0.5 + (controller.controller.value * 0.5),
              ),
            );
          },
        );
      },
    );
  }
}

class MessagesIcon extends StatelessWidget {
  const MessagesIcon({
    super.key,
    required this.opacity,
  });
  final double opacity;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        const Icon(
          Icons.message,
          size: 25,
        ),
      
        Opacity(
          opacity: opacity,
          child: const CircleAvatar(
            backgroundColor: Colors.red,
            radius: 5,
          ),
        ),
      ],
    );
  }
}
