import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:party_planner/controller/budget_controller.dart';
import 'package:party_planner/core/widgets/header.dart';

class BudgetForm extends StatelessWidget {
  BudgetForm({super.key});
  final BudgetController controller = Get.put(BudgetController());

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            children: [
              Header(theme: theme, title: "الميزانية"),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: theme.cardColor, // استخدام لون البطاقة من الثيم
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: GetBuilder<BudgetController>(
                        builder: (controller) {
                          return Form(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Obx(() => TextFormField(
                                      controller: controller.budgetController,
                                      onChanged: controller.updateBudget,
                                      decoration: InputDecoration(
                                        labelText: 'الميزانية',
                                        prefixIcon: Icon(Icons.monetization_on,
                                            color: theme.primaryColor),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        errorText:
                                            controller.budgetError.isEmpty
                                                ? null
                                                : controller.budgetError,
                                        suffixIcon: controller.isLoading.value
                                            ? SizedBox(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        color:
                                                            theme.primaryColor),
                                              )
                                            : null,
                                      ),
                                      keyboardType: TextInputType.number,
                                    )),
                                const SizedBox(height: 16),
                                Obx(() => TextFormField(
                                      controller:
                                          controller.studentPaymentController,
                                      onChanged:
                                          controller.updateStudentPayment,
                                      decoration: InputDecoration(
                                        labelText: 'مساهمة الطالب',
                                        prefixIcon: Icon(Icons.person,
                                            color: theme.primaryColor),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        errorText: controller
                                                .studentPaymentError.isEmpty
                                            ? null
                                            : controller.studentPaymentError,
                                        suffixIcon: controller.isLoading.value
                                            ? SizedBox(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        color:
                                                            theme.primaryColor),
                                              )
                                            : null,
                                      ),
                                      keyboardType: TextInputType.number,
                                    )),
                                const SizedBox(height: 16),
                                Obx(() => TextFormField(
                                      controller: controller
                                          .contributionPercentageController,
                                      onChanged: controller
                                          .updateContributionPercentage,
                                      decoration: InputDecoration(
                                        labelText: 'نسبة المساهمة',
                                        prefixIcon: Icon(Icons.percent,
                                            color: theme.primaryColor),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        errorText: controller
                                                .contributionPercentageError
                                                .isEmpty
                                            ? null
                                            : controller
                                                .contributionPercentageError,
                                        suffixIcon: controller.isLoading.value
                                            ? SizedBox(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        color:
                                                            theme.primaryColor),
                                              )
                                            : null,
                                      ),
                                      keyboardType: TextInputType.number,
                                    )),
                                const SizedBox(height: 16),
                                Obx(() => TextFormField(
                                      controller:
                                          controller.requiredPaymentController,
                                      onChanged:
                                          controller.updateRequiredPayment,
                                      decoration: InputDecoration(
                                        labelText: 'المبلغ المطلوب',
                                        prefixIcon: Icon(Icons.payment,
                                            color: theme.primaryColor),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        errorText: controller
                                                .requiredPaymentError.isEmpty
                                            ? null
                                            : controller.requiredPaymentError,
                                        suffixIcon: controller.isLoading.value
                                            ? SizedBox(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        color:
                                                            theme.primaryColor),
                                              )
                                            : null,
                                      ),
                                      keyboardType: TextInputType.number,
                                    )),
                                const SizedBox(height: 24),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Obx(() => ElevatedButton(
                                          onPressed: controller.isSaving.value
                                              ? null
                                              : controller.save,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: theme.primaryColor,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 12),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: controller.isSaving.value
                                              ? SizedBox(
                                                  height: 20,
                                                  width: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              : Text(
                                                  'حفظ',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16),
                                                ),
                                        )),
                                    controller.isChanged
                                        ? ElevatedButton(
                                            onPressed: () {
                                              controller.cancel();
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 12),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: Text(
                                              'إلغاء',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16),
                                            ),
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
