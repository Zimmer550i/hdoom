import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdoom/utils/app_colors.dart';
import 'package:hdoom/utils/app_texts.dart';
import 'package:hdoom/views/screens/home/widgets/custom_calender.dart';

// ──────────────────────────────────────────────
// CUSTOMIZABLE VARIABLES — Change these to style
// ──────────────────────────────────────────────

// Layout
const _horizontalPadding = 20.0;

// Outfit image
const _outfitImageRadius = 16.0;
final _outfitImageBg = AppColors.black.shade50;

// AR icon
const _arIconSize = 40.0;
final _arIconBg = AppColors.black.shade100;
final _arIconColor = AppColors.black.shade400;

// Expandable section
final _expandHeaderColor = AppColors.black.shade400;
final _expandIconColor = AppColors.black.shade300;

// ──────────────────────────────────────────────

class OutfitsOfTheDayTab extends StatefulWidget {
  const OutfitsOfTheDayTab({super.key});

  @override
  State<OutfitsOfTheDayTab> createState() => _OutfitsOfTheDayTabState();
}

class _OutfitsOfTheDayTabState extends State<OutfitsOfTheDayTab> {
  bool _isExpanded = false;
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Text('chose_date'.tr, style: AppTexts.tlgm),
          const SizedBox(height: 12),

          // Calendar
          CustomCalendar(
            selectedDate: _selectedDate,
            markedDates: {
              DateTime(2024, 4, 7),
              DateTime(2024, 4, 8),
            },
            onDateSelected: (date) {
              setState(() => _selectedDate = date);
            },
          ),

          const SizedBox(height: 20),

          // Featured outfit image
          _buildOutfitImage(),

          const SizedBox(height: 16),

          // Why we chose this for you
          _buildExpandableSection(),

          const SizedBox(height: 24),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildOutfitImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(_outfitImageRadius),
      child: Container(
        width: double.infinity,
        color: _outfitImageBg,
        child: AspectRatio(
          aspectRatio: 4 / 5,
          child: Stack(
            children: [
              // Image
              Positioned.fill(
                child: Image.asset(
                  'assets/images/avatar.png',
                  fit: BoxFit.cover,
                ),
              ),

              // AR / 3D icon (bottom-right)
              Positioned(
                bottom: 12,
                right: 12,
                child: Container(
                  width: _arIconSize,
                  height: _arIconSize,
                  decoration: BoxDecoration(
                    color: _arIconBg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.view_in_ar_rounded,
                    color: _arIconColor,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandableSection() {
    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          behavior: HitTestBehavior.opaque,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'why_we_chose_this_expanded'.tr,
                  style: AppTexts.tmdm.copyWith(color: _expandHeaderColor),
                ),
              ),
              Icon(
                _isExpanded
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                color: _expandIconColor,
              ),
            ],
          ),
        ),
        if (_isExpanded) ...[
          const SizedBox(height: 12),
          Text(
            'why_we_chose_this_expanded_desc'.tr,
            style: AppTexts.tsmr.copyWith(color: AppColors.black.shade300),
          ),
        ],
      ],
    );
  }
}
