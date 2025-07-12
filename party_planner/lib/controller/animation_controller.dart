import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnimationControllerX extends GetxController
    with GetTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void onInit() {
    super.onInit();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat(reverse: true); // التكرار للأمام والخلف
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }
}
