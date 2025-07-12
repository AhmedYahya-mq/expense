import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:party_planner/controller/auth/login_screen_controller.dart';
import 'package:party_planner/controller/report_controller.dart';
import 'package:party_planner/controllers/history_transaction.dart';
import 'package:party_planner/core/widgets/transaction/pymenet_card.dart';
import 'package:party_planner/models/user.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class PaymentScreen extends StatelessWidget {
  final ReportController reportController = Get.put(ReportController());
  final HistoryTransaction history = Get.put(HistoryTransaction());
  final UserModel user = Get.find<LoginScreenController>().user;

  PaymentScreen({super.key});
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          reportController.generatePdf(history.transactions);
        },
        backgroundColor: theme.primaryColor,
        child: Icon(Icons.description),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Card(
              elevation: 2,
              shadowColor: theme.shadowColor,
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                padding: EdgeInsets.all(15),
                height: 350,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "سجل المدفوعات",
                          style: theme.textTheme.titleLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: Icon(Icons.arrow_forward_ios_outlined))
                      ],
                    ),
                    Spacer(),
                    RotatedBox(
                      quarterTurns: 0,
                      child: CircularPercentIndicator(
                        circularStrokeCap: CircularStrokeCap.round,
                        backgroundColor: const Color.fromARGB(255, 33, 33, 33),
                        radius: 70,
                        lineWidth: 6.0,
                        percent: (double.parse(user.percent_balance!) / 100) > 1
                            ? 1
                            : (double.parse(user.percent_balance!) / 100),
                        progressColor: theme.primaryColor,
                        center: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "الميزانية ",
                              style: theme.textTheme.labelLarge!
                                  .copyWith(fontSize: 14),
                            ),
                            Text(
                              "${user.total_due_amount} ريال",
                              style: theme.textTheme.labelLarge!.copyWith(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: 150,
                          height: 80,
                          decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: theme.primaryColor)),
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: 100,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius:
                                      BorderRadiusDirectional.vertical(
                                    bottom: Radius.circular(50),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("المدفوع"),
                                    Text(
                                      user.balance!,
                                      style: theme.textTheme.labelLarge!
                                          .copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        Container(
                          alignment: Alignment.center,
                          width: 150,
                          height: 80,
                          decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: theme.primaryColor)),
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: 100,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius:
                                      BorderRadiusDirectional.vertical(
                                    bottom: Radius.circular(50),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("المتبقي"),
                                    Text(
                                      user.total_due_amount!,
                                      style: theme.textTheme.labelLarge!
                                          .copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: SizedBox(
                child: Obx(
                  () {
                    return history.isLoading.value
                        ? Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            itemBuilder: (context, index) {
                              var transaction = history.transactions[index];
                              return PaymentCard(
                                transaction: transaction,
                              );
                            },
                            itemCount: history.transactions.length,
                          );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
