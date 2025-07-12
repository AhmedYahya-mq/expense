import 'package:flutter/material.dart';
import 'package:party_planner/core/widgets/header.dart';

class ExpenseForm extends StatelessWidget {
const ExpenseForm({ super.key });

  @override
  Widget build(BuildContext context){
    ThemeData theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 30, bottom: 10, left: 10, right: 10),
          child: Column(
            children: [
              Header(theme: theme, title: "المستخدمين"),
              const SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}