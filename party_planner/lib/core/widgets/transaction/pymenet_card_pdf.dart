import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

class PaymentCard extends StatelessWidget {
  const PaymentCard({
    super.key,
    required this.studentName,
    required this.paidAmount,
    required this.totalAmount,
    required this.paymentDate,
  });

  final String studentName;
  final double paidAmount;
  final double totalAmount;
  final DateTime paymentDate;

  // تنسيق الأرقام المالية
  String formatCurrency(double amount) {
    return NumberFormat("#,##0", "en_US").format(amount);
  }


  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      height: 130,
      margin: EdgeInsets.only(bottom: 15, left: 15),
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor,
            offset: Offset(1, 1),
            blurRadius: 5.0,
            spreadRadius: 1,
          )
        ],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          topLeft: Radius.circular(30),
        ),
      ),
      child: Container(
        margin: EdgeInsets.only(top: 10, right: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(width: 2, color: theme.primaryColor)),
                      child: Icon(
                        Icons.wallet_rounded,
                        size: 40,
                        color: theme.primaryColor,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "المستلم: أحمد يحيى",
                          style: theme.textTheme.titleLarge!.copyWith(fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "معرف المستلم: 25421",
                          style: theme.textTheme.labelMedium,
                        ),
                      ],
                    ),
                  ],
                ),
                Spacer(),
                SizedText(text: "دفع تكاليف الحفل في 24 مايو 2018"),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
            Row(
              children: [
                Column(
                  children: [
                    Container(
                      width: 80,
                      height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text("مكتمل"),
                    ),
                    Spacer(),
                    Text(
                      "20000 ريال",
                      style: theme.textTheme.titleMedium!
                          .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      "قبل يومين",
                      style:
                          theme.textTheme.displaySmall!.copyWith(fontSize: 14),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                SizedBox(width: 8,),
                Container(
                  width: 5,
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    color: theme.primaryColor,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class SizedText extends StatelessWidget {
  const SizedText({
    super.key,
    required this.text,
  });
  final String text;
  @override
  Widget build(BuildContext context) {
    Size textSize = _textSize();
    return SizedBox(
      height: 30,
      child: Column(
        children: [
          Text(
            text,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontSize: 16, color: Colors.green),
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.clip,
          ),
          SizedBox(
            height: 3,
          ),
          Row(
            children: [
              for (int i = 0; i < (textSize.width / 5); i++)
                i.isEven
                    ? Container(
                        width: 5,
                        height: 2,
                        color: Colors.green,
                      )
                    : Container(
                        width: 5,
                        height: 2,
                        color: Theme.of(context).cardColor,
                      ),
            ],
          )
        ],
      ),
    );
  }

  Size _textSize() {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: 16,
        ),
      ),
      maxLines: 1,
      textDirection: ui.TextDirection.rtl,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }
}
