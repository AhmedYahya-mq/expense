import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:party_planner/controllers/income_form_controller.dart';
import 'package:party_planner/core/widgets/header.dart';
import 'package:party_planner/core/widgets/transaction/card_transaction_item.dart';
import 'package:party_planner/view/forms/income_form_screen.dart';

class IncomeForm extends StatelessWidget {
  const IncomeForm({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final controller = Get.put(IncomeFormController());

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const IncomeFormScreen());
        },
        backgroundColor: theme.primaryColor,
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 30, bottom: 10, left: 10, right: 10),
          child: Column(
            children: [
              Header(theme: theme, title: "الدخل"),
              const SizedBox(height: 25),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value &&
                      controller.transactions.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (scrollInfo.metrics.pixels ==
                                scrollInfo.metrics.maxScrollExtent &&
                            !controller.isLoading.value &&
                            controller.hasMore.value) {
                          controller.loadTransactions();
                        }
                        return true;
                      },
                      child: Stack(
                        children: [
                          RefreshIndicator(
                            onRefresh: () =>
                                controller.loadTransactions(reset: true),
                            child: ListView.builder(
                              itemCount: controller.transactions.length + 1,
                              itemBuilder: (context, index) {
                                if (index == controller.transactions.length) {
                                  return controller.isLoading.value &&
                                          controller.hasMore.value
                                      ? const Center(
                                          child: CircularProgressIndicator())
                                      : const SizedBox.shrink();
                                }
                                final transaction =
                                    controller.transactions[index];
                                return Dismissible(
                                  key: Key(transaction.id ?? ''),
                                  confirmDismiss: (direction) async {
                                    bool confirm = await controller
                                        .confirmDeleteTransaction(index);
                                    if (!confirm) {
                                      return false;
                                    }
                                    confirm = await controller
                                        .removeTransaction(index);
                                    return confirm;
                                  },
                                  
                                  child: CardTransactionItem(
                                    icon: Icons.attach_money,
                                    title: transaction.income.supporterName ??
                                        transaction.user!.name ??
                                        '',
                                    subtitle: transaction.description ?? '',
                                    time: transaction.income.timeAgo ?? '',
                                    amount: transaction.amount!,
                                    isIncome: transaction.isIncome,
                                  ),
                                );
                              },
                            ),
                          ),
                          if (controller.isDeleting.value)
                            Container(
                              width: double.infinity,
                              height: double.infinity,
                              color: Colors.black.withOpacity(0.5),
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                        ],
                      ),
                    );
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
