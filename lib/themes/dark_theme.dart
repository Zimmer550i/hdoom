import 'package:flutter/material.dart';
import 'package:hdoom/utils/app_colors.dart';

ThemeData dark() => ThemeData(
  fontFamily: "Georama",
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.bg,
  colorScheme: ColorScheme.dark(
    primary: AppColors.green,
    secondary: AppColors.green.shade300,
    surface: AppColors.black.shade800,
  ),
);
