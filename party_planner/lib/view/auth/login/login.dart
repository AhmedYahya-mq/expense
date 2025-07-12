import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:party_planner/controller/auth/login_screen_controller.dart';
import 'package:party_planner/core/widgets/custom_pass_field.dart';
import 'package:party_planner/core/widgets/custom_text_field.dart';
import 'package:party_planner/core/widgets/gradient_button.dart';
import 'package:party_planner/core/utils/theme_helper.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.put(LoginScreenController(), permanent: true);

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: ThemeHelper.gradientBackground(theme.colorScheme.primary),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "تسجيل الدخول",
                      style: theme.textTheme.displaySmall?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "أدخل بيانات حسابك",
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(60),
                  ),
                ),
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 40),
                    CustomTextField(
                      hintText: "أسم المستخدم",
                      icon: Icons.person,
                      onChanged: controller.setEmail,
                    ),
                    const SizedBox(height: 20),
                    Obx(() => CustomPasswordField(
                          hintText: "كلمة المرور",
                          icon: Icons.lock,
                          obscureText: controller.obscureText.value,
                          onChanged: controller.setPassword,
                          toggleObscureText: controller.toggleObscureText,
                        )),
                    const SizedBox(height: 20),
                    Obx(() => Row(
                          children: [
                            Checkbox(
                              value: controller.rememberMe.value,
                              onChanged: (value) =>
                                  controller.toggleRememberMe(value!),
                            ),
                            const Text("تذكرني"),
                          ],
                        )),
                    const SizedBox(height: 40),
                    Obx(() => GradientButton(
                          text: "تسجيل الدخول",
                          isLoading: controller.isLoading.value,
                          onPressed: controller.isLoading.value
                              ? null
                              : controller.login,
                        )),
                    const SizedBox(height: 20),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
