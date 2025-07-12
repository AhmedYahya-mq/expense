import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:party_planner/core/utils/api_service.dart';
import 'package:party_planner/enums/transaction_category.dart';
import 'package:party_planner/models/setting.dart';
import 'package:party_planner/models/transaction.dart';

class IncomeController extends GetxController {
  RxList<Transaction> transactions = <Transaction>[].obs;
  Rx<bool> isLoading = true.obs;
  RxList<Setting> settings = <Setting>[].obs;
  int totalStudent = 0;
  int totalSupport = 0;
  int total = 0;

  RxMap<String, dynamic> analyses = <String, dynamic>{}.obs;
  @override
  void onInit() async {
    await initIncome();
    super.onInit();
  }

  Future<void> initIncome() async {
    isLoading.value = true;
    final response = await ApiService().get('/get/incomes');

    if (response != null) {
        // transactions = response;
        var listTransaction =
            List<Transaction>.from(response['data'].map((transaction) {
          return Transaction.fromJson(transaction);
        }));
        transactions.assignAll(listTransaction);

        totalStudent = int.parse("${response['total_student']}");
        totalSupport = int.parse("${response['total_support']}");
        total = int.parse("${response['total']}");
        var percentStudent = (totalStudent / total) * 100;
        var percentSupport = (totalSupport / total) * 100;
        analyses.value = {
          'percent': [percentStudent, percentSupport],
          'texts': [
            TransactionCategory.students.description,
            TransactionCategory.support.description
          ],
          'colors': [Colors.red, Colors.blue]
        };
        print('percent: ${response['percent']}');
    }
    isLoading.value = false;
  }
}
