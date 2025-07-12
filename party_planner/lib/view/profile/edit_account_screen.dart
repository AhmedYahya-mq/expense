import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:party_planner/controllers/user_controller.dart';

class EditAccountScreen extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());
  final _userFormKey =
      GlobalKey<FormState>(); // مفتاح لنموذج تغيير اسم المستخدم
  final _passwordFormKey = GlobalKey<FormState>();

  EditAccountScreen({super.key}); // مفتاح لنموذج تغيير كلمة السر

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('تعديل الملف الشخصي'),
        centerTitle: true,
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.blue,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: isDarkMode
              ? LinearGradient(
                  colors: [Colors.grey[850]!, Colors.grey[900]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : LinearGradient(
                  colors: [Colors.blue.shade50, Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // نموذج تغيير اسم المستخدم
                    _buildUserForm(context),
                    const SizedBox(height: 20),

                    // نموذج تغيير كلمة السر
                    _buildPasswordForm(context),
                  ],
                ),
              ),
            ),
            Obx(() {
              if (controller.isLoading.value) {
                return Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: Colors.black.withOpacity(0.5),
                    child: Center(child: const CircularProgressIndicator()));
              } else {
                return const SizedBox.shrink();
              }
            })
          ],
        ),
      ),
    );
  }

  Widget _buildUserForm(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: isDarkMode ? Colors.grey[800] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _userFormKey,
          child: Column(
            children: [
              Text(
                'تغيير اسم المستخدم',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              _buildTextFormField(
                context,
                label: 'اسم المستخدم الجديد',
                controller: controller.usernameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال اسم مستخدم جديد';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              _buildButton(
                context,
                text: 'حفظ التغييرات',
                onPressed: () {
                  if (_userFormKey.currentState!.validate()) {
                    controller.changeUsername();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordForm(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: isDarkMode ? Colors.grey[800] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _passwordFormKey,
          child: Column(
            children: [
              Text(
                'تغيير كلمة السر',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              _buildTextFormField(
                context,
                label: 'كلمة السر الحالية',
                controller: controller.currentPasswordController,
                isPassword: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال كلمة السر الحالية';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              _buildTextFormField(
                context,
                label: 'كلمة السر الجديدة',
                controller: controller.newPasswordController,
                isPassword: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال كلمة السر الجديدة';
                  }
                  if (value.length < 6) {
                    return 'كلمة السر يجب أن تكون على الأقل 6 أحرف';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              _buildTextFormField(
                context,
                label: 'تأكيد كلمة السر الجديدة',
                controller: controller.confirmPasswordController,
                isPassword: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء تأكيد كلمة السر الجديدة';
                  }
                  if (value != controller.newPasswordController.text) {
                    return 'كلمة السر غير متطابقة';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              _buildButton(
                context,
                text: 'حفظ التغييرات',
                onPressed: () {
                  if (_passwordFormKey.currentState!.validate()) {
                    controller.changePassword();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(BuildContext context,
      {required String label,
      bool isPassword = false,
      required TextEditingController controller,
      required String? Function(String?) validator}) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: isDarkMode ? Colors.grey[700]! : Colors.grey[400]!,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: isDarkMode ? Colors.grey[700]! : Colors.grey[400]!,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
          ),
        ),
        filled: true,
        fillColor: isDarkMode ? Colors.grey[700] : Colors.grey[100],
      ),
      style: TextStyle(
        color: isDarkMode ? Colors.white : Colors.black87,
      ),
      validator: validator,
    );
  }

  Widget _buildButton(BuildContext context,
      {required String text, required Function() onPressed}) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isDarkMode ? Colors.blue[800] : Colors.blue,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }
}
