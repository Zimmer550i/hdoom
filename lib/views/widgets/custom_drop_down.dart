import 'package:hdoom/utils/app_colors.dart';
import 'package:hdoom/utils/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hdoom/utils/app_texts.dart';

// ──────────────────────────────────────────────
// CUSTOMIZABLE VARIABLES — Change these to style
// ──────────────────────────────────────────────

// Colors
final _backgroundColor = AppColors.green[400]!;
final _titleColor = AppColors.green[600]!;
final _hintColor = AppColors.green.shade200;
final _selectedTextColor = AppColors.green.shade50;
final _optionTextColor = AppColors.green[50]!;
final _dividerColor = AppColors.green[400]!;

// Title typography
const _titleFontSize = 16.0;
const _titleFontWeight = 600.0;

// Option typography
const _optionFontSize = 14.0;

// Sizing
const _defaultRadius = 24.0;
const _horizontalPadding = 8.0;
const _titleSpacing = 8.0;
const _dividerWidth = 0.5;

// Animation
const _animationDuration = Duration(milliseconds: 100);

// Typography
final _selectedTextStyle = AppTexts.tsmr;

// ──────────────────────────────────────────────

class CustomDropDown extends StatefulWidget {
  final String? title;
  final int? initialPick;
  final String? hintText;
  final List<String> options;
  final double? height;
  final double? width;
  final double radius;
  final void Function(String)? onChanged;
  const CustomDropDown({
    super.key,
    this.title,
    this.initialPick,
    this.hintText,
    required this.options,
    this.onChanged,
    this.radius = _defaultRadius,
    this.height,
    this.width,
  });

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  String? currentVal;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialPick != null) {
      currentVal = widget.options[widget.initialPick!];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: _titleSpacing,
      children: [
        if (widget.title != null)
          Text(
            widget.title!,
            style: TextStyle(
              fontVariations: [FontVariation("wght", _titleFontWeight)],
              fontSize: _titleFontSize,
              color: _titleColor,
            ),
          ),

        GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
            decoration: BoxDecoration(
              color: _backgroundColor,
              borderRadius: BorderRadius.circular(widget.radius),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: widget.height,
                  child: Row(
                    children: [
                      currentVal == null
                          ? Text(
                              widget.hintText ?? "Select One",
                              style: _selectedTextStyle.copyWith(
                                color: _hintColor,
                              ),
                            )
                          : Text(
                              currentVal!,
                              style: _selectedTextStyle.copyWith(
                                color: _selectedTextColor,
                              ),
                            ),
                      const Spacer(),
                      AnimatedRotation(
                        duration: _animationDuration,
                        turns: isExpanded ? 0.5 : 1,
                        child: SvgPicture.asset(AppIcons.arrowDown),
                      ),
                    ],
                  ),
                ),
                AnimatedSize(
                  duration: _animationDuration,
                  child: isExpanded
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...widget.options.map((e) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isExpanded = false;
                                    currentVal = e;
                                    if (widget.onChanged != null) {
                                      widget.onChanged!(e);
                                    }
                                  });
                                },
                                child: Container(
                                  height: widget.height,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                        color: _dividerColor,
                                        width: _dividerWidth,
                                      ),
                                    ),
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      e,
                                      style: TextStyle(
                                        color: _optionTextColor,
                                        fontSize: _optionFontSize,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        )
                      : SizedBox(height: 0, width: double.infinity),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
