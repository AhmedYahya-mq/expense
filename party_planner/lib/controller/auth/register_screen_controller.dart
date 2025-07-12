// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:party_planner/core/routes/app_routes.dart';
// import 'package:party_planner/core/utils/validation.dart'; // تأكد من أن هذه الدالة متاحة
// import 'package:party_planner/model/user.dart';

// class RegisterScreenController extends GetxController {
//   var user = UserModel(email: '', password: '', username: '').obs;
//   var confirmPassword = ''.obs;
//   RxBool obscureText = true.obs;

//   // دالة لتحديث اسم المستخدم
//   void setUsername(String value) {
//     user.update((val) {
//       val?.username = value;
//     });
//   }

//   void setEmail(String value) {
//     user.update((val) {
//       val?.email = value;
//     });
//   }

//   void toggleObscureText() {
//     obscureText.value = !obscureText.value;
//     update();
//   }

//   void setPassword(String value) {
//     user.update((val) {
//       val?.password = value;
//     });
//   }

//   void setConfirmPassword(String value) {
//     confirmPassword.value = value;
//   }

//   void redirctLogin() {
//     Get.offNamed(AppRoutes.login);
//   }

//   bool validatePasswords() {
//     return user.value.password == confirmPassword.value;
//   }

//   // التحقق من اسم المستخدم
//   bool validateUsername() {
//     return isValidUsername(
//         user.value.username); // تأكد من أن دالة isValidUsername متاحة
//   }

//   void signUp() {
//     if (user.value.username.isEmpty ||
//         user.value.email.isEmpty ||
//         user.value.password.isEmpty ||
//         confirmPassword.isEmpty) {
//       Get.snackbar("خطأ", "الرجاء ملء جميع الحقول", colorText: Colors.red);
//       return;
//     }

//     if (!isValidEmail(user.value.email)) {
//       Get.snackbar("خطأ", "عنوان البريد الإلكتروني غير صالح",
//           colorText: Colors.red);
//       return;
//     }

//     if (!validateUsername()) {
//       Get.snackbar("خطأ", "اسم المستخدم يجب أن يحتوي على حروف فقط",
//           colorText: Colors.red);
//       return;
//     }

//     if (!validatePasswords()) {
//       Get.snackbar("خطأ", "كلمات المرور غير متطابقة", colorText: Colors.red);
//       return;
//     }

//     // منطق التسجيل
//     print("التسجيل باستخدام ${user.value.username}, ${user.value.email}");
//     // تنفيذ عملية التسجيل هنا
//   }
// }
