// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio; // ✅ تأكد من استيراد Dio بهذه الطريقة
import 'package:party_planner/core/utils/api_service.dart';
import 'package:party_planner/enums/transaction_category.dart';
import 'package:party_planner/models/transaction.dart';
import 'package:party_planner/models/user.dart';
import 'package:party_planner/models/user_list_model.dart';

class IncomeFormController extends GetxController {
  final studentAmountController = TextEditingController();
  final studentDescriptionController = TextEditingController();

  final supporterNameController = TextEditingController();
  final recipientNameController = TextEditingController();
  final broughtByNameController = TextEditingController();
  final supporterAmountController = TextEditingController();
  final supporterDescriptionController = TextEditingController();

  RxList<UserModel> committee = <UserModel>[].obs;
  RxList<UserModel> normal = <UserModel>[].obs;
  RxList<UserModel> mergedList = <UserModel>[].obs;
  Rx<UserModel> student = UserModel().obs;
  Rx<UserModel> selectCommittee = UserModel().obs;
  Rx<UserModel> student2 = UserModel().obs;
  Rx<UserModel> selectCommittee2 = UserModel().obs;
  Rx<File> selectedImage = File('').obs; // يسمح بأن يكون فارغًا (null)
  var imageError = ''.obs;
  Rx<bool> isLoading = false.obs;

  RxString studentAmountError = ''.obs;
  RxString studentDescriptionError = ''.obs;
  RxString selectCommitteeError = ''.obs;
  RxString studentError = ''.obs;

  RxString supporterNameError = ''.obs;
  RxString supporterAmountError = ''.obs;
  RxString supporterDescriptionError = ''.obs;
  RxString selectCommittee2Error = ''.obs;
  RxString student2Error = ''.obs;

  int currentPage = 1;
  RxBool hasMore = true.obs;

  var transactions = <Transaction>[].obs;
  RxBool isDeleting = false.obs;

  void setSelectStudent(UserModel user) {
    student.value = user;
  }

  void setSelectCommittee(UserModel user) {
    selectCommittee.value = user;
  }

  void setSelectStudent2(UserModel user) {
    student2.value = user;
  }

  void setSelectCommittee2(UserModel user) {
    selectCommittee2.value = user;
  }

