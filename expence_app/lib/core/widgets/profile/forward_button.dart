import 'package:flutter/material.dart';

class ForwardButton extends StatelessWidget {
  final Function() onTap;
  const ForwardButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Icon(Icons.arrow_forward_ios_outlined),
      ),
    );
  }
}