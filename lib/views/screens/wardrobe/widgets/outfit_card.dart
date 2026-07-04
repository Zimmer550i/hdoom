import 'package:flutter/material.dart';
import 'package:hdoom/utils/app_colors.dart';
import 'package:hdoom/utils/app_texts.dart';

// ──────────────────────────────────────────────
// CUSTOMIZABLE VARIABLES — Change these to style
// ──────────────────────────────────────────────

// Card
const _cardRadius = 12.0;
final _cardBg = AppColors.black.shade50;

// Text
final _titleColor = AppColors.black.shade400;
final _subtitleColor = AppColors.black.shade300;
const _textPaddingH = 4.0;
const _textPaddingTop = 8.0;
const _textPaddingBottom = 4.0;

// ──────────────────────────────────────────────

class OutfitCard extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const OutfitCard({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(_cardRadius),
              child: Container(
                width: double.infinity,
                color: _cardBg,
                child: Image.asset(image, fit: BoxFit.cover),
              ),
            ),
          ),

          // Title & subtitle
          Padding(
            padding: const EdgeInsets.fromLTRB(
              _textPaddingH,
              _textPaddingTop,
              _textPaddingH,
              _textPaddingBottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTexts.tsmm.copyWith(color: _titleColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subtitle,
                  style: AppTexts.txsr.copyWith(color: _subtitleColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
