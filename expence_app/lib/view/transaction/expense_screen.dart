import 'package:flutter/material.dart';
import 'package:party_planner/core/widgets/transaction/card_transaction_item.dart';
import 'package:party_planner/core/widgets/custom_search_input.dart';
import 'package:party_planner/core/widgets/custom_tabs.dart';

class ExpenseScreen extends StatelessWidget {
  const ExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.only(top: 20),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "المصروفات",
                style: theme.textTheme.titleLarge,
              ),
              SizedBox(
                height: 10,
              ),
              CustomSearchInput(),
              SizedBox(
                height: 10,
              ),
              CustomTabs(theme: theme),
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
                            amount: "1,500",
                            isIncome: false,
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
    );
  }
}

