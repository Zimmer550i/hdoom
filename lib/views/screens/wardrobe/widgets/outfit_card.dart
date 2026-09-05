import 'package:flutter/material.dart';
import 'package:khzanti/models/outfit_model.dart';
import 'package:khzanti/utils/app_colors.dart';
import 'package:khzanti/utils/app_texts.dart';
import 'package:khzanti/views/widgets/custom_networked_image.dart';

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
  final SavedOutfitModel outfit;
  final VoidCallback? onTap;

  const OutfitCard({super.key, required this.outfit, this.onTap});

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
                child: AbsorbPointer(
                  child: CustomNetworkedImage(
                    url: outfit.outfitJob?.resultImage,
                    fit: BoxFit.cover,
                  ),
                ),
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
                  outfit.outfitJob?.reasoningTitle ?? "",
                  style: AppTexts.tsmm.copyWith(color: _titleColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  outfit.outfitJob?.reasoningSubtitle ?? "",
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
