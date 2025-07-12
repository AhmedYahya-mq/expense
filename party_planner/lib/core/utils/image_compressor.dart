import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';

class ImageCompressor {
  // دالة static لالتقاط صورة من المعرض
  static Future<File?> pickImage(String imageSource) async {
    ImageSource source =
        imageSource == 'camera' ? ImageSource.camera : ImageSource.gallery;
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      return null;
    }
  }

  // دالة static لضغط الصورة
  static Future<File?> compressImage(File file, {int quality = 50}) async {
    try {
      final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        '${file.absolute.path}_compressed.jpg',
        quality: quality,
      );

      if (result != null) {
        return File(result.path);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error compressing image: $e');
      return null;
    }
  }

  // دالة static لالتقاط صورة وضغطها مباشرة
  static Future<File?> pickAndCompressImage(String imageSource,
      {int quality = 50}) async {
    File? image = await pickImage(imageSource);
    print('حجم الملف: ${image!.lengthSync() / 1024 /1024} MB');
    image = await compressImage(image, quality: quality);
    print('حجم الملف: ${image!.lengthSync() / 1024 / 1024} MB');
    return image;
    }

  // دالة static لمسح مستند باستخدام cunning_document_scanner
  static Future<List<File>?> scanDocument() async {
    try {
      List<String>? images = await CunningDocumentScanner.getPictures(
            noOfPages: 1,
            isGalleryImportAllowed: true,
          ) ??
          [];
      if (images.isNotEmpty) {
        return images.map((path) => File(path)).toList();
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error scanning document: $e');
      return null;
    }
  }

  // دالة static لمسح مستند وضغط الصور
  static Future<List<File>?> scanAndCompressDocuments(
      {int quality = 50}) async {
    final scannedImages = await scanDocument();
    int fileSize = scannedImages!.first.lengthSync(); // حجم الملف بالبايت
    print('حجم الملف: ${fileSize / 1024} KB');
    List<File> compressedImages = [];
    for (var image in scannedImages) {
      final compressedImage = await compressImage(image, quality: quality);
      if (compressedImage != null) {
        print('حجم الملف: ${compressedImage.lengthSync() / 1024} KB');
        compressedImages.add(compressedImage);
      }
    }
    return compressedImages;
    }
}
