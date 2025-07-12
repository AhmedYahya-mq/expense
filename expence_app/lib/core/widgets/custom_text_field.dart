import 'package:flutter/material.dart';
import 'package:party_planner/core/utils/theme_helper.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final IconData? icon;
  final ValueChanged<String> onChanged;

  const CustomTextField({
    required this.hintText,
    this.icon,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: ThemeHelper.inputDecoration(
        hintText: hintText,
        icon: icon,
      ),
      onChanged: onChanged,
    );
  }
}
