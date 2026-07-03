import 'package:hdoom/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:hdoom/utils/app_icons.dart';
import 'package:hdoom/utils/app_texts.dart';
import 'package:hdoom/utils/custom_svg.dart';

// ──────────────────────────────────────────────
// CUSTOMIZABLE VARIABLES — Matching CustomTextField style
// ──────────────────────────────────────────────

// Colors (same as CustomTextField)
const _backgroundColor = Colors.white;
final _focusBorderColor = AppColors.green[300]!;
final _defaultBorderColor = AppColors.green[100]!;
const _errorColor = AppColors.red;

// Border
const _defaultBorderWidth = 0.5;
const _focusBorderWidth = 0.5;
const _defaultRadius = 24.0;

// Sizing
const _defaultHeight = 56.0;
const _horizontalPadding = 20.0;
const _iconSize = 24.0;

// Title
const _titleBottomPadding = 8.0;
final _titleStyle = AppTexts.txsb;

// Text
final _inputStyle = AppTexts.tsmr;
final _hintColor = AppColors.black[300]!;

// Error text
const _errorHorizontalPadding = 24.0;
const _errorFontSize = 12.0;
const _errorFontWeight = 400.0;

// Overlay
const _overlayMaxHeight = 240.0;
const _overlayBorderWidth = 0.5;
const _overlayItemHeight = 48.0;
const _overlayVerticalPadding = 8.0;

// ──────────────────────────────────────────────

class CustomDropDown extends StatefulWidget {
  final String? title;
  final int? initialPick;
  final String? hintText;
  final String? errorText;
  final List<String> options;
  final double? height;
  final double? width;
  final double radius;
  final bool isDisabled;

  /// Called when the user selects an option.
  /// Provides the selected index and the string value.
  final void Function(int index, String value)? onChanged;

  const CustomDropDown({
    super.key,
    this.title,
    this.initialPick,
    this.hintText,
    this.errorText,
    required this.options,
    this.onChanged,
    this.radius = _defaultRadius,
    this.height = _defaultHeight,
    this.width,
    this.isDisabled = false,
  });

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  String? _currentVal;
  int? _currentIndex;
  bool _isOpen = false;

  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  final GlobalKey _fieldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (widget.initialPick != null &&
        widget.initialPick! >= 0 &&
        widget.initialPick! < widget.options.length) {
      _currentIndex = widget.initialPick;
      _currentVal = widget.options[widget.initialPick!];
    }
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _toggleOverlay() {
    if (widget.isDisabled) return;
    if (_isOpen) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
    _overlayEntry = _buildOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isOpen = true);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (_isOpen) {
      setState(() => _isOpen = false);
    }
  }

  void _selectOption(int index, String value) {
    setState(() {
      _currentIndex = index;
      _currentVal = value;
    });
    _removeOverlay();
    widget.onChanged?.call(index, value);
  }

  OverlayEntry _buildOverlayEntry() {
    final renderBox = _fieldKey.currentContext!.findRenderObject() as RenderBox;
    final fieldWidth = renderBox.size.width;

    return OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            // Tap-away barrier
            Positioned.fill(
              child: GestureDetector(
                onTap: _removeOverlay,
                behavior: HitTestBehavior.translucent,
                child: const SizedBox.expand(),
              ),
            ),
            // Dropdown list
            Positioned(
              width: fieldWidth,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0, (widget.height ?? _defaultHeight) + 4),
                child: Material(
                  elevation: 4,
                  shadowColor: AppColors.black.shade100.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16),
                  color: _backgroundColor,
                  child: Container(
                    constraints: const BoxConstraints(
                      maxHeight: _overlayMaxHeight,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _focusBorderColor,
                        width: _overlayBorderWidth,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          vertical: _overlayVerticalPadding,
                        ),
                        shrinkWrap: true,
                        itemCount: widget.options.length,
                        itemBuilder: (context, index) {
                          final option = widget.options[index];
                          final isSelected = index == _currentIndex;
                          return InkWell(
                            onTap: () => _selectOption(index, option),
                            child: Container(
                              height: _overlayItemHeight,
                              padding: const EdgeInsets.symmetric(
                                horizontal: _horizontalPadding,
                              ),
                              color: isSelected
                                  ? AppColors.green[25]
                                  : Colors.transparent,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                option,
                                style: _inputStyle.copyWith(
                                  color: isSelected
                                      ? AppColors.green
                                      : AppColors.black.shade400,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
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
        CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            key: _fieldKey,
            onTap: _toggleOverlay,
            child: Container(
              height: widget.height,
              width: widget.width,
              padding: const EdgeInsets.symmetric(
                horizontal: _horizontalPadding,
              ),
              decoration: BoxDecoration(
                color: _backgroundColor,
                borderRadius: BorderRadius.circular(widget.radius),
                border: _isOpen
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
                children: [
                  Expanded(
                    child: Text(
                      _currentVal ?? widget.hintText ?? "Select One",
                      style: _inputStyle.copyWith(
                        color: _currentVal != null
                            ? AppColors.black.shade400
                            : _hintColor,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    duration: Duration(milliseconds: 300),
                    turns: _isOpen ? 0.5 : 1,
                    child: CustomSvg(
                      asset: AppIcons.arrowDown,
                      size: _iconSize,
                      color: _hintColor,
                    ),
                  ),
                ],
              ),
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
