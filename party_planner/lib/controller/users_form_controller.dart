import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:party_planner/core/utils/api_service.dart';
import 'package:party_planner/enums/role.dart';
import 'package:party_planner/models/user.dart';

class UsersFormController extends GetxController {
  var students = <UserModel>[].obs; // قائمة الطلاب
  Rx<UserModel> userSession = UserModel().obs;
  UserModel get user => userSession.value;
  final ApiService _apiService = ApiService();
  final RxBool obscureText = true.obs;
  final RxBool isLoading = false.obs;
  final RxBool isDeleting = false.obs;
  final RxBool hasMore = true.obs;
  int currentPage = 1;

  @override
  void onInit() {
    super.onInit();
    fetchStudents();
  }

  void setPassword(String value) {
    userSession.value.password = value;
  }

  void setUserName(String value) {
    userSession.value.username = value;
  }

  void setUserRole(Role? value) {
    userSession.value.role = value;
  }

  void setName(String? value) {
    userSession.value.name = value;
  }

  void toggleObscureText() {
    obscureText.value = !obscureText.value;
    update();
  }

  // دالة لإضافة طالب جديد
  Future<bool> saveUser() async {
    final data = userSession.value.toJson();
    final response = await _apiService.post('/register',
        data: data, fromJson: UserModel.fromJson);
    if (response != null) {
      students.insert(0, response);
      Get.snackbar('نجاح', 'تم حفظ المستخدم بنجاح');
      return true;
    } else {
      Get.snackbar('فشل', 'فشل في حفظ المستخدم');
      return false;
    }
  }

  // دالة لجلب بيانات جميع الطلاب مع دعم التصفح
  Future<void> fetchStudents() async {
    if(hasMore.value == false || isLoading.value == true) return;
    isLoading.value = true;
    final response = await _apiService.get('/users?page=$currentPage');
    if (response != null && response['data'] != null) {
      var data = response['data'];
      print(data);
      var newStudents = List<UserModel>.from(data.map((student) {
        return UserModel.fromJson(student);
      }));
      students.addAll(newStudents.where((newStudent) => !students
          .any((existingStudent) => existingStudent.id == newStudent.id)));
      currentPage++;
      hasMore.value = response['hasMore'];
    }
    isLoading.value = false;
  }

  // دالة لتحميل المزيد من الطلاب
  void loadMoreStudents() {
    fetchStudents();
  }

  // دالة لحذف الطالب
  Future<bool> removeStudent(int index) async {
    isDeleting.value = true;
    final student = students[index];
    print('/users/${student.id}');

    final response =
        await _apiService.delete('/users/${student.id!.replaceAll("#", "")}');
    if (response != null) {
      students.removeAt(index);
      Get.snackbar('تم الحذف', 'تم حذف الطالب بنجاح');
      return true;
    }
    isDeleting.value = false;
    return false;
  }

  // دالة لعرض مربع حوار تأكيد الحذف
  Future<bool> confirmDeleteStudent(int index) async {
    bool confirm = false;
    await Get.defaultDialog(
      title: 'تأكيد الحذف',
      middleText: 'هل أنت متأكد أنك تريد حذف هذا الطالب؟',
      textCancel: 'إلغاء',
      textConfirm: 'حذف',
      confirmTextColor: Colors.red,
      cancelTextColor: Colors.green,
      onConfirm: () {
        confirm = true;
        Get.back();
      },
      onCancel: () {
        confirm = false;
      },
      barrierDismissible: false,
    );
    return confirm;
  }
}
