import 'package:flutter/material.dart';

class CardBudget extends StatelessWidget {
  const CardBudget({
    super.key,
    required this.theme,
    required this.budget,
    required this.income,
    required this.expose,
    required this.exposeIncome,
    required this.percent,
  });
  final String budget;
  final int income;
  final int expose;
  final int exposeIncome;
  final double percent;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // تأكد من استخدام نفس الدرجة
      ),
      shadowColor: theme.shadowColor,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20), // لضمان قص المحتوى أيضًا
        child: Column(
          children: [
            Container(
              height: 120,
              padding: EdgeInsets.all(10),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: theme.primaryColor,
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(20))),
              child: Column(
                children: [
                  Text(
                    "الميزانية العامة للحفل",
                    style: theme.textTheme.labelLarge
                        ?.copyWith(color: theme.cardColor),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "$budget ريال",
                    style: theme.textTheme.titleLarge
                        ?.copyWith(color: theme.cardColor, fontSize: 25),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 23,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 5, right: 8),
                              child: Text(
                                "${percentBudgetAndIncome().toStringAsFixed(2)}%",
                                style: theme.textTheme.labelLarge
                                    ?.copyWith(color: Colors.black),
                              ),
                            ),
                            Icon(
                              Icons.arrow_drop_up_outlined,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "$income ريال",
                        style: theme.textTheme.labelLarge
                            ?.copyWith(color: theme.cardColor),
                      )
                    ],
                  )
                ],
              ),
            ),
            Container(
              height: 60,
              width: double.infinity,
              alignment: Alignment.center,
              child: SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ItemTransaction(
                      title: "الدخل",
                      theme: theme,
                      balance: income,
                      color: Colors.green,
                      icon: Icons.trending_up,
                    ),
                    ItemTransaction(
                      title: "المصروفات",
                      theme: theme,
                      balance: expose,
                      color: Colors.red,
                      icon: Icons.trending_down,
                    ),
                    ItemTransaction(
                      title: "الأجمالي",
                      theme: theme,
                      balance: exposeIncome,
                      color: Colors.blue,
                      icon: Icons.calculate,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  double percentBudgetAndIncome() {
    return percent * 100;
  }
}

class ItemTransaction extends StatelessWidget {
  const ItemTransaction({
    super.key,
    required this.theme,
    required this.balance,
    required this.color,
    required this.icon,
    required this.title,
  });

  final ThemeData theme;
  final int balance;
  final Color color;
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style:
              theme.textTheme.bodyMedium?.copyWith(color: color, fontSize: 14),
        ),
        Row(
          children: [
            Icon(
              icon,
              color: color, // اللون الأخضر يرمز إلى النمو
              size: 20.0,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              "$balance ريال",
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: color, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}
