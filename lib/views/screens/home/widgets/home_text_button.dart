import 'package:flutter/material.dart';
import 'package:hdoom/utils/app_texts.dart';

/// A simple expanded text button used in the Home screen's action rows
/// (e.g. "Why this look?" / "Save Look").
class HomeTextButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const HomeTextButton({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Center(child: Text(title, style: AppTexts.tmdm)),
        ),
      ),
    );
  }
}
