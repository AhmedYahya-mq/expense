import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;

import 'package:party_planner/core/routes/app_routes.dart';
import 'package:party_planner/models/transaction.dart';

class PaymentCard extends StatelessWidget {
  const PaymentCard({
    super.key,
    required this.transaction,
  });

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.paymentDetails, arguments: transaction);
      },
      child: Container(
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
                        width: 50,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                width: 2, color: theme.primaryColor)),
                        child: Icon(
                          Icons.wallet_rounded,
                          size: 40,
                          color: theme.primaryColor,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 180,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "المستلم: ${transaction.income.recipient!.name}",
                              style: theme.textTheme.titleLarge!.copyWith(
                                  fontSize: 14, fontWeight: FontWeight.w700),
                              softWrap: false,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "معرف المستلم: ${transaction.income.recipient!.id}",
                              style: theme.textTheme.labelMedium!
                                  .copyWith(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  SizedText(
                      text:
                          "دفع تكاليف الحفل في ${transaction.income.formatDate}"),
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
                        width: 60,
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
                        transaction.amount.toString(),
                        style: theme.textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        transaction.income.timeAgo!,
                        style: theme.textTheme.displaySmall!
                            .copyWith(fontSize: 12),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 8,
                  ),
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
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 14, color: Colors.green, fontWeight: FontWeight.w400),
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.clip,
          ),
          SizedBox(
            height: 3,
          ),
          Row(
            children: [
              for (int i = 0; i < (textSize.width / 10); i++)
                Container(
                  width: 5,
                  height: 2,
                  margin: EdgeInsets.only(left: 5),
                  color: Colors.green,
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
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
      ),
      maxLines: 1,
      textDirection: ui.TextDirection.rtl,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }
}
