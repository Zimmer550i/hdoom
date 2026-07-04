import 'package:flutter/material.dart';
import 'package:hdoom/utils/app_colors.dart';
import 'package:hdoom/utils/app_texts.dart';

// ──────────────────────────────────────────────
// CUSTOMIZABLE VARIABLES — Change these to style
// ──────────────────────────────────────────────

// Card
const _cardRadius = 12.0;

// Tags
final _tagBgColor = AppColors.black.shade50;
const _tagRadius = 6.0;
const _tagPaddingH = 8.0;
const _tagPaddingV = 4.0;

// Delete icon
final _deleteBgColor = AppColors.black.shade100;
const _deleteIconSize = 16.0;
const _deleteButtonSize = 28.0;

// Season dot
const _seasonDotSize = 6.0;
final _seasonDotColor = Colors.orange.shade400;

// Gradient overlay
const _gradientStops = [0.4, 1.0];

// Spacing
const _contentPadding = 10.0;

// ──────────────────────────────────────────────

class WardrobeItemCard extends StatelessWidget {
  final String image;
  final String category;
  final String season;
  final String title;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const WardrobeItemCard({
    super.key,
    required this.image,
    required this.category,
    required this.season,
    required this.title,
    this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_cardRadius),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            Image.asset(image, fit: BoxFit.cover),

            // Gradient overlay
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: _gradientStops,
                    colors: [
                      Colors.black.withValues(alpha: 0),
                      Colors.black.withValues(alpha: 0.5),
                    ],
                  ),
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(_contentPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row: category tag + delete button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTag(category),
                      if (onDelete != null) _buildDeleteButton(),
                    ],
                  ),

                  const Spacer(),

                  // Season tag with dot
                  _buildSeasonTag(season),
                  const SizedBox(height: 4),

                  // Title
                  Text(
                    title,
                    style: AppTexts.tsms.copyWith(color: Colors.white),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: _tagPaddingH,
        vertical: _tagPaddingV,
      ),
      decoration: BoxDecoration(
        color: _tagBgColor,
        borderRadius: BorderRadius.circular(_tagRadius),
      ),
      child: Text(
        label,
        style: AppTexts.txsr.copyWith(color: AppColors.black.shade400),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return GestureDetector(
      onTap: onDelete,
      child: Container(
        width: _deleteButtonSize,
        height: _deleteButtonSize,
        decoration: BoxDecoration(
          color: _deleteBgColor,
          borderRadius: BorderRadius.circular(_tagRadius),
        ),
        child: Icon(
          Icons.delete_outline_rounded,
          size: _deleteIconSize,
          color: AppColors.black.shade400,
        ),
      ),
    );
  }

  Widget _buildSeasonTag(String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 4,
      children: [
        Text(
          label,
          style: AppTexts.txsr.copyWith(color: Colors.white),
        ),
        Container(
          width: _seasonDotSize,
          height: _seasonDotSize,
          decoration: BoxDecoration(
            color: _seasonDotColor,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}
