import 'package:hdoom/utils/app_colors.dart';
import 'package:hdoom/utils/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hdoom/utils/app_texts.dart';

// ──────────────────────────────────────────────
// CUSTOMIZABLE VARIABLES — Change these to style
// ──────────────────────────────────────────────

// Colors
const _backgroundColor = AppColors.white;
final _focusBorderColor = AppColors.green[300]!;
final _defaultBorderColor = AppColors.green[100]!;
final _cursorColor = AppColors.green.shade300;
const _errorColor = AppColors.red;

// Border
const _defaultBorderWidth = 0.5;
const _focusBorderWidth = 0.5;
const _defaultRadius = 24.0;

// Sizing
const _defaultHeight = 56.0;
const _horizontalPadding = 20.0;
const _multilineVerticalPadding = 20.0;
const _iconSize = 24.0;
const _itemSpacing = 8.0;

// Icon colors
const _iconFocusedColor = AppColors.green;
final _iconUnfocusedColor = AppColors.black.shade400;
final _toggleIconUnfocusedColor = AppColors.black.shade100;

// Title
const _titleBottomPadding = 8.0;
final _titleStyle = AppTexts.txsb;

// Input text
final _inputStyle = AppTexts.tsmr;
final _hintColor = AppColors.black[300]!;

// Error text
const _errorHorizontalPadding = 24.0;
const _errorFontSize = 12.0;
const _errorFontWeight = 400.0;

// ──────────────────────────────────────────────

class CustomTextField extends StatefulWidget {
  final String? title;
  final String? hintText;
  final String? errorText;
  final String? leading;
  final String? trailing;
  final TextInputType? textInputType;
  final bool isDisabled;
  final double radius;
  final double? height;
  final double? width;
  final TextEditingController? controller;
  final bool isPassword;
  final int lines;
  final void Function()? onTap;
  const CustomTextField({
    super.key,
    this.title,
    this.hintText,
    this.leading,
    this.trailing,
    this.isPassword = false,
    this.isDisabled = false,
    this.radius = _defaultRadius,
    this.lines = 1,
    this.textInputType,
    this.controller,
    this.onTap,
    this.errorText,
    this.height = _defaultHeight,
    this.width,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isObscured = false;
  bool isFocused = false;
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    isObscured = widget.isPassword;
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          isFocused = true;
        });
      } else {
        setState(() {
          isFocused = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null)
          Padding(
            padding: const EdgeInsets.only(bottom: _titleBottomPadding),
            child: Text(widget.title!, style: _titleStyle),
          ),
        GestureDetector(
          onTap: () {
            if (widget.onTap != null) {
              widget.onTap!();
            } else {
              if (!widget.isDisabled) {
                focusNode.requestFocus();
              }
            }
          },
          child: Container(
            height: widget.lines == 1 ? widget.height : null,
            width: widget.width,
            padding: EdgeInsets.symmetric(
              horizontal: _horizontalPadding,
              vertical: widget.lines == 1 ? 0 : _multilineVerticalPadding,
            ),
            decoration: BoxDecoration(
              color: _backgroundColor,
              borderRadius: BorderRadius.circular(widget.radius),
              border: isFocused
                  ? Border.all(
                      color: _focusBorderColor,
                      width: _focusBorderWidth,
                    )
                  : Border.all(
                      color: _defaultBorderColor,
                      width: _defaultBorderWidth,
                    ),
            ),
            child: Row(
              spacing: _itemSpacing,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.leading != null)
                  SvgPicture.asset(
                    widget.leading!,
                    height: _iconSize,
                    width: _iconSize,
                    // colorFilter: ColorFilter.mode(
                    //   isFocused ? _iconFocusedColor : _iconUnfocusedColor,
                    //   BlendMode.srcIn,
                    // ),
                  ),
                Expanded(
                  child: TextField(
                    focusNode: focusNode,
                    controller: widget.controller,
                    maxLines: widget.lines,
                    cursorColor: _cursorColor,
                    keyboardType: widget.textInputType,
                    obscureText: isObscured,
                    enabled: !widget.isDisabled && widget.onTap == null,
                    onTapOutside: (event) {
                      setState(() {
                        isFocused = false;
                        focusNode.unfocus();
                      });
                    },
                    style: _inputStyle,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      hintText: widget.hintText,
                      hintStyle: _inputStyle.copyWith(color: _hintColor),
                    ),
                  ),
                ),
                if (widget.trailing != null)
                  SvgPicture.asset(
                    widget.trailing!,
                    height: _iconSize,
                    width: _iconSize,
                    colorFilter: ColorFilter.mode(
                      isFocused ? _iconFocusedColor : _iconUnfocusedColor,
                      BlendMode.srcIn,
                    ),
                  ),
                if (widget.isPassword)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isObscured = !isObscured;
                      });
                    },
                    behavior: HitTestBehavior.translucent,
                    child: SvgPicture.asset(
                      isObscured ? AppIcons.eyeOff : AppIcons.eye,
                      width: _iconSize,
                      colorFilter: ColorFilter.mode(
                        isFocused
                            ? _iconFocusedColor
                            : _toggleIconUnfocusedColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (widget.errorText != null)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: _errorHorizontalPadding,
            ),
            child: Text(
              widget.errorText!,
              style: TextStyle(
                fontVariations: [FontVariation("wght", _errorFontWeight)],
                fontSize: _errorFontSize,
                color: _errorColor,
              ),
            ),
          ),
      ],
    );
  }
}
