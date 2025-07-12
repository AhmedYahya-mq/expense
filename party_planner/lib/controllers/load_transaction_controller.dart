import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:party_planner/core/utils/api_service.dart';
import 'package:party_planner/enums/transaction_category.dart';
import 'package:party_planner/models/setting.dart';
import 'package:party_planner/models/transaction.dart';

class LoadTransactionController extends GetxController {
  RxList<Transaction> transactions = <Transaction>[].obs;
  RxBool isLoading = false.obs;
  RxList<Setting> settings = <Setting>[].obs;
  RxMap<String, dynamic> analyses = <String, dynamic>{}.obs;
  RxInt total = 0.obs;
  RxInt page = 1.obs;
  RxBool hasMore = true.obs;
  RxBool isLoadingMore = false.obs;

  Future<void> initIncome(String? link, {bool reset = false}) async {
    transactions.clear();
    page.value = 1;
    hasMore.value = true;
    isLoadingMore.value = false;
    isLoading.value = true;
    try {
      final response = await ApiService().get('$link?page=${page.value}');
      if (response == null ||
          response['data'] == null ||
          response['total'] == null) {
        return;
      }

      transactions.addAll(
        List<Transaction>.from(response['data']
            .map((transaction) => Transaction.fromJson(transaction))),
      );

      var totalData = Map<String, dynamic>.from(response['total']);
      total.value = int.tryParse("${totalData['total']}") ?? 0;
      totalData.remove('total');

      if (!response['isTransaction']) {
        analyses.assignAll(_getAnalysesCategory(totalData));
      } else {
        analyses.assignAll(_getAnalyses(totalData));
      }

      page.value++;
      hasMore.value = response['hasMore'];
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في تحميل المعاملات: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore(String link) async {
    print(!hasMore.value || isLoadingMore.value);
    if (!hasMore.value || isLoadingMore.value) return;
    isLoadingMore.value = true;
    final response = await ApiService().get('$link?page=${page.value}');

    transactions.addAll(
      List<Transaction>.from(response['data']
          .map((transaction) => Transaction.fromJson(transaction))),
    );

    page.value++;
    hasMore.value = response['hasMore'];
    isLoadingMore.value = false;
  }

  Map<String, dynamic> _getAnalysesCategory(Map<String, dynamic> totalData) {
    return Map<String, dynamic>.fromEntries(
      totalData.entries.map((entry) {
        final category = TransactionCategory.values.firstWhere(
          (element) => element.toString().split('.').last == entry.key,
          orElse: () {
            print(
                "⚠️ Warning: Unknown category '${entry.key}', using 'miscellaneous'.");
            return TransactionCategory.miscellaneous;
          },
        );
        int categoryValue = int.tryParse("${entry.value}") ?? 0;
        return MapEntry(category.name, {
          'value': categoryValue,
          'percent': total.value == 0 ? 0 : (categoryValue / total.value) * 100,
          'text': category.description,
          'color': _generateColor(TransactionCategory.values.indexOf(category)),
        });
      }),
    );
  }

  Map<String, dynamic> _getAnalyses(Map<String, dynamic> totalData) {
    Map<String, dynamic> texts = {
      "expense_sum": "المصروفات",
      "income_sum": "الدخل",
    };
    return Map<String, dynamic>.fromEntries(
      totalData.entries.map((entry) {
        int categoryValue = int.tryParse("${entry.value}") ?? 0;
        return MapEntry(entry.key, {
          'value': categoryValue,
          'percent': total.value == 0 ? 0 : (categoryValue / total.value) * 100,
          'text': texts[entry.key],
          'color': _generateColor(totalData.keys.toList().indexOf(entry.key)),
        });
      }),
    );
  }

  Color _generateColor(int index) {
    final List<Color> palette = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.brown,
      Colors.cyan,
      Colors.lime,
    ];
    return palette[index % palette.length];
  }
}
