import 'package:flutter/material.dart';
import 'package:hdoom/utils/app_colors.dart';

// ──────────────────────────────────────────────
// CUSTOMIZABLE VARIABLES — Change these to style
// ──────────────────────────────────────────────

// Colors
final _defaultLoaderColor = AppColors.green[50]!;

// ──────────────────────────────────────────────

class CustomLoading extends StatelessWidget {
  final Color? color;
  const CustomLoading({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(color: color ?? _defaultLoaderColor),
    );
  }
}
