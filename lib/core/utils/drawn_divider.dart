/* Flutter Imports */
import 'package:flutter/material.dart';

Widget dividerWithText(String text) {
  return Row(
    children: <Widget>[
      const Expanded(
        child: Divider(
          thickness: 1,
          color: Colors.grey,
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(text),
      ),
      const Expanded(
        child: Divider(
          thickness: 1,
          color: Colors.grey,
        ),
      ),
    ],
  );
}
