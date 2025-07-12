import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:party_planner/controller/auth/login_screen_controller.dart';
import 'package:party_planner/controller/document_controller.dart';
import 'package:party_planner/models/transaction.dart';
import 'package:party_planner/models/user.dart';

class DetailsPaymentScreen extends StatelessWidget {
  DetailsPaymentScreen({super.key});

  final controller = Get.put(DocumentController());
  final UserModel user = Get.find<LoginScreenController>().user;
  @override
  Widget build(BuildContext context) {
    Transaction transaction = Get.arguments as Transaction;
    ThemeData theme = Theme.of(context);
    String formattedDate =
        DateFormat("MMM dd,yyyy hh:mma").format(DateTime.now());
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text(
                      user.name!,
                      style: theme.textTheme.titleMedium,
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(Icons.arrow_forward_ios_outlined, size: 18,),
                    )
                  ],
                ),
                SizedBox(
                  height: 45,
                ),
                Text(
                  "${transaction.amount!} ريال",
                  style: theme.textTheme.displayLarge,
                ),
                SizedBox(
                  height: 40,
                ),
                InkWell(
                  onTap: () {
                    controller.generatePdf(transaction);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    constraints: BoxConstraints(
                      maxWidth: 200,
                    ),
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(color: theme.primaryColor),
                        borderRadius: BorderRadius.circular(15)),
                    child: Text(
                      "طباعة Pdf",
                      style: theme.textTheme.labelLarge!.copyWith(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 20,
                      color: Colors.green,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "مكتمل",
                      style: theme.textTheme.labelLarge!.copyWith(
                          color: Colors.green, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Divider(
                    endIndent: 25,
                    indent: 25,
                    color: theme.textTheme.displayLarge!.color),
                SizedBox(
                  height: 15,
                ),
                Text(
                  formattedDate,
                  style: theme.textTheme.titleMedium,
                ),
                SizedBox(
                  height: 25,
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        RowData(
                          theme: theme,
                          title: "المستلم",
                          body: transaction.income.recipient!.name!,
                        ),
                        RowData(
                          theme: theme,
                          title: "من",
                          body: user.name!,
                        ),
                        RowData(
                          theme: theme,
                          title: "رقم العمليه",
                          body: "#${transaction.id!}",
                        ),
                        RowData(
                          theme: theme,
                          title: "رقم العمليه",
                          body: formattedDate,
                        ),
                        Divider(color: theme.textTheme.displayLarge!.color),
                        SizedBox(
                          height: 15,
                        ),
                        RowData(
                          theme: theme,
                          title: "المدفوع",
                          body: "${transaction.amount} ريال",
                        ),
                        RowData(
                          theme: theme,
                          title: "المتبقي",
                          body: "${user.total_due_amount} ريال",
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RowData extends StatelessWidget {
  const RowData({
    super.key,
    required this.theme,
    required this.title,
    required this.body,
  });
  final String title;
  final String body;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium!.copyWith(fontSize: 16),
          ),
          Text(
            body,
            style: theme.textTheme.titleMedium!.copyWith(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
