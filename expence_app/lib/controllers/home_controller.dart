import 'package:get/get.dart';
import 'package:party_planner/core/utils/api_service.dart';
import 'package:party_planner/enums/role.dart';
import 'package:party_planner/models/setting.dart';
import 'package:party_planner/models/transaction.dart';

class HomeController extends GetxController {
  RxList<Transaction> transactions = <Transaction>[].obs;
  Rx<bool> isLoading = true.obs;
  RxList<Setting> settings = <Setting>[].obs;

  int incomeSum = 0;
  int expenseSum = 0;
  int expenseIncome = 0;
  double percent = 0.00;
  RxBool isMessage = false.obs;

  RxMap<Role, int> committees = <Role, int>{}.obs;

  @override
  void onInit() async {
    super.onInit();
    await initHome();
  }

  Future<void> initHome() async {
    isLoading.value = true;
    final response = await ApiService().get('/home');

    if (response != null) {
      // تحويل البيانات إلى كائنات `Transaction`
      var listTransaction =
          List<Transaction>.from(response['data'].map((transaction) {
        return Transaction.fromJson(transaction);
      }));

      // تحويل البيانات إلى كائنات `Setting`
      var listSetting =
          List<Setting>.from(response['settings'].map((setting) {
        return Setting.fromJson(setting);
      }));

      settings.assignAll(listSetting);
      transactions.assignAll(listTransaction);

      incomeSum = int.tryParse("${response['income_sum']}") ?? 0;
      expenseSum = int.tryParse("${response['expense_sum']}") ?? 0;
      expenseIncome = int.tryParse("${response['expense_income']}") ?? 0;
      percent = double.tryParse("${response['percent']}") ?? 0.00;
      isMessage.value = response['isNew'] ?? false;
      // تحويل المصاريف حسب اللجان وضمان ظهور جميع اللجان
      committees.value =
          _parseExpenses(response['ExpensesGroupedByCommittee']);
    }
    isLoading.value = false;
  }

  /// ✅ **دالة تضمن ظهور جميع اللجان حتى إذا لم يتم إرجاعها من الـ API**
  Map<Role, int> _parseExpenses(Map<String, dynamic>? data) {
    data ??= {}; // إذا كانت `null` اجعلها `{}`

    return {
      for (var role in Role.values.where((role) => role != Role.normal))
        role: int.tryParse(data[role.name]?.toString() ?? '0') ?? 0,
    };
  }
}
