import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:party_planner/core/utils/permissions_helper.dart';
import 'package:party_planner/models/transaction.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class DocumentController extends GetxController {
  Future<void> generatePdf(Transaction transaction) async {
    // الحصول على الصلاحية المناسبة بناءً على إصدار النظام
    final storagePermission = await PermissionsHelper.getStoragePermission();

    bool isGranted =
        await PermissionsHelper.checkAndRequestPermission(storagePermission);
    if (!isGranted) return;
    showLoading();

    try {
      final pdf = pw.Document();
      final arabicFont = await _loadFont();
      final Uint8List logo = await _loadImage();
      final Uint8List cOsama = await _loadImage(image: "assets/cOsama.png");
      final Uint8List cAhmed = await _loadImage(image: "assets/cAhmed.png");
      final Uint8List c = await _loadImage(image: "assets/c.png");

      pdf.addPage(_buildReportPage(
        arabicFont: arabicFont,
        logo: logo,
        cAhmed: cAhmed,
        cOsama: cOsama,
        c: c,
        transaction: transaction,
      ));

      final filePath = await _savePdf(pdf);
      hideLoading();
      Get.snackbar("تم الحفظ ✅", "تم حفظ التقرير في: $filePath",
          backgroundColor: Colors.green.withOpacity(0.5));
    } catch (e) {
      hideLoading();
      print(e);
      Get.snackbar("خطأ ❌", "حدث خطأ أثناء إنشاء التقرير: $e",
          backgroundColor: Colors.red.withOpacity(0.5));
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
  Future<Uint8List> _loadImage({String image = 'assets/logo.png'}) async {
    final ByteData imageData = await rootBundle.load(image);
    return imageData.buffer.asUint8List();
  }

  /// إنشاء صفحة التقرير
  pw.Page _buildReportPage({
    required pw.Font arabicFont,
    required Uint8List logo,
    required Uint8List cAhmed,
    required Uint8List cOsama,
    required Uint8List c,
    required Transaction transaction,
  }) {
    return pw.Page(
      pageFormat: PdfPageFormat(400, double.infinity, marginAll: 20),
      textDirection: pw.TextDirection.rtl,
      build: (pw.Context context) => pw.Stack(
        children: [
          pw.Positioned.fill(
              child: pw.Opacity(
            opacity: 0.2,
            child: pw.Center(
              child: pw.Image(
                pw.MemoryImage(c),
                width: 250,
                height: 300,
                fit: pw.BoxFit.fill,
              ),
            ),
          )),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Image(pw.MemoryImage(logo), width: 100, height: 100),
              pw.SizedBox(height: 10),
              pw.Text("دفعة خبراء المستقبل",
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                    font: arabicFont,
                  )),
              pw.SizedBox(height: 25),
              pw.Text(
                "سند قبض رسوم حفل التخرج",
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  font: arabicFont,
                ),
              ),
              pw.SizedBox(height: 5),
              pw.Text(
                "تاريخ و الوقت: ${DateFormat("MMM dd,yyyy hh:mma").format(DateTime.now())}",
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  font: arabicFont,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Container(
                padding: pw.EdgeInsets.only(left: 20, right: 20, top: 20),
                width: 400,
                decoration: pw.BoxDecoration(
                  borderRadius: pw.BorderRadius.circular(20),
                  border: pw.Border.all(
                    color: PdfColors.black,
                    style: pw.BorderStyle.dashed,
                    width: 3,
                  ),
                ),
                child: pw.Column(children: [
                  _containerDocument(arabicFont, context, "المستلم",
                      transaction.income.recipient!.name),
                  _containerDocument(
                      arabicFont, context, "من", transaction.user!.name!),
                  _containerDocument(
                      arabicFont, context, "رقم العمليه", "#${transaction.id}"),
                  _containerDocument(
                      arabicFont,
                      context,
                      "التاريخ&الوقت",
                      DateFormat("MMM dd,yyyy hh:mma").format(
                          (transaction.income.createdAt != null &&
                                  transaction.income.createdAt!.isNotEmpty)
                              ? DateTime.parse(transaction.income.createdAt!)
                              : DateTime.now())),
                  pw.Divider(),
                  pw.SizedBox(
                    height: 15,
                  ),
                  _containerDocument(
                      arabicFont, context, "المدفوع", transaction.amount),
                  _containerDocument(arabicFont, context, "المتبقي",
                      transaction.user!.total_due_amount),
                ]),
              ),
              pw.SizedBox(
                height: 50,
              ),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Column(
                    children: [
                      pw.Text("رئيس اللجان التحضيرية",
                          style: pw.TextStyle(
                            font: arabicFont,
                          )),
                      pw.SizedBox(
                        height: 8,
                      ),
                      pw.Image(pw.MemoryImage(cOsama), width: 100, height: 100),
                    ],
                  ),
                  pw.Spacer(),
                  pw.Column(
                    children: [
                      pw.Text("رئيس المالية",
                          style: pw.TextStyle(
                            font: arabicFont,
                          )),
                      pw.SizedBox(
                        height: 8,
                      ),
                      pw.Image(pw.MemoryImage(cAhmed), width: 100, height: 100),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(
                height: 20,
              ),
            ],
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
      final filePath =
          "${targetDir.path}/سند_${DateTime.now().millisecondsSinceEpoch}.pdf";
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      return filePath;
    } catch (e) {
      throw Exception("حدث خطأ أثناء حفظ التقرير: $e");
    }
  }

  _containerDocument(arabicFont, context, title, body) {
    return pw.Container(
      margin: pw.EdgeInsets.only(bottom: 10),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              font: arabicFont,
            ),
          ),
          pw.Text(
            body,
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.normal,
              font: arabicFont,
            ),
          ),
        ],
      ),
    );
  }
}
