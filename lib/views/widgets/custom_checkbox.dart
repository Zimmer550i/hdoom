import 'package:flutter/material.dart';
import 'package:hdoom/utils/app_colors.dart';

// ──────────────────────────────────────────────
// CUSTOMIZABLE VARIABLES — Change these to style
// ──────────────────────────────────────────────

// Colors
const _activeColor = AppColors.green;
const _inactiveColor = AppColors.black;
const _checkmarkColor = Colors.white;
const _inactiveBackgroundColor = Colors.transparent;

// Sizing
const _defaultSize = 28.0;
const _checkmarkScale = 0.7;
const _borderWidth = 2.0;
const _defaultRadius = 6.0;

// Animation
const _animationDuration = Duration(milliseconds: 200);
const _animationCurve = Curves.easeInOut;

// ──────────────────────────────────────────────

class CustomCheckBox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final Color inactiveColor;
  final double size;
  final BorderRadius borderRadius;

  const CustomCheckBox({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor = _activeColor,
    this.inactiveColor = _inactiveColor,
    this.size = _defaultSize,
    this.borderRadius = const BorderRadius.all(Radius.circular(_defaultRadius)),
  });

  @override
  CustomCheckBoxState createState() => CustomCheckBoxState();
}

class CustomCheckBoxState extends State<CustomCheckBox> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onChanged(!widget.value),
      child: AnimatedContainer(
        duration: _animationDuration,
        curve: _animationCurve,
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: widget.value ? widget.activeColor : _inactiveBackgroundColor,
          borderRadius: widget.borderRadius,
          border: Border.all(
            color: widget.value ? widget.activeColor : widget.inactiveColor,
            width: _borderWidth,
          ),
        ),
        child: widget.value
            ? Icon(
                Icons.check,
                color: _checkmarkColor,
                size: widget.size * _checkmarkScale,
              )
            : null,
      ),
    );
  }
}
