import 'package:flutter/material.dart';

class AppColors {
  // Base
  static const Color white = Color(0xFFFFFFFF);
  static const Color bg = Color(0xFFFAF9F6);
  static const Color red = Color(0xFFDC2626);

  // Green
  static const MaterialColor green = MaterialColor(0xFF005B36, {
    25: Color(0xFFF3F8F6),
    50: Color(0xFFE6EFEB),
    100: Color(0xFFC4D8D0),
    200: Color(0xFF8EB9A6),
    300: Color(0xFF549178),
    400: Color(0xFF2A7657),
    500: Color(0xFF005B36),
    600: Color(0xFF004D2E),
    700: Color(0xFF004126),
    800: Color(0xFF00311D),
    900: Color(0xFF002315),
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
