import 'package:flutter/material.dart';
import 'package:hdoom/utils/app_colors.dart';
import 'package:hdoom/utils/app_texts.dart';

/// A compact article preview tile with a title, subtitle, and
/// circular thumbnail image. Used inside the Style News card.
class NewsArticleTile extends StatelessWidget {
  const NewsArticleTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(),
      child: Row(
        spacing: 12,
        children: [
          Expanded(
            child: Column(
              spacing: 12,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Street Style: Highlight from Riyadh Front",
                  style: AppTexts.tlgm.copyWith(height: 1),
                ),
                Text(
                  "Exploring the boldest looks of the season",
                  style: AppTexts.tsmr.copyWith(height: 1),
                ),
              ],
            ),
          ),
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.green.shade300),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: Image.asset(
                "assets/images/style_casual.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
