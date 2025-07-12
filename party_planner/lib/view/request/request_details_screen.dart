import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:party_planner/controller/auth/login_screen_controller.dart';
import 'package:party_planner/controllers/request_controller.dart';
import 'package:party_planner/core/widgets/header.dart';
import 'package:party_planner/enums/expense_status.dart';
import 'package:party_planner/enums/role.dart';
import 'package:party_planner/enums/transaction_category.dart';
import 'package:party_planner/models/request.dart';
import 'package:party_planner/models/user.dart';

class RequestDetailsScreen extends StatelessWidget {
  RequestDetailsScreen({super.key});

  final UserModel user = Get.find<LoginScreenController>().user;
  final RequestController _controller = Get.find<RequestController>();
  late int index;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;
    index = Get.arguments is int ? Get.arguments : 0; // تحقق من صحة القيمة

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Column(
                children: [
                  Header(theme: theme, title: "تفاصيل الطلب"),
                  const SizedBox(height: 15),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildImageSection(context),
                          const SizedBox(height: 10),
                          Obx(() => _buildRequestDetails(
                              theme, _controller.requests[index], isDarkMode)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Obx(() {
              if (_controller.isUpdate.value) {
                return Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }

  // بناء قسم الصورة
  Widget _buildImageSection(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: 200,
          child: Obx(() {
            final attachment = _controller.requests[index].attachment;
            if (attachment == null || attachment.isEmpty) {
              return _buildImageError();
            } else {
              return GestureDetector(
                onTap: () => _showImagePopup(context, attachment),
                child: CachedNetworkImage(
                  imageUrl: attachment,
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, downloadProgress) {
                    final progress = downloadProgress.progress ?? 0;
                    return Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(value: progress),
                          Text(
                            "${(progress * 100).toInt()}%",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  errorWidget: (context, url, error) => _buildImageError(),
                ),
              );
            }
          }),
        ),
        if (isButtonAction())
          Positioned(
            bottom: 0,
            left: 20,
            child: IconButton.filled(
              onPressed: () async {
                await _controller.updateAttachment(index);
              },
              icon: const Icon(Icons.upload_file),
            ),
          ),
      ],
    );
  }

  bool isButtonAction() {
    return _controller.requests[index].category !=
              TransactionCategory.transportation &&
          ((user.id == _controller.requests[index].user!.id &&
                  _controller.requests[index].attachment == null) ||
              user.role == Role.head_of_financial_committee);
  }

  // عرض صورة بديلة في حالة الخطأ
  Widget _buildImageError() {
    return Image.asset(
      "assets/no-file.png",
      fit: BoxFit.contain,
    );
  }

  // عرض تفاصيل الطلب
  Widget _buildRequestDetails(
      ThemeData theme, Request request, bool isDarkMode) {
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
              _buildDetailRow(theme, "رقم الطلب", request.id.toString()),
              _buildDetailRow(theme, "نوع الطلب", request.category.description),
              _buildDetailRow(theme, "اسم مقدم الطلب", request.user!.name!),
              _buildDetailRow(theme, "الغرض", request.expense!.purpose!),
              if (request.category == TransactionCategory.transportation)
                _buildDetailRow(theme, "وسيلة النقل", request.expense!.method!),
              if (request.category == TransactionCategory.transportation)
                _buildDetailRow(theme, "الوجهة", request.expense!.destination!),
              _buildDetailRow(
                theme,
                "ملف مرفق",
                request.attachment != null && request.attachment!.isNotEmpty
                    ? "يوجد"
                    : "لا يوجد",
              ),
              _buildDetailRow(theme, "المبلغ", request.amount.toString()),
              _buildDetailRow(
                theme,
                "الإدارة",
                request.isDeclined && request.status == ExpenseStatus.pending
                    ? (request.expense!.approvedBy != null
                        ? "تم رفضك من قبل ${request.expense!.approvedBy!.name!}"
                        : "طلبك مرفوض")
                    : (request.expense!.approvedBy != null
                        ? "الموافقة من قبل ${request.expense!.approvedBy!.name!}"
                        : "أنتظار الموافقة"),
              ),
              _buildDetailRow(
                theme,
                "المالية",
                request.isDeclined
                    ? (request.expense!.paidBy != null
                        ? "تم رفضك من قبل ${request.expense!.paidBy!.name!}"
                        : "طلبك مرفوض")
                    : (request.expense!.paidBy != null
                        ? "الموافقة من قبل ${request.expense!.paidBy!.name!}"
                        : "أنتظار الموافقة"),
              ),
              if (request.rejectionReason != null &&
                  request.rejectionReason!.isNotEmpty)
                _buildDetailRow(theme, "سبب الرفض", request.rejectionReason!),
              _buildDetailRow(theme, "الوصف", request.description),
              const SizedBox(height: 20),
              if (((user.role == Role.head_of_financial_committee &&
                          request.status ==
                              ExpenseStatus.approved_by_management) ||
                      (user.role == Role.head_of_preparatory_committee &&
                          request.status == ExpenseStatus.pending)) &&
                  !request.isDeclined)
                _buildActionButtons(theme, request, isDarkMode),
            ],
          ),
        ),
      ),
    );
  }

  // بناء صف تفاصيل
  Widget _buildDetailRow(ThemeData theme, String title, String subtitle) {
    final bool isDarkMode = theme.brightness == Brightness.dark;
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
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(text: subtitle),
          ],
        ),
      ),
    );
  }

  // بناء أزرار الموافقة والرفض
  Widget _buildActionButtons(
      ThemeData theme, Request request, bool isDarkMode) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () => _controller.approveRequest(index),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          child: const Text("الموافقة", style: TextStyle(color: Colors.white)),
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: () => _showRejectDialog(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          child: const Text("رفض", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  // عرض نافذة الرفض
  void _showRejectDialog() {
    final theme = Theme.of(Get.context!);
    final bool isDarkMode =
        Theme.of(Get.context!).brightness == Brightness.dark;

    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: Text(
          "سبب الرفض",
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _controller.rejectionReason.value,
              decoration: InputDecoration(
                hintText: "أدخل سبب الرفض",
                hintStyle: TextStyle(
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                filled: true,
                fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[100],
              ),
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
              maxLength: 255,
              maxLines: 3,
            ),
            const SizedBox(height: 10),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[700] : Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "إلغاء",
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              final reason = _controller.rejectionReason.value.text.trim();
              if (reason.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "الرجاء إدخال سبب الرفض",
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                    backgroundColor:
                        isDarkMode ? Colors.grey[800] : Colors.grey[200],
                  ),
                );
                return;
              }
              _controller.rejectRequest(index);
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: theme.primaryColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: theme.primaryColor.withOpacity(0.3),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Text(
                "إرسال",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // عرض الصورة في نافذة منبثقة
  void _showImagePopup(BuildContext context, String imageUrl) {
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
}
