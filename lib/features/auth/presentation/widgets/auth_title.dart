/* Flutter Imports */
import 'package:flutter/material.dart';

/* Project Imports */
// import 'package:prism/core/themes/palette.dart';

class AuthTitle extends StatelessWidget {
  final String title;

  const AuthTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ClipRRect(
        //   borderRadius: BorderRadius.circular(20),
        //   child: Image.asset(
        //     'assets/icon/icon.png',
        //     height: 100,
        //   ),
        // ),
        // const SizedBox(height: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
          ),
        ),
      ],
    );
  }
}
