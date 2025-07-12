import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:party_planner/controllers/income_controller.dart';
import 'package:party_planner/core/widgets/transaction/card_transaction_item.dart';

class IncomeScreen extends StatelessWidget {
   IncomeScreen({super.key});
  final IncomeController  controller = Get.put(IncomeController());

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.only(top: 10),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "الدخل",
                  style: theme.textTheme.titleLarge,
                ),
                SizedBox(height: 5,),
                
                Expanded(
                  child: Card(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                "سجل المعاملات",
                                style: theme.textTheme.titleMedium,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: 10,
                            padding: const EdgeInsets.all(8.0),
                            itemBuilder: (context, index) => CardTransactionItem(
                              icon: Icons.account_balance_wallet,
                              title: 'Taxi',
                              subtitle: 'Uber',
                              time: '8:25 pm',
                              amount: "1,00",
                              isIncome: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
