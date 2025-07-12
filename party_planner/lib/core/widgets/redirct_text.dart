import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RedirectText extends StatelessWidget {
  final String textBeforeLink; // النص الذي يأتي قبل الرابط
  final String linkText; // النص الخاص بالرابط
  final VoidCallback onLinkPressed; // الوظيفة التي سيتم تنفيذها عند النقر على الرابط

  const RedirectText({
    super.key,
    required this.textBeforeLink,
    required this.linkText,
    required this.onLinkPressed, // تمرير الوظيفة التي سيتم استدعاؤها عند الضغط
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RichText(
      text: TextSpan(
        text: textBeforeLink,
        style: theme.textTheme.bodyMedium,
        children: <TextSpan>[
          TextSpan(
            text: linkText,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.blue, // لون الرابط
              decoration: TextDecoration.underline, // إضافة خط تحت الرابط
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = onLinkPressed, // استدعاء الوظيفة عند النقر
          ),
        ],
      ),
    );
  }
}
