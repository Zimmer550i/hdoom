import 'package:flutter/material.dart';
import 'package:hdoom/utils/app_colors.dart';
import 'package:hdoom/utils/app_texts.dart';
import 'package:hdoom/utils/custom_svg.dart';

// ──────────────────────────────────────────────
// CUSTOMIZABLE VARIABLES — Change these to style
// ──────────────────────────────────────────────

// Colors
const _selectedColor = AppColors.green;
final _unselectedColor = AppColors.black.shade300;

// Sizing
const _verticalPadding = 12.0;
const _iconSize = 24.0;
const _labelSpacing = 5.0;

// Typography
final _labelStyle = AppTexts.txsr;

// ──────────────────────────────────────────────

class CustomBottomNavbar extends StatelessWidget {
  final int index;
  final Function(int)? onChanged;
  const CustomBottomNavbar({super.key, required this.index, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(12)
      )),
      child: Padding(
        padding: const EdgeInsets.only(top: _verticalPadding),
        child: Row(
          children: [
            item("Home", "assets/icons/home.svg", 0),
            item("Wardrobe", "assets/icons/wardrobe.svg", 1),
            item("Avatar", "assets/icons/avatar.svg", 2),
            item("Profile", "assets/icons/profile.svg", 3),
          ],
        ),
      ),
    );
  }

  Widget item(String name, String icon, int pos) {
    bool isSelected = pos == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (onChanged != null) onChanged!(pos);
        },
        behavior: HitTestBehavior.translucent,
        child: SafeArea(
          child: Column(
            mainAxisSize: .min,
            children: [
              CustomSvg(
                asset: icon,
                size: _iconSize,
                color: isSelected ? _selectedColor : _unselectedColor,
              ),
              const SizedBox(height: _labelSpacing),
              Text(
                name,
                style: _labelStyle.copyWith(
                  color: isSelected ? _selectedColor : _unselectedColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
