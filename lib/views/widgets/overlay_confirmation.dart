import 'package:hdoom/utils/app_colors.dart';
import 'package:hdoom/views/widgets/custom_button.dart';
import 'package:flutter/material.dart';

// ──────────────────────────────────────────────
// CUSTOMIZABLE VARIABLES — Change these to style
// ──────────────────────────────────────────────

// Colors
final _dialogBackgroundColor = AppColors.green[50]!;
const _titleColor = Color(0xff4b4b4b);
const _highlightColor = AppColors.green;

// Sizing
const _dialogRadius = 12.0;
const _dialogHorizontalInset = 16.0;
const _contentHorizontalPadding = 16.0;
const _contentVerticalPadding = 28.0;
const _titleHighlightSpacing = 4.0;
const _buttonsTopSpacing = 20.0;
const _buttonSpacing = 12.0;

// Title typography
const _titleFontSize = 18.0;
const _titleFontWeight = 400.0;

// Highlight typography
const _highlightFontSize = 20.0;
const _highlightFontWeight = 600.0;

// ──────────────────────────────────────────────

class OverlayConfirmation extends StatelessWidget {
  final String title;
  final String? highlight;
  final String? buttonTextLeft;
  final String? buttonTextRight;
  final void Function()? buttonCallBackLeft;
  final void Function()? buttonCallBackRight;
  final bool leftButtonIsSecondary;

  const OverlayConfirmation({
    super.key,
    required this.title,
    this.highlight,
    this.buttonTextLeft,
    this.buttonTextRight,
    this.buttonCallBackLeft,
    this.buttonCallBackRight,
    this.leftButtonIsSecondary = true,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: _dialogHorizontalInset),
      contentPadding: EdgeInsets.symmetric(
        horizontal: _contentHorizontalPadding,
        vertical: _contentVerticalPadding,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_dialogRadius),
      ),
      backgroundColor: _dialogBackgroundColor,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _titleColor,
              fontVariations: [FontVariation("wght", _titleFontWeight)],
              fontSize: _titleFontSize,
            ),
          ),
          const SizedBox(height: _titleHighlightSpacing),
          if (highlight != null)
            Text(
              highlight!,
              style: TextStyle(
                color: _highlightColor,
                fontSize: _highlightFontSize,
                fontVariations: [FontVariation("wght", _highlightFontWeight)],
              ),
            ),
          const SizedBox(height: _buttonsTopSpacing),
          Row(
            spacing: _buttonSpacing,
            children: [
              if (buttonTextLeft != null)
                Expanded(
                  child: CustomButton(
                    text: buttonTextLeft!,
                    isSecondary: leftButtonIsSecondary,
                    onTap: buttonCallBackLeft,
                  ),
                ),
              if (buttonTextRight != null)
                Expanded(
                  child: CustomButton(
                    text: buttonTextRight!,
                    isSecondary: !leftButtonIsSecondary,
                    onTap: buttonCallBackRight,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
