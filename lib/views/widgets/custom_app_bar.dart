import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdoom/utils/app_colors.dart';
import 'package:hdoom/utils/app_icons.dart';
import 'package:hdoom/utils/app_texts.dart';
import 'package:hdoom/utils/custom_svg.dart';

// ──────────────────────────────────────────────
// CUSTOMIZABLE VARIABLES — Change these to style
// ──────────────────────────────────────────────

// Colors
final _backgroundColor = AppColors.bg;
final _titleColor = AppColors.green[700]!;

// Sizing
const _appBarHeight = 44.0;
const _leadingStartPadding = 20.0;
const _leadingSize = 40.0;
const _leadingRadius = 8.0;
const _titleLeftPadding = 18.0;

// Typography
final _titleStyle = AppTexts.txlm;

// Icons
const _backIcon = AppIcons.back;

// ──────────────────────────────────────────────

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool hasLeading;
  const CustomAppBar({super.key, required this.title, this.hasLeading = true});

  @override
  Size get preferredSize => Size(double.infinity, kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: _backgroundColor,
      surfaceTintColor: AppColors.green,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: SizedBox(
        height: _appBarHeight,
        child: Row(
          children: [
            SizedBox(width: _leadingStartPadding),
            if (hasLeading)    
              InkWell(
                onTap: () => hasLeading ? Get.back() : null,
                borderRadius: BorderRadius.circular(_leadingRadius),
                child: SizedBox(
                  height: _leadingSize,
                  width: _leadingSize,
                  child: hasLeading
                      ? Center(
                          child: CustomSvg(
                            asset: _backIcon,
                            color: _titleColor,
                          ),
                        )
                      : const SizedBox(),
                ),
              ),
            if (hasLeading) const SizedBox(width: _titleLeftPadding),
            Text(title, style: _titleStyle.copyWith(color: _titleColor)),
          ],
        ),
      ),
    );
  }
}
