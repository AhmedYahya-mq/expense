import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:party_planner/core/utils/api_service.dart';
import 'package:party_planner/models/setting.dart';

class BudgetController extends GetxController {
  var budgetController = TextEditingController();
  var studentPaymentController = TextEditingController();
  var contributionPercentageController = TextEditingController();
  final TextEditingController requiredPaymentController =
      TextEditingController();
  var initialBudget = '0';
  var initialStudentPayment = '0';
  var initialContributionPercentage = '0';
  var initialRequiredPayment = '0';
  var isChanged = false;
  var budgetError = '';
  var studentPaymentError = '';
  var contributionPercentageError = '';
  var requiredPaymentError = '';
  var isLoading = false.obs;
  var isSaving = false.obs;

  final ApiService apiService = ApiService();

  @override
  void onInit() {
    fetchBudgetData();
    super.onInit();
  }

  void updateBudget(String value) {
    if (_isNumeric(value)) {
      budgetError = '';
      checkChanges();
    } else {
      budgetError = 'يجب إدخال رقم صالح';
    }
  }

  void updateStudentPayment(String value) {
    if (_isNumeric(value)) {
      studentPaymentError = '';
      checkChanges();
    } else {
      studentPaymentError = 'يجب إدخال رقم صالح';
    }
  }

  void updateContributionPercentage(String value) {
    if (value.isEmpty) {
      contributionPercentageError = 'هذا الحقل مطلوب';
      return;
    }
    if (_isNumeric(value)) {
      double percentage = double.parse(value);
      if (percentage < 0 || percentage > 50) {
        contributionPercentageError = 'يجب أن تكون النسبة بين 0 و 50';
      } else {
        contributionPercentageError = '';
      }
      checkChanges();
    } else {
      contributionPercentageError = 'يجب إدخال رقم صالح';
    }
  }

  void updateRequiredPayment(String value) {
    if (_isNumeric(value)) {
      requiredPaymentError = '';
      checkChanges();
    } else {
      requiredPaymentError = 'يجب إدخال رقم صالح';
    }
  }

  bool _isNumeric(String value) {
    return double.tryParse(value) != null;
  }

  void checkChanges() {
    isChanged = (budgetController.text != initialBudget ||
            studentPaymentController.text != initialStudentPayment ||
            contributionPercentageController.text !=
                initialContributionPercentage ||
            requiredPaymentController.text != initialRequiredPayment) &&
        (budgetController.text.isNotEmpty ||
            studentPaymentController.text.isNotEmpty ||
            contributionPercentageController.text.isNotEmpty ||
            requiredPaymentController.text.isNotEmpty);
  }

  Future<void> fetchBudgetData() async {
    isLoading.value = true;
    final response = await apiService.get('/settings');
    final List<Setting> data = List<Setting>.from(
        response['data'].map((item) => Setting.fromJson(item)));

    if (data.isNotEmpty) {
        if (data.isNotEmpty) budgetController.text = data[0].value ?? '0';
        if (data.length > 1) {
        studentPaymentController.text = data[1].value ?? '0';
        }
        if (data.length > 2) {
        contributionPercentageController.text = data[2].value ?? '0';
        }
        if (data.length > 3) {
        requiredPaymentController.text = data[3].value ?? '0';
        }
        initialBudget = budgetController.text;
        initialStudentPayment = studentPaymentController.text;
        initialContributionPercentage = contributionPercentageController.text;
        initialRequiredPayment = requiredPaymentController.text;
    }
    isLoading.value = false;
  }

  Future<void> save() async {
    bool hasError = false;
    if (budgetController.text.isEmpty) {
        budgetError = 'هذا الحقل مطلوب';
        hasError = true;
    }
    if (studentPaymentController.text.isEmpty) {
        studentPaymentError = 'هذا الحقل مطلوب';
        hasError = true;
    }
    if (contributionPercentageController.text.isEmpty) {
        contributionPercentageError = 'هذا الحقل مطلوب';
        hasError = true;
    }
    if (requiredPaymentController.text.isEmpty) {
        requiredPaymentError = 'هذا الحقل مطلوب';
        hasError = true;
    }
    if (hasError) {
        Get.snackbar("Error", "يرجى تصحيح الأخطاء قبل الحفظ");
        return;
    }

    isSaving.value = true;
    final data = {
        'settings': [
        {'key': 'budget', 'value': budgetController.text},
        {'key': 'studentPayment', 'value': studentPaymentController.text},
        {
            'key': 'contributionPercentage',
            'value': contributionPercentageController.text
        },
        {'key': 'requiredPayment', 'value': requiredPaymentController.text},
        ]
    };
    final response = await apiService
        .post<Map<String, dynamic>>('/settings/init', data: data);

    if (response != null) {
        initialBudget = budgetController.text;
        initialStudentPayment = studentPaymentController.text;
        initialContributionPercentage = contributionPercentageController.text;
        initialRequiredPayment = requiredPaymentController.text;
        isChanged = false;
        Get.snackbar("Success", "تم حفظ البيانات بنجاح");
    }
    isSaving.value = false;
  }

  void cancel() {
    budgetController.text = initialBudget;
    studentPaymentController.text = initialStudentPayment;
    contributionPercentageController.text = initialContributionPercentage;
    requiredPaymentController.text = initialRequiredPayment;
    isChanged = false;
  }
}
