import 'package:flutter/material.dart';
import 'package:hdoom/utils/app_colors.dart';

// ──────────────────────────────────────────────
// CUSTOMIZABLE VARIABLES — Change these to style
// ──────────────────────────────────────────────

// Colors
final _defaultLoaderColor = AppColors.green.shade500;

// ──────────────────────────────────────────────

class CustomLoading extends StatelessWidget {
  final Color? color;
  final double padding;
  const CustomLoading({super.key, this.color, this.padding = 16});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: CircularProgressIndicator(color: color ?? _defaultLoaderColor),
      ),
    );
  }
}
