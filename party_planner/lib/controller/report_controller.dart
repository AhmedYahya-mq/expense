import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:party_planner/core/utils/permissions_helper.dart';
import 'package:party_planner/models/transaction.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ReportController extends GetxController {
  Future<void> generatePdf(List<Transaction> transactions) async {
    // الحصول على الصلاحية المناسبة بناءً على إصدار النظام
    final storagePermission = await PermissionsHelper.getStoragePermission();

    // التحقق من صلاحية التخزين وطلبها إذا لزم الأمر
    bool isGranted =
        await PermissionsHelper.checkAndRequestPermission(storagePermission);
    if (!isGranted) {
      PermissionsHelper.showSnackbar(
        "خطأ ❌",
        "لم يتم منح الأذونات اللازمة للوصول إلى التخزين",
        Colors.red.withOpacity(0.5),
      );
      return;
    }

    showLoading();

    try {
      final pdf = pw.Document();
      final arabicFont = await _loadFont();
      final Uint8List imageBytes = await _loadImage();

      pdf.addPage(_buildReportPage(
        arabicFont: arabicFont,
        imageBytes: imageBytes,
        transactions: transactions,
      ));

      final filePath = await _savePdf(pdf);
      hideLoading();
      PermissionsHelper.showSnackbar(
        "تم الحفظ ✅",
        "تم حفظ التقرير في: $filePath",
        Colors.green.withOpacity(0.5),
      );
    } catch (e) {
      hideLoading();
      print(e);
      PermissionsHelper.showSnackbar(
        "خطأ ❌",
        "حدث خطأ أثناء إنشاء التقرير: $e",
        Colors.red.withOpacity(0.5),
      );
    }
  }

  /// عرض شاشة التحميل
  void showLoading() {
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: Center(child: CircularProgressIndicator()),
      ),
      barrierDismissible: false,
    );
  }

  /// إخفاء شاشة التحميل
  void hideLoading() {
    if (Get.overlayContext != null) {
      Navigator.of(Get.overlayContext!).pop();
    }
  }

  /// تحميل الخط العربي
  Future<pw.Font> _loadFont() async {
    final fontData = await rootBundle.load("fonts/Cairo-Regular.ttf");
    return pw.Font.ttf(fontData);
  }

  /// تحميل صورة من الأصول
  Future<Uint8List> _loadImage() async {
    final ByteData imageData = await rootBundle.load('assets/logo.png');
    return imageData.buffer.asUint8List();
  }

  /// إرجاع بيانات الجدول
  List<List<dynamic>> _getTableData(List<Transaction> transactions) {
    List<List<dynamic>> data = [
      ["تاريخ التسديد", "المبلغ", "المستلم"]
    ];

    List<List<dynamic>> transactionsData = transactions
        .map((Transaction transaction) => [
              transaction.income.formatDate,
              "${transaction.amount} ريال",
              transaction.income.recipient!.name,
            ])
        .toList(); // تحويل إلى List

    data.addAll(transactionsData); // إضافة البيانات بدون مشاكل

    print(data);
    return data;
  }

  /// إنشاء صفحة التقرير
  pw.Page _buildReportPage({
    required pw.Font arabicFont,
    required Uint8List imageBytes,
    required List<Transaction> transactions,
  }) {
    final String userName = transactions.first.user!.name!;
    final String userId = transactions.first.user!.id!;
    final String printDate = DateTime.now().toString().split(" ")[0];

    return pw.Page(
      pageFormat: PdfPageFormat.a4,
      textDirection: pw.TextDirection.rtl,
      build: (pw.Context context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Image(pw.MemoryImage(imageBytes), width: 100, height: 100),
          pw.SizedBox(height: 10),
          pw.Text("دفعة خبراء المستقبل",
              style: pw.TextStyle(
                fontSize: 20,
                fontWeight: pw.FontWeight.bold,
                font: arabicFont,
              )),
          pw.SizedBox(height: 20),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: <pw.Widget>[
              pw.Column(children: [
                pw.Text("الاسم: $userName",
                    style: pw.TextStyle(fontSize: 16, font: arabicFont)),
                pw.SizedBox(height: 5),
                pw.Text("المعرف: $userId",
                    style: pw.TextStyle(fontSize: 16, font: arabicFont)),
              ]),
              pw.Text("تاريخ الطباعة: $printDate",
                  style: pw.TextStyle(fontSize: 16, font: arabicFont)),
            ],
          ),
          pw.SizedBox(height: 20),
          pw.Table.fromTextArray(
            context: context,
            cellAlignment: pw.Alignment.center,
            headerStyle: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              font: arabicFont,
            ),
            cellStyle: pw.TextStyle(fontSize: 14, font: arabicFont),
            border: pw.TableBorder.all(),
            headerDecoration: pw.BoxDecoration(
              color: PdfColors.lightBlue, // تلوين رأس الجدول
            ),
            data: _getTableData(transactions),
          ),
          pw.SizedBox(height: 10),
          pw.Container(
            padding: pw.EdgeInsets.all(10),
            color: PdfColors.grey300,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("الإجمالي",
                    style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        font: arabicFont)),
                pw.Text(transactions.first.user!.balance!,
                    style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        font: arabicFont)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// حفظ ملف PDF
  Future<String> _savePdf(pw.Document pdf) async {
    try {
      // تحديد مسار التخزين الرئيسي
      final Directory targetDir = Directory("/storage/emulated/0/مصاريفنا");

      // التحقق من وجود المجلد، وإنشاؤه إن لم يكن موجودًا
      if (!targetDir.existsSync()) {
        targetDir.createSync(recursive: true);
      }

      // حفظ التقرير داخل المجلد
      final filePath = "${targetDir.path}/report.pdf";
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      return filePath;
    } catch (e) {
      throw Exception("حدث خطأ أثناء حفظ التقرير: $e");
    }
  }
}
