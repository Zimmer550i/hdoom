import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hdoom/utils/app_colors.dart';
import 'package:hdoom/utils/app_texts.dart';
import 'package:hdoom/utils/custom_svg.dart';
import 'package:hdoom/views/screens/home/widgets/home_text_button.dart';

/// Hero card displaying the AI-curated "Today's Look" outfit
/// with a blurred glass footer and action buttons.
class TodaysLookCard extends StatelessWidget {
  const TodaysLookCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildImageSection(),
        _buildDescriptionSection(),
      ],
    );
  }

  Widget _buildImageSection() {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 4 / 5,
            child: Image.asset(
              "assets/images/avatar.png",
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            left: 20,
            top: 26,
            child: Column(
              children: [
                Text(
                  "Today's Look",
                  style: AppTexts.tsmm.copyWith(color: Colors.white),
                ),
                Container(height: 1, width: 85, color: Colors.white),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  width: double.infinity,
                  height: 62,
                  color: Colors.black.withValues(alpha: 0.3),
                  child: Center(
                    child: Row(
                      spacing: 12,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "From other brands - ",
                          style: AppTexts.tsmm.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        CustomSvg(
                          asset: "assets/icons/arrow_down_circled.svg",
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Elegant Everyday Abaya Look", style: AppTexts.txlm),
          const SizedBox(height: 12),
          Text(
            "A comfortable and graceful outfit curated for your day, matching your style p preference  and todays weather.",
            style: AppTexts.tsmr.copyWith(
              color: AppColors.black.shade400,
            ),
          ),
          const SizedBox(height: 28),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.green.shade50,
            ),
            child: Row(
              children: [
                HomeTextButton(title: "Why this look?", onTap: () {}),
                HomeTextButton(title: "Save Look", onTap: () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
