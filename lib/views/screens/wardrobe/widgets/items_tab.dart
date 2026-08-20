import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdoom/controllers/wardrobe_controller.dart';
import 'package:hdoom/utils/app_colors.dart';
import 'package:hdoom/utils/app_texts.dart';
import 'package:hdoom/utils/custom_grid_handler.dart';
import 'package:hdoom/views/screens/wardrobe/add_new_item.dart';
import 'package:hdoom/views/screens/wardrobe/item_details.dart';
import 'package:hdoom/views/screens/wardrobe/widgets/wardrobe_item_card.dart';
import 'package:hdoom/views/widgets/custom_button.dart';

// ──────────────────────────────────────────────
// CUSTOMIZABLE VARIABLES — Change these to style
// ──────────────────────────────────────────────

// Category filter
final _selectedCategoryColor = AppColors.black.shade400;
final _unselectedCategoryColor = AppColors.black.shade300;
const _categoryUnderlineWidth = 1.0;

// Grid
const _gridAspectRatio = 0.72;
const _gridSpacing = 12.0;

// Layout
const _horizontalPadding = 20.0;

// ──────────────────────────────────────────────

class ItemsTab extends StatefulWidget {
  const ItemsTab({super.key});

  @override
  State<ItemsTab> createState() => _ItemsTabState();
}

class _ItemsTabState extends State<ItemsTab> {
  final wardrobe = Get.find<WardrobeController>();
  int _selectedCategory = 2;

  @override
  Widget build(BuildContext context) {
    final currentCategory = wardrobe.itemCategories.keys
        .elementAt(_selectedCategory)
        .name;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        // Category filter
        _buildCategoryFilter(),

        const SizedBox(height: 12),

        // Category title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
          child: Text(currentCategory, style: AppTexts.tlgm),
        ),

        // Grid
        Expanded(child: _buildGrid()),
      ],
    );
  }

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 32,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
        itemCount: wardrobe.itemCategories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 20),
        itemBuilder: (context, i) {
          final isSelected = _selectedCategory == i;
          final cat = wardrobe.itemCategories.entries.elementAt(i);
          final label = '${cat.key.name} (${cat.value.length})';

          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = i),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: AppTexts.tsmr.copyWith(
                    color: isSelected
                        ? _selectedCategoryColor
                        : _unselectedCategoryColor,
                  ),
                ),
                const SizedBox(height: 4),
                if (isSelected)
                  Container(
                    height: _categoryUnderlineWidth,
                    width: 40,
                    color: _selectedCategoryColor,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGrid() {
    return Stack(
      children: [
        CustomGridHandler(
          childAspectRatio: _gridAspectRatio,
          mainAxisSpacing: _gridSpacing,
          crossAxisSpacing: _gridSpacing,
          endWidget: Padding(
            padding: const EdgeInsets.all(_horizontalPadding),
            child: CustomButton(
              text: "add_new_item".tr,
              height: 50,
              onTap: () {
                Get.to(() => const AddNewItem());
              },
            ),
          ),
          children: List.generate(
            6,
            (index) => GestureDetector(
              onTap: () {
                Get.to(() => const ItemDetails());
              },
              child: WardrobeItemCard(
                image: 'assets/images/bag.jpg',
                category: 'travel'.tr,
                season: 'summer'.tr,
                title: 'Classic Beige Tote',
                onDelete: () {},
              ),
            ),
          ),
        ),
      ],
    );
  }
}
