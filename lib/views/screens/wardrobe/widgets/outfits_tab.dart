import 'package:flutter/material.dart';
import 'package:hdoom/utils/app_texts.dart';
import 'package:hdoom/utils/custom_grid_handler.dart';
import 'package:hdoom/views/screens/wardrobe/widgets/outfit_card.dart';

// ──────────────────────────────────────────────
// CUSTOMIZABLE VARIABLES — Change these to style
// ──────────────────────────────────────────────

// Grid
const _gridAspectRatio = 0.58;
const _gridSpacing = 12.0;

// Layout
const _horizontalPadding = 20.0;

// ──────────────────────────────────────────────

class OutfitsTab extends StatelessWidget {
  const OutfitsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
          child: Text('Recommendation For You', style: AppTexts.tlgm),
        ),

        const SizedBox(height: 8),

        // Grid
        Expanded(
          child: CustomGridHandler(
            horizontalPadding: _horizontalPadding,
            childAspectRatio: _gridAspectRatio,
            mainAxisSpacing: _gridSpacing,
            crossAxisSpacing: _gridSpacing,
            children: List.generate(
              6,
              (index) => OutfitCard(
                image: 'assets/images/avatar.png',
                title: 'Soft beige Evening style',
                subtitle: 'Formal',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
