import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
    required this.theme,
    required this.title,
  });

  final ThemeData theme;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge,
        ),
        Spacer(),
        IconButton(
          onPressed: (){
            Get.back();
          },
          icon: Icon(Icons.arrow_forward_ios_outlined),
        ),
      ],
    );
  }
}
