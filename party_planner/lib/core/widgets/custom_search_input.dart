
import 'package:flutter/material.dart';

class CustomSearchInput extends StatelessWidget {
  const CustomSearchInput({super.key});

  @override
  Widget build(BuildContext context) {
    // اختيار السمة بناءً على الوضع
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white, // تغيير الخلفية حسب الوضع
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black.withOpacity(0.3) : Colors.grey.withOpacity(0.2),
            blurRadius: 8.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: isDarkMode ? Colors.white : Colors.blueGrey),
          SizedBox(width: 8.0),
          Expanded(
            child: TextField(
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
              decoration: InputDecoration(
                hintText: "بحث",
                hintStyle: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.blueGrey[400]),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}