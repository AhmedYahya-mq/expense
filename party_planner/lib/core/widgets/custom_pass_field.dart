import 'package:flutter/material.dart';

class CustomPasswordField extends StatelessWidget {
  final String hintText;
  final IconData? icon;
  final bool obscureText;
  final ValueChanged<String> onChanged;
  final void Function()? toggleObscureText;

  const CustomPasswordField({
    required this.hintText,
    this.icon,
    this.obscureText = false,
    required this.onChanged,
    super.key,
    this.toggleObscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
          hintText: hintText,
          prefixIcon: icon != null ? Icon(icon) : null,
          suffixIcon: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: toggleObscureText,
          )),
      onChanged: onChanged,
    );
  }
}
