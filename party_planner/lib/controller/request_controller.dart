import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RequestController extends GetxController {
  final normalFormKey = GlobalKey<FormState>();
  final transportFormKey = GlobalKey<FormState>();
  final typeController = TextEditingController();
  final purposeController = TextEditingController();
  final destinationController = TextEditingController();
  final amountController = TextEditingController();
  final descriptionController =
      TextEditingController(); // Ensure this is present

  var requestTypes = ["خدمة", "أصول أيجار", "مشتريات"].obs;
  var transportMethods =
      ["دراجة نارية", "باص", "ع الماشي", "تأكسي", "شاحنة"].obs;
  var selectedType = "".obs;
  var selectedTransportMethod = "".obs;
  var selectedImage = "".obs;
  var textLength = 0.obs;

  updateTextLength(length) {
    textLength = length;
  }

  @override
  void onClose() {
    typeController.dispose();
    purposeController.dispose();
    destinationController.dispose();
    amountController.dispose();
    descriptionController.dispose(); // Ensure this is disposed
    super.onClose();
  }
}
