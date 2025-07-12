import 'package:get/get.dart';
import 'package:party_planner/core/utils/api_service.dart';
import 'package:party_planner/models/transaction.dart';

class HistoryTransaction extends GetxController {
  var transactions = <Transaction>[].obs;
  Rx<bool> isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    isLoading.value = true;
    final response = await ApiService().get('/transaction');

    if (response != null) {
      // transactions = response;
      var listTransaction =
          List<Transaction>.from(response['data'].map((transaction) {
        return Transaction.fromJson(transaction);
      }));

      transactions.assignAll(listTransaction);
    }
    isLoading.value = false;
  }
}
