import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:party_planner/controller/auth/login_screen_controller.dart';
import 'package:party_planner/core/widgets/header.dart';
import 'package:party_planner/enums/transaction_category.dart';
import 'package:party_planner/models/transaction.dart';
import 'package:party_planner/models/user.dart';

class TransactionDetailsScreen extends StatelessWidget {
  TransactionDetailsScreen({super.key});
  final UserModel user = Get.find<LoginScreenController>().user;
  void showImagePopup(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 3.0,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) =>
                    Image.asset("assets/no-file.png", fit: BoxFit.cover),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Transaction transaction = Get.arguments as Transaction;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Header(theme: theme, title: "تفاصيل العملية"),
              const SizedBox(height: 15),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (transaction.attachment != null &&
                          transaction.attachment!.isNotEmpty)
                        GestureDetector(
                          onTap: () => showImagePopup(
                              context, transaction.attachment ?? ""),
                          child: SizedBox(
                            height: 200,
                            child: CachedNetworkImage(
                              imageUrl: transaction.attachment!,
                              fit: BoxFit.cover,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) {
                                double progress =
                                    downloadProgress.progress ?? 0;
                                return Center(
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      CircularProgressIndicator(
                                        value: progress,
                                        strokeWidth: 3,
                                      ),
                                      Text(
                                        "${(progress * 100).toInt()}%",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              errorWidget: (context, url, error) =>
                                  imageError(),
                            ),
                          ),
                        )
                      else
                        imageError(),
                      const SizedBox(height: 10),
                      transaction.isIncome
                          ? _buildTransactionDetailsIncome(
                              theme, transaction, isDarkMode)
                          : _buildTransactionDetailsExpense(
                              theme, transaction, isDarkMode),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox imageError() {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Image.asset(
        "assets/no-file.png",
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildTransactionDetailsIncome(
      ThemeData theme, Transaction transaction, bool isDarkMode) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: isDarkMode ? Colors.grey[900] : Colors.white,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RowDetails(
                  theme: theme,
                  title: "رقم العملية",
                  subtitle: transaction.id.toString()),
              RowDetails(
                  theme: theme,
                  title: "نوع العملية",
                  subtitle: transaction.transactionType!),
              RowDetails(
                  theme: theme,
                  title: "الفئة",
                  subtitle: transaction.category!.description),
              RowDetails(
                  theme: theme,
                  title: "التاريخ",
                  subtitle: transaction.createdAt ?? ""),
              RowDetails(
                  theme: theme,
                  title: (transaction.income.supporterName != null &&
                          transaction.income.supporterName!.isNotEmpty)
                      ? "أسم مقدم الدعم"
                      : "أسم الطالب",
                  subtitle: transaction.user!.name!),
              RowDetails(
                  theme: theme,
                  title: "أسم المستلم",
                  subtitle: transaction.income.recipient!.name!),
              if (transaction.income.supporterName != null &&
                  transaction.income.supporterName!.isNotEmpty)
                RowDetails(
                    theme: theme,
                    title: "أسم الداعم",
                    subtitle: transaction.income.supporterName!),
              RowDetails(
                theme: theme,
                title: "ملف مرفق",
                subtitle: transaction.attachment != null &&
                        transaction.attachment!.isNotEmpty
                    ? "يوجد"
                    : "لا يوجد",
              ),
              RowDetails(
                  theme: theme,
                  title: "المبلغ",
                  subtitle: "${transaction.amount!}+"),
              if (transaction.income.supporterName != null &&
                  transaction.income.supporterName!.isNotEmpty)
                RowDetails(
                    theme: theme,
                    title: "خصم مقدم الدعم",
                    subtitle: "${transaction.income.deductedAmount!}-"),
              Text(
                "الوصف",
                style: theme.textTheme.titleMedium?.copyWith(
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                transaction.description!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionDetailsExpense(
      ThemeData theme, Transaction transaction, bool isDarkMode) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: isDarkMode ? Colors.grey[900] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RowDetails(
                  theme: theme,
                  title: "رقم العملية",
                  subtitle: transaction.id.toString()),
              RowDetails(
                  theme: theme,
                  title: "نوع العملية",
                  subtitle: transaction.category!.description),
              RowDetails(
                  theme: theme,
                  title: "الأسم",
                  subtitle: transaction.user!.name!),
              RowDetails(
                  theme: theme,
                  title: "الغرض",
                  subtitle: transaction.expense.purpose!),
              if (transaction.category == TransactionCategory.transportation)
                RowDetails(
                    theme: theme,
                    title: "الوجهة",
                    subtitle: transaction.expense.destination!),
              if (transaction.category == TransactionCategory.transportation)
                RowDetails(
                    theme: theme,
                    title: "وسيلة النقل",
                    subtitle: transaction.expense.method!),
              RowDetails(
                theme: theme,
                title: "ملف مرفق",
                subtitle: transaction.attachment != null &&
                        transaction.attachment!.isNotEmpty
                    ? "يوجد"
                    : "لا يوجد",
              ),
              RowDetails(
                  theme: theme,
                  title: "المبلغ",
                  subtitle: "${transaction.amount!}-"),
              RowDetails(
                theme: theme,
                title: "الإدارة",
                subtitle: transaction.expense.approvedBy != null
                    ? "الموافقة من قبل ${transaction.expense.approvedBy!.name!}"
                    : "أنتظار الموافقة",
              ),
              RowDetails(
                theme: theme,
                title: "المالية",
                subtitle: transaction.expense.paidBy != null
                    ? "صرفة من قبل ${transaction.expense.paidBy!.name!}"
                    : "أنتظار الموافقة",
              ),
              RowDetails(
                  theme: theme,
                  title: "الوصف",
                  subtitle: transaction.description!),
            ],
          ),
        ),
      ),
    );
  }
}

class RowDetails extends StatelessWidget {
  const RowDetails({
    super.key,
    required this.theme,
    required this.title,
    required this.subtitle,
  });

  final ThemeData theme;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: RichText(
        text: TextSpan(
          style: theme.textTheme.labelLarge?.copyWith(
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
          ),
          children: [
            TextSpan(
              text: "$title: ",
              style: theme.textTheme.titleMedium?.copyWith(
                color: isDarkMode ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold, // تمييز العنوان
              ),
            ),
            TextSpan(
              text: subtitle,
            ),
          ],
        ),
      ),
    );
  }
}
