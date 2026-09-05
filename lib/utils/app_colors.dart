import 'package:flutter/material.dart';

class AppColors {
  // Base
  static const Color white = Color(0xFFFFFFFF);
  static const Color bg = Color(0xFFFAF9F6);
  static const Color red = Color(0xFFDC2626);

  // Green
  static const MaterialColor gold = MaterialColor(0xFFA37E2C, {
    25: Color(0xFFF3F8F6),
    50: Color(0xFFf6f2ea),
    100: Color(0xFFe2d7be),
    200: Color(0xFFd5c49e),
    300: Color(0xFFc1a972),
    400: Color(0xFFb59856),
    500: Color(0xFFa37e2c),
    600: Color(0xFF947328),
    700: Color(0xFF74591f),
    800: Color(0xFF5a4518),
    900: Color(0xFF443512),
  });

  // Gray
  static const MaterialColor black = MaterialColor(0xFF545454, {
    25: Color(0xFFFAFAFA),
    50: Color(0xFFF5F5F5),
    100: Color(0xFFE6E6E6),
    200: Color(0xFFB8B8B8),
    300: Color(0xFF545454),
    400: Color(0xFF333333),
    500: Color(0xFF2E2E2E),
    600: Color(0xFF292929),
    700: Color(0xFF242424),
    800: Color(0xFF1F1F1F),
    900: Color(0xFF1A1A1A),
  });
}
