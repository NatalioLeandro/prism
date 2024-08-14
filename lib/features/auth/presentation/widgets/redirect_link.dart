/* Flutter Imports */
import 'package:flutter/material.dart';

class RedirectLink extends StatelessWidget {
  final String text;
  final String link;
  final VoidCallback onTap;

  const RedirectLink({
    super.key,
    required this.text,
    required this.link,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onPrimary;
    final linkColor = theme.colorScheme.secondary;

    return GestureDetector(
      onTap: onTap,
      child: RichText(
        text: TextSpan(
          text: '$text ',
          style: TextStyle(
            color: textColor,
            fontSize: 12,
          ),
          children: [
            TextSpan(
              text: link,
              style: TextStyle(
                color: linkColor,
                fontSize: 12,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}