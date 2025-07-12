import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:party_planner/controller/auth/login_screen_controller.dart';
import 'package:party_planner/controllers/load_transaction_controller.dart';
import 'package:party_planner/core/widgets/transaction/card_transaction_item.dart';
import 'package:party_planner/core/widgets/transaction/char_analys.dart';
import 'package:party_planner/core/routes/app_routes.dart';
import 'package:party_planner/enums/role.dart';
import 'package:party_planner/enums/transaction_category.dart';
import 'package:party_planner/models/user.dart';

class TransactionsScreen extends StatelessWidget {
  TransactionsScreen(
      {super.key, this.title, this.link, this.role, this.isBack = false});
  String? title;
  String? link;
  Role? role;
  bool? isBack;

  @override
  Widget build(BuildContext context) {
    final UserModel user = Get.find<LoginScreenController>().user;
    final data = Get.arguments ?? {};
    final LoadTransactionController controller =
        Get.put(LoadTransactionController());
    ThemeData theme = Theme.of(context);
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    link = data['link'] ?? link;
    role = data['role'] ?? role;
    title = data['title'] ?? title;
    controller.initIncome(link);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(top: 10),
            width: double.infinity,
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent &&
                    !controller.isLoading.value) {
                  controller.loadMore(link!);
                }
                return true;
              },
              child: RefreshIndicator(
                onRefresh: () async {
                  await controller.initIncome(link);
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // العنوان وأزرار الرجوع
                      Row(
                        children: [
                          Text(
                            title!,
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: isDarkMode ? Colors.white : Colors.black87,
                            ),
                          ),
                          const Spacer(),
                          if (isBack!)
                            IconButton(
                              onPressed: () => Navigator.of(context).pop(),
                              icon: Icon(
                                Icons.arrow_forward_ios_outlined,
                                color:
                                    isDarkMode ? Colors.white : Colors.black87,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 5),

                      // بطاقة التحليلات
                      Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        color: isDarkMode ? Colors.grey[900] : Colors.white,
                        child: Obx(() {
                          if (controller.isLoading.value) {
                            return const SizedBox(
                              height: 200,
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          return analysesChart(controller);
                        }),
                      ),
                      const SizedBox(height: 10),

                      // بطاقة سجل المعاملات
                      Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        color: isDarkMode ? Colors.grey[900] : Colors.white,
                        child: Container(
                          constraints: BoxConstraints(
                            minHeight:
                                MediaQuery.of(context).size.height * 0.55,
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Text(
                                      "سجل المعاملات",
                                      style:
                                          theme.textTheme.titleMedium?.copyWith(
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Obx(() {
                                if (controller.isLoading.value) {
                                  return const SizedBox(
                                    height: 200,
                                    child: Center(
                                        child: CircularProgressIndicator()),
                                  );
                                } else if (controller.transactions.isEmpty) {
                                  return Center(
                                    child: Text(
                                      "لا توجد معاملات متاحة",
                                      style:
                                          theme.textTheme.bodyMedium?.copyWith(
                                        color: isDarkMode
                                            ? Colors.grey[400]
                                            : Colors.grey[600],
                                      ),
                                    ),
                                  );
                                } else {
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: const EdgeInsets.all(8),
                                    itemCount:
                                        controller.transactions.length + 1,
                                    itemBuilder: (context, index) {
                                      if (index <
                                          controller.transactions.length) {
                                        var transaction =
                                            controller.transactions[index];
                                        return GestureDetector(
                                          onTap: () => Get.toNamed(
                                              AppRoutes.transactionDetail,
                                              arguments: transaction),
                                          child: CardTransactionItem(
                                            icon: transaction.category!.icon,
                                            title: transaction.user
                                                    ?.getFullNameWithLastName() ??
                                                "مجهول",
                                            subtitle:
                                                transaction.description ?? "",
                                            time: transaction.timeAgo ?? "",
                                            amount: transaction.amount ?? "0.0",
                                            isIncome: transaction.isIncome,
                                          ),
                                        );
                                      } else {
                                        return controller.hasMore.value
                                            ? const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              )
                                            : const SizedBox.shrink();
                                      }
                                    },
                                  );
                                }
                              }),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      // زر الإضافة العائم
      floatingActionButton: (role == user.role)
          ? FloatingActionButton(
              onPressed: () => Get.toNamed(AppRoutes.requestEntry),
              backgroundColor: isDarkMode ? Colors.grey[800] : Colors.blue,
              child: Icon(
                Icons.add,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            )
          : null,
    );
  }

  Widget analysesChart(LoadTransactionController controller) {
    return SizedBox(
      height: 250,
      width: double.infinity,
      child: PieChartSample2(
        total: controller.analyses,
      ),
    );
  }
}
