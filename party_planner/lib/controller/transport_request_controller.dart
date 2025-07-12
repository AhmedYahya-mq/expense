import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:party_planner/controllers/request_controller.dart';
import 'package:party_planner/core/utils/api_service.dart';
import 'package:party_planner/enums/transaction_category.dart';
import 'package:party_planner/models/request.dart';

class TransportRequestController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final purposeController = TextEditingController();
  final destinationController = TextEditingController();
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();
  RxBool isLoading = false.obs;

  var transportMethods =
      ["دراجة نارية", "باص", "ع الماشي", "تأكسي", "شاحنة"].obs;
  var selectedTransportMethod = "".obs;
  var selectedImage = "".obs;

  Future<void> sendRequestData() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    if (int.tryParse(amountController.text) == null) {
      Get.snackbar("خطأ", 'الرجاء إدخال المبلغ رقم صحيح',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    isLoading.value = true;
    final data = {
      'amount': int.tryParse(amountController.text) ?? 0,
      'description': descriptionController.text,
      'category': TransactionCategory.transportation.name,
      'purpose': purposeController.text,
      'destination': destinationController.text,
      'method': selectedTransportMethod.value,
    };
    final response = await ApiService()
        .post('/request/store', data: data, fromJson: Request.fromJson);
    if (response != null) {
      Get.find<RequestController>().requests.insert(0, response);
      Get.back();
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
        content: Text('تم الرسال الطلب بنجاح'),
        backgroundColor: Colors.green,
      ));
    }
    isLoading.value = false;
  }

  @override
  void onClose() {
    purposeController.dispose();
    destinationController.dispose();
    amountController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال المبلغ';
    }
    if (int.tryParse(value) == null) {
      return 'الرجاء إدخال رقم صحيح';
    }
    return null;
  }
}
