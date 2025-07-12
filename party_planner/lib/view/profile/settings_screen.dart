import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:party_planner/core/routes/app_routes.dart';
import 'package:party_planner/core/widgets/header.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 30, bottom: 10, left: 10, right: 10),
          child: Column(
            children: [
              Header(theme: theme, title: "الإعدادات"),
              const SizedBox(
                height: 25,
              ),
              const Wrap(
                direction: Axis.horizontal,
                children: [
                  ItemSetting(
                    icon: Icons.balance,
                    label: "الميزانية",
                    page: AppRoutes.budget,
                  ),
                  ItemSetting(
                    icon: Icons.person,
                    label: "المستخدمين",
                    page: AppRoutes.users,
                  ),
                  ItemSetting(
                    icon: Icons.trending_up,
                    label: "الدخل",
                    page: AppRoutes.income,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ItemSetting extends StatelessWidget {
  const ItemSetting({
    super.key,
    required this.label,
    required this.icon,
    required this.page,
  });
  final String label;
  final IconData icon;
  final String page;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(page),
      child: Card(
        elevation: 2,
        shadowColor: Theme.of(context).shadowColor,
        child: Container(
          width: 100,
          height: 100,
          padding: const EdgeInsets.all(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 35,
              ),
              SizedBox(
                height: 5,
              ),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}
