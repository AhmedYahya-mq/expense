import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:party_planner/controller/auth/login_screen_controller.dart';
import 'package:party_planner/controllers/home_controller.dart';
import 'package:party_planner/core/widgets/transaction/card_transaction_item.dart';
import 'package:party_planner/core/widgets/home/card_budget.dart';
import 'package:party_planner/core/widgets/home/card_committee.dart';
import 'package:party_planner/core/widgets/home/welcome.dart';
import 'package:party_planner/core/routes/app_routes.dart';
import 'package:party_planner/enums/role.dart';
import 'package:party_planner/enums/transaction_category.dart';
import 'package:party_planner/models/user.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final UserModel user = Get.find<LoginScreenController>().user;
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await controller.initHome(); // استدعاء دالة التحديث
          },
          child: SingleChildScrollView(
            physics:
                const AlwaysScrollableScrollPhysics(), // يجعل السحب ممكناً دائماً
            child: Column(
              children: [
                const SizedBox(height: 10),
                Obx(
                  () => Welcome(
                    theme: theme,
                    name: user.getFullNameWithLastName(),
                    welcome: _getTimePeriod(),
                    isMessage: controller.isMessage.value,
                    isShowMessage:
                        (user.role == Role.head_of_financial_committee ||
                            user.role == Role.head_of_preparatory_committee),
                  ),
                ),
                const SizedBox(height: 10),
                Obx(
                  () => CardBudget(
                    theme: theme,
                    budget: controller.settings.isNotEmpty
                        ? controller.settings.first.value!
                        : "0",
                    income: controller.incomeSum,
                    expose: controller.expenseSum,
                    exposeIncome: controller.expenseIncome,
                    percent: controller.percent,
                  ),
                ),
                const SizedBox(height: 10),
                Obx(() {
                  if (controller.isLoading.value) {
                    return const SizedBox(
                      height: 85,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else {
                    return SizedBox(
                      height: 85,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: controller.committees.entries.map((entry) {
                          final role = entry.key;
                          final balance = entry.value;
                          return GestureDetector(
                            onTap: () {
                              Get.toNamed(AppRoutes.transaction, arguments: {
                                "title": role.description,
                                'role': role,
                                'user': user,
                                'link': '/get/expenses/${role.name}',
                              });
                            },
                            child: CardCommittee(
                              balance: balance,
                              icon: role.icon,
                              name: role.description,
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }
                }),
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: isDarkMode ? Colors.grey[900] : Colors.white,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "سجل المعاملات",
                              style: theme.textTheme.titleLarge?.copyWith(
                                color:
                                    isDarkMode ? Colors.white : Colors.black87,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Get.toNamed(AppRoutes.transaction, arguments: {
                                  "title": "المعاملات",
                                  "isAll": true,
                                  'link': '/get/transactions',
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text(
                                  "الكل",
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: theme.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Obx(() {
                        if (controller.isLoading.value) {
                          return const SizedBox(
                            height: 200,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        } else {
                          return ListView.builder(
                            shrinkWrap: true, // يمنع التمرير داخل `ListView`
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(8),
                            itemBuilder: (context, index) {
                              var transaction = controller.transactions[index];
                              return GestureDetector(
                                onTap: () => Get.toNamed(
                                    AppRoutes.transactionDetail,
                                    arguments: transaction),
                                child: CardTransactionItem(
                                  icon: transaction.category!.icon,
                                  title: transaction.user
                                          ?.getFullNameWithLastName() ??
                                      "مجهول",
                                  subtitle: transaction.description ?? "",
                                  time: transaction.timeAgo ?? "",
                                  amount: transaction.amount ?? "0.0",
                                  isIncome: transaction.isIncome,
                                ),
                              );
                            },
                            itemCount: controller.transactions.length,
                          );
                        }
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 20), // تجنب لصق العناصر بأسفل الشاشة
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getTimePeriod() {
    final now = DateTime.now();
    return (now.hour >= 6 && now.hour < 18) ? "صباح الخير" : "مساء الخير";
  }
}
