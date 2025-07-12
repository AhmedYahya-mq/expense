import 'package:get/get.dart';

class CustomTabsController extends GetxController {
  var containerPosition = 0.0.obs; // لحفظ الموضع الديناميكي للـ Container
  RxInt index = 0.obs;
  // تابع لتحديث الموضع بناءً على التبويب الذي تم اختياره
  void updatePosition(int index, double screenWidth, int tabCount) {
    this.index.value = index;
    // نحسب الموضع بناءً على ترتيب العنصر (index) وعدد التبويبات
    containerPosition.value = ((screenWidth / tabCount) - 0.1) * index;
  }

}
