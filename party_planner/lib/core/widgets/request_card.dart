import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:party_planner/controller/auth/login_screen_controller.dart';
import 'package:party_planner/core/routes/app_routes.dart';
import 'package:party_planner/enums/expense_status.dart';
import 'package:party_planner/enums/role.dart';
import 'package:party_planner/enums/transaction_category.dart';
import 'package:party_planner/models/request.dart';

class RequestCard extends StatelessWidget {
  const RequestCard({
    super.key,
    required this.theme,
    required this.request,
    this.isSelf = false,
    required this.index,
  });

  final ThemeData theme;
  final Request request;
  final bool isSelf;
  final int index;

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.requestsDetails, arguments: index),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
          gradient: LinearGradient(
            colors: isDarkMode
                ? [Colors.grey[800]!, Colors.grey[900]!]
                : [theme.primaryColor.withOpacity(0.1), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: isDarkMode
                ? Colors.grey[700]!
                : theme.primaryColor.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? theme.primaryColor.withOpacity(0.2)
                    : theme.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                request.category.icon,
                color: isDarkMode ? Colors.white : theme.primaryColor,
                size: 30,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    request.category.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    request.expense!.committee_label!.description,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: isDarkMode ? Colors.grey[400] : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelf)
              if (request.isDeclined)
                trailing(isDarkMode, label: "مرفوض", color: Colors.red)
              else
                trailing(isDarkMode,
                    label: request.status.description,
                    color: request.status.color)
            else
              newRequest(request.expense!.timeAgo!, isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget newRequest(String timeAgo, bool isDarkMode) {
    bool isFinancial = Get.find<LoginScreenController>().user.role! ==
        Role.head_of_financial_committee;
    bool isPreparatory = Get.find<LoginScreenController>().user.role! ==
        Role.head_of_preparatory_committee;
    if ((isPreparatory && request.status == ExpenseStatus.pending) &&
        !request.isDeclined) {
      return trailing(isDarkMode);
    }
    if ((isFinancial &&
            request.status == ExpenseStatus.approved_by_management) &&
        !request.isDeclined) {
      return trailing(isDarkMode);
    }
    return Text(
      timeAgo,
      style: theme.textTheme.labelSmall?.copyWith(
        color: isDarkMode ? Colors.grey[400] : Colors.black54,
      ),
    );
  }

  Column trailing(bool isDarkMode,
      {String label = "جديد", Color color = Colors.green}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          request.expense!.timeAgo!,
          style: theme.textTheme.labelSmall?.copyWith(
            color: isDarkMode ? Colors.grey[400] : Colors.black54,
          ),
        ),
      ],
    );
  }
}
