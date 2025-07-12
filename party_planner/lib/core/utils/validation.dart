
import 'package:get/get.dart';

bool isValidEmail(String email) {
  return email.isEmail;
}

bool doPasswordsMatch(String password, String confirmPassword) {
  return password == confirmPassword;
}

bool isValidUsername(String username) {
  // تأكد من أن اسم المستخدم يحتوي على حروف فقط ولا يحتوي على أرقام أو رموز خاصة
  return RegExp(r'^[a-zA-Z]+$').hasMatch(username);
}
