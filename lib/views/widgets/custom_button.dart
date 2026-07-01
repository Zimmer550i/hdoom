import 'package:hdoom/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hdoom/utils/app_constants.dart';
import 'package:hdoom/utils/app_texts.dart';

// ──────────────────────────────────────────────
// CUSTOMIZABLE VARIABLES — Change these to style
// ──────────────────────────────────────────────

// Primary button colors
final _primaryColor = AppColors.green.shade500;
final _primaryDisabledColor = AppColors.green.shade300;
final _primaryTextColor = AppColors.white;
final _primaryIconColor = AppColors.white;
final _primaryLoaderColor = AppColors.white;

// Secondary button colors
final _secondaryColor = AppColors.green[50]!;
const _secondaryBorderColor = AppColors.green;
const _secondaryTextColor = AppColors.green;
const _secondaryIconColor = AppColors.green;
const _secondaryLoaderColor = AppColors.green;

// Sizing defaults
const _defaultHeight = 56.0;
const _defaultWidth = double.infinity;
const _defaultPadding = 40.0;
const _defaultRadius = 99.0;
const _defaultFontSize = 16.0;
const _defaultIconSize = 24.0;
const _iconTextSpacing = 8.0;

// Loading
const _loaderStrokeWidth = 4.0;
const _loaderPadding = 8.0;
const _animationDuration = Duration(milliseconds: 100);

// Typography
final _textStyle = AppTexts.tmdm;

// ──────────────────────────────────────────────

class CustomButton extends StatefulWidget {
  final String text;
  final Function()? onTap;
  final bool isSecondary;
  final bool isDisabled;
  final double? height;
  final double? width;
  final bool isLoading;
  final String? leading;
  final String? trailing;
  final double padding;
  final double radius;
  final double fontSize;
  final double iconSize;
  const CustomButton({
    super.key,
    required this.text,
    this.onTap,
    this.leading,
    this.trailing,
    this.padding = _defaultPadding,
    this.radius = _defaultRadius,
    this.isSecondary = false,
    this.isLoading = false,
    this.isDisabled = false,
    this.fontSize = _defaultFontSize,
    this.iconSize = _defaultIconSize,
    this.height = _defaultHeight,
    this.width = _defaultWidth,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(widget.radius),
      onTap: widget.isLoading ? null : widget.onTap,
      child: AnimatedContainer(
        duration: _animationDuration,
        height: widget.height,
        width: widget.width,
        padding: EdgeInsets.symmetric(horizontal: widget.padding),
        decoration: BoxDecoration(
          gradient: AppConstants.DEFAULT_GRADIENT_BACKGROUND,
          color: widget.isSecondary
              ? _secondaryColor
              : widget.isDisabled
              ? _primaryDisabledColor
              : _primaryColor,
          borderRadius: BorderRadius.circular(widget.radius),
          border: widget.isSecondary
              ? Border.all(color: _secondaryBorderColor)
              : null,
        ),
        child: widget.isLoading
            ? FittedBox(
                fit: BoxFit.scaleDown,
                child: Padding(
                  padding: const EdgeInsets.all(_loaderPadding),
                  child: CircularProgressIndicator(
                    color: widget.isSecondary
                        ? _secondaryLoaderColor
                        : _primaryLoaderColor,
                    strokeWidth: _loaderStrokeWidth,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                spacing: _iconTextSpacing,
                children: [
                  if (widget.leading != null)
                    SvgPicture.asset(
                      widget.leading!,
                      height: widget.iconSize,
                      width: widget.iconSize,
                      colorFilter: ColorFilter.mode(
                        widget.isSecondary
                            ? _secondaryIconColor
                            : _primaryIconColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  Text(
                    widget.text,
                    style: _textStyle.copyWith(
                      fontSize: widget.fontSize,
                      color: widget.isSecondary
                          ? _secondaryTextColor
                          : _primaryTextColor,
                    ),
                  ),
                  if (widget.trailing != null)
                    SvgPicture.asset(
                      widget.trailing!,
                      height: widget.iconSize,
                      width: widget.iconSize,
                      colorFilter: ColorFilter.mode(
                        widget.isSecondary
                            ? _secondaryIconColor
                            : _primaryTextColor,
                        BlendMode.srcIn,
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
