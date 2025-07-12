import 'package:flutter/material.dart';

class OrderTrackingScreen extends StatelessWidget {
  // قائمة مراحل تتبع الطلب
  final List<String> stages = [
    "تم استلام الطلب",
    "جاري التجهيز",
    "جاري الشحن",
    "تم التسليم"
  ];

  final int currentStage = 2;

   OrderTrackingScreen({super.key}); // المرحلة الحالية (يمكن تغييرها)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("تتبع الطلب"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "حالة الطلب:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: stages.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      // النقطة (المرحلة)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // العمود الذي يحتوي على النقطة والخط
                          Column(
                            children: [
                              // النقطة
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: index <= currentStage
                                      ? Colors.blue
                                      : Colors.grey,
                                ),
                                child: Center(
                                  child: Text(
                                    "${index + 1}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              // الخط العمودي بين النقاط
                              if (index < stages.length - 1)
                                Container(
                                  width: 2,
                                  height: 50, // ارتفاع الخط
                                  color: index < currentStage
                                      ? Colors.blue
                                      : Colors.grey,
                                ),
                            ],
                          ),
                          SizedBox(width: 16), // مسافة بين النقطة والنص
                          // نص المرحلة
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  stages[index],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: index <= currentStage
                                        ? Colors.blue
                                        : Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 8),
                                if (index == currentStage)
                                  Text(
                                    "الطلب في هذه المرحلة",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.blue,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // مسافة بين كل مرحلة وأخرى
                      if (index < stages.length - 1) SizedBox(height: 16),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
