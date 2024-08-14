/* Flutter Imports */
import 'package:flutter/material.dart';

class AuthTitle extends StatelessWidget {
  final String title;

  const AuthTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        fontFamily: 'Montserrat',
      ),
    );
  }
}
