/* Flutter Imports */
import 'package:flutter/material.dart';

class Palette {
  static const Color primary = Color(0xFFFFFFFF);
  static const Color secondary = Color(0xFF006400);
  static const Color background = Color(0xFFF2F2F0);

  static const Color primaryDark = Color(0xFF00171F);
  static const Color secondaryDark = Color(0xFF006400);
  static const Color backgroundDark = Color(0xFF111B21);

  static const Map<int, Color> gradient = {
    1: Color(0xFF004B23),
    2: Color(0xFF006400),
    3: Color(0xFF007200),
    4: Color(0xFF008000),
    5: Color(0xFF38B000),
    6: Color(0xFF70E000),
    7: Color(0xFF9EF01A),
    8: Color(0xFFCCFF33),
  };

  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color placeholder = Color(0xFFF7F7F8);

  static const Color error = Color(0xFFff0033);
  static const Color success = Color(0xFF00ff33);
  static const Color warning = Color(0xFFffcc00);
  static const Color info = Color(0xFF00ccff);

  static const Color border = Color(0xFFd3d3d3);
  static const Color shadow = Color(0xFF000000);
  static const Color disabled = Color(0xFFa9a9a9);
  static const Color divider = Color(0xFFe0e0e0);

  static const Color transparent = Color(0x00000000);

  static Color getColor(int color) {
    return gradient[color] ?? Colors.transparent;
  }
}
