import 'package:flutter/material.dart';
import 'package:hdoom/utils/app_colors.dart';
import 'package:hdoom/utils/app_texts.dart';
import 'package:hdoom/views/screens/wardrobe/widgets/items_tab.dart';
import 'package:hdoom/views/screens/wardrobe/widgets/outfits_of_the_day_tab.dart';
import 'package:hdoom/views/screens/wardrobe/widgets/outfits_tab.dart';

// ──────────────────────────────────────────────
// CUSTOMIZABLE VARIABLES — Change these to style
// ──────────────────────────────────────────────

// Colors
final _scaffoldBg = AppColors.bg;
final _headerTitleColor = AppColors.green.shade500;
final _headerSubtitleColor = AppColors.black.shade300;
final _addIconColor = AppColors.black.shade300;
final _addIconBorderColor = AppColors.black.shade200;

// Top tabs
final _selectedTabBg = AppColors.green.shade500;
const _selectedTabTextColor = Colors.white;
final _unselectedTabBg = AppColors.black.shade50;
final _unselectedTabTextColor = AppColors.black.shade400;
const _tabRadius = 99.0;
const _tabPaddingH = 16.0;
const _tabPaddingV = 8.0;
const _tabSpacing = 8.0;

// Layout
const _horizontalPadding = 20.0;
const _addIconSize = 36.0;

// ──────────────────────────────────────────────

// Dummy data
const _topTabs = ['Items', 'Outfits', 'Outfits of the day'];

class Wardrobe extends StatefulWidget {
  const Wardrobe({super.key});

  @override
  State<Wardrobe> createState() => _WardrobeState();
}

class _WardrobeState extends State<Wardrobe> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _scaffoldBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: _horizontalPadding,
              ).copyWith(top: 16),
              child: _buildHeader(),
            ),

            const SizedBox(height: 16),

            // Top tabs
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: _horizontalPadding,
              ),
              child: _buildTopTabs(),
            ),

            const SizedBox(height: 16),

            // Tab content
            Expanded(child: _buildTabContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Wardrobe',
                style: AppTexts.dxss.copyWith(color: _headerTitleColor),
              ),
              Text(
                'Total Item: 125',
                style: AppTexts.tsmr.copyWith(color: _headerSubtitleColor),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Container(
            width: _addIconSize,
            height: _addIconSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: _addIconBorderColor),
            ),
            child: Icon(Icons.add, color: _addIconColor, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildTopTabs() {
    return Row(
      spacing: _tabSpacing,
      children: List.generate(_topTabs.length, (i) {
        final isSelected = _selectedTab == i;
        return GestureDetector(
          onTap: () => setState(() => _selectedTab = i),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: _tabPaddingH,
              vertical: _tabPaddingV,
            ),
            decoration: BoxDecoration(
              color: isSelected ? _selectedTabBg : _unselectedTabBg,
              borderRadius: BorderRadius.circular(_tabRadius),
            ),
            child: Text(
              _topTabs[i],
              style: AppTexts.tsmm.copyWith(
                color: isSelected
                    ? _selectedTabTextColor
                    : _unselectedTabTextColor,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 0:
        return const ItemsTab();
      case 1:
        return const OutfitsTab();
      case 2:
        return const OutfitsOfTheDayTab();
      default:
        return const ItemsTab();
    }
  }
}
