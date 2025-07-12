// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:party_planner/controller/auth/register_screen_controller.dart';
// import 'package:party_planner/core/widgets/custom_pass_field.dart';
// import 'package:party_planner/core/widgets/custom_text_field.dart';
// import 'package:party_planner/core/widgets/gradient_button.dart';
// import 'package:party_planner/core/widgets/redirct_text.dart';
// import 'package:party_planner/core/utils/theme_helper.dart';

// class RegisterScreen extends StatelessWidget {
//   const RegisterScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final controller = Get.put(RegisterScreenController());

//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         decoration: ThemeHelper.gradientBackground(theme.colorScheme.primary),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               const SizedBox(height: 80),
//               Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Text(
//                       "تسجيل جديد",
//                       style: theme.textTheme.displayLarge?.copyWith(
//                         color: Colors.white,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Text(
//                       "أنشئ حسابًا جديدًا",
//                       style: theme.textTheme.titleLarge?.copyWith(
//                         color: Colors.white70,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Container(
//                 decoration: BoxDecoration(
//                   color: theme.scaffoldBackgroundColor,
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(60),
//                     topRight: Radius.circular(60),
//                   ),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(30),
//                   child: Column(
//                     children: <Widget>[
//                       const SizedBox(height: 60),
//                       CustomTextField(
//                         hintText: "اسم المستخدم",
//                         icon: Icons.person,
//                         onChanged: controller.setEmail,
//                       ),
//                       const SizedBox(height: 20),
//                       CustomTextField(
//                         hintText: "البريد الإلكتروني",
//                         icon: Icons.email,
//                         onChanged: controller.setEmail,
//                       ),
//                       const SizedBox(height: 20),
//                       GetBuilder<RegisterScreenController>(
//                           builder: (RegisterScreenController controller) {
//                         return CustomPasswordField(
//                           hintText: "كلمة المرور",
//                           icon: Icons.lock,
//                           obscureText: controller.obscureText.value,
//                           onChanged: controller.setPassword,
//                           toggleObscureText: controller.toggleObscureText,
//                         );
//                       }),
//                       const SizedBox(height: 40),
//                       GradientButton(
//                         text: "إنشاء الحساب",
//                         onPressed: controller.signUp,
//                       ),
//                       const SizedBox(height: 20),
//                     RedirectText(  // استخدام المكون هنا
//                         textBeforeLink: "لديك حساب بالفعل؟ ",
//                         linkText: "سجل الدخول",
//                          onLinkPressed: controller.redirctLogin,  // المسار الخاص بتسجيل الدخول
//                       ),
//                     ],
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