  /// حفظ بيانات الدخل
  void saveIncomeStudent() async {
    if (_validateStudentFields()) {
      isLoading.value = true;
      final description = studentDescriptionController.text.isNotEmpty
          ? studentDescriptionController.text
          : supporterDescriptionController.text;
      final data = {
        'recipient_id':
            int.tryParse(selectCommittee.value.id!.replaceAll("#", "")),
        'amount': studentAmountController.text.isNotEmpty
            ? int.tryParse(studentAmountController.text) ?? 0
            : int.tryParse(supporterAmountController.text) ?? 0,
        'description': description,
        'user_id': int.tryParse(student.value.id!.replaceAll("#", "")),
        'category': TransactionCategory.students.name,
      };
      final response = await ApiService()
          .post('/incomes', data: data, fromJson: Transaction.fromJson);

      if (response != null) {
        Get.snackbar('نجاح', 'تم حفظ الدخل بنجاح',
            snackPosition: SnackPosition.TOP, backgroundColor: Colors.green);
        transactions.insert(0, response);
      }
      resetForm();
      isLoading.value = false;
    } else {
      Get.snackbar('خطأ', 'يجب تعبئة جميع الحقول',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void saveIncomeSupport() async {
    if (_validateSupportFields()) {
      isLoading.value = true;
      dio.FormData formData = dio.FormData.fromMap({
        'supporter_name': supporterNameController.text,
        'recipient_id':
            int.tryParse(selectCommittee2.value.id!.replaceAll("#", "")),
        'amount': int.tryParse(supporterAmountController.text) ?? 0,
        'description': supporterDescriptionController.text,
        'category': TransactionCategory.support.name,
        'user_id': int.tryParse(student2.value.id!.replaceAll("#", "")),
        'image': await dio.MultipartFile.fromFile(selectedImage.value.path),
      });
      final response = await ApiService().multipartRequest(
          endpoint: '/incomes',
          formData: formData,
          method: "POST",
          fromJson: Transaction.fromJson);
      print(response!.income.recipient!.name);

      Get.snackbar('نجاح', 'تم حفظ الدخل بنجاح',
          snackPosition: SnackPosition.TOP, backgroundColor: Colors.green);
      resetForm();
      isLoading.value = false;
    } else {
      Get.snackbar('خطأ', 'يجب تعبئة جميع الحقول',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  bool _validateStudentFields() {
    bool isValid = true;

    if (studentAmountController.text.isEmpty) {
      studentAmountError.value = 'يجب تعبئة هذا الحقل';
      isValid = false;
    } else if (int.tryParse(studentAmountController.text) == null) {
      studentAmountError.value = 'يجب أن يكون رقماً';
      isValid = false;
    } else {
      studentAmountError.value = '';
    }

    if (studentDescriptionController.text.isEmpty) {
      studentDescriptionError.value = 'يجب تعبئة هذا الحقل';
      isValid = false;
    } else {
      studentDescriptionError.value = '';
    }

    if (selectCommittee.value.id == null) {
      selectCommitteeError.value = 'يجب اختيار مستلم';
      isValid = false;
    } else {
      selectCommitteeError.value = '';
    }
    if (student.value.id == null) {
      studentError.value = 'يجب اختيار طالب';
      isValid = false;
    } else {
      studentError.value = '';
    }

    return isValid;
  }

  bool _validateSupportFields() {
    bool isValid = true;

    if (supporterNameController.text.isEmpty) {
      supporterNameError.value = 'يجب تعبئة هذا الحقل';
      isValid = false;
    } else {
      supporterNameError.value = '';
    }

    if (supporterAmountController.text.isEmpty) {
      supporterAmountError.value = 'يجب تعبئة هذا الحقل';
      isValid = false;
    } else if (int.tryParse(supporterAmountController.text) == null) {
      supporterAmountError.value = 'يجب أن يكون رقماً';
      isValid = false;
    } else {
      supporterAmountError.value = '';
    }

    if (supporterDescriptionController.text.isEmpty) {
      supporterDescriptionError.value = 'يجب تعبئة هذا الحقل';
      isValid = false;
    } else {
      supporterDescriptionError.value = '';
    }

    if (selectCommittee2.value.id == null) {
      selectCommittee2Error.value = 'يجب اختيار مستلم';
      isValid = false;
    } else {
      selectCommittee2Error.value = '';
    }

    if (student2.value.id == null) {
      student2Error.value = 'يجب اختيار جالب الدعم';
      isValid = false;
    } else {
      student2Error.value = '';
    }

    if (selectedImage.value.path.isEmpty) {
      imageError.value = 'يجب اختيار صورة';
      isValid = false;
    } else {
      imageError.value = '';
    }
    if (selectedImage.value.lengthSync() > 2000000) {
      imageError.value = 'يجب أن يكون حجم الصورة أقل من 2 ميجا';
      isValid = false;
    } else {
      imageError.value = '';
    }
    return isValid;
  }

  void resetForm() {
    studentAmountController.clear();
    studentDescriptionController.clear();
    supporterNameController.clear();
    recipientNameController.clear();
    broughtByNameController.clear();
    supporterAmountController.clear();
    supporterDescriptionController.clear();
    selectedImage.value = File('');
    student.value = UserModel(); // Resetting Rx<UserModel>
    selectCommittee.value = UserModel(); // Resetting Rx<UserModel>
    student2.value = UserModel(); // Resetting Rx<UserModel>
    selectCommittee2.value = UserModel(); // Resetting Rx<UserModel>
    studentAmountError.value = '';
    studentDescriptionError.value = '';
    selectCommitteeError.value = '';
    studentError.value = '';
    supporterNameError.value = '';
    supporterAmountError.value = '';
    supporterDescriptionError.value = '';
    selectCommittee2Error.value = '';
    student2Error.value = '';
    imageError.value = '';
  }

  @override
  void onClose() {
    studentAmountController.dispose();
    studentDescriptionController.dispose();

    supporterNameController.dispose();
    recipientNameController.dispose();
    broughtByNameController.dispose();
    supporterAmountController.dispose();
    supporterDescriptionController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    _initDropDowns();
    loadTransactions(reset: true);
  }

  void _initDropDowns() async {
    var data =
        await ApiService().get('/user-role', fromJson: UserListModel.fromJson);
    if (data != null) {
      committee.value = data.committee!;
      normal.value = data.normal!;
      mergedList.value = (data.committee! + data.normal!);
    }
    isLoading.value = false;
  }

  Future<void> loadTransactions({bool reset = false}) async {
    if (reset) {
      hasMore = true.obs;
      currentPage = 1;
      transactions.clear();
    }
    if (isLoading.value) return;
    isLoading.value = true;
    final response = await ApiService().get('/incomes?page=$currentPage');

    if (response != null) {
      var listTransaction =
          List<Transaction>.from(response['data'].map((transaction) {
        return Transaction.fromJson(transaction);
      }));

      transactions.addAll(listTransaction.where(
        (newItem) =>
            !transactions.any((existingItem) => existingItem.id == newItem.id),
      ));
    }
    currentPage++;
    hasMore.value = response['hasMore'];
    isLoading.value = false;
  }

  Future<bool> confirmDeleteTransaction(int index) async {
    return await Get.dialog(
      AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد أنك تريد حذف هذه المعاملة؟'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  Future<bool> removeTransaction(int index) async {
    isDeleting.value = true;
    final Transaction transaction = transactions[index];
    final response =
        await ApiService().delete('/incomes/${transaction.income.id}');
    if (response != null) {
      transactions.removeAt(index);
      Get.snackbar('نجاح', 'تم حذف الدخل بنجاح');
      isDeleting.value = false;
      return true;
    }
    isDeleting.value = false;
    return false;
  }
}
