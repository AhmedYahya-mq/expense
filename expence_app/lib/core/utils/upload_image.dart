// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:path/path.dart';

// class UploadImage {
//   static Future<String?> uploadFile(File file) async {
//     try {
//       String fileName = basename(file.path);
//       Reference storageReference = FirebaseStorage.instance.ref().child('uploads/$fileName');
//       UploadTask uploadTask = storageReference.putFile(file);
//       TaskSnapshot taskSnapshot = await uploadTask;
//       return await taskSnapshot.ref.getDownloadURL();
//     } catch (e) {
//       print("Error uploading image: $e");
//       return null;
//     }
//   }
// }
