import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khzanti/controllers/wardrobe_controller.dart';
import 'package:khzanti/models/item_model.dart';
import 'package:khzanti/utils/app_colors.dart';
import 'package:khzanti/utils/app_texts.dart';
import 'package:khzanti/utils/custom_grid_handler.dart';
import 'package:khzanti/utils/custom_snackbar.dart';
import 'package:khzanti/views/screens/wardrobe/item_details.dart';
import 'package:khzanti/views/screens/wardrobe/widgets/wardrobe_item_card.dart';

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
  int _selectedCategory = 0;

  @override
  Widget build(BuildContext context) {
    final currentCategory = wardrobe.wardrobeOptions.value?.categories
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
          child: Text(currentCategory ?? "Error!", style: AppTexts.tlgm),
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
        itemCount: wardrobe.wardrobeOptions.value?.categories.length ?? 0,
        separatorBuilder: (context, index) => const SizedBox(width: 20),
        itemBuilder: (context, i) {
          final isSelected = _selectedCategory == i;
          final cat = wardrobe.wardrobeOptions.value?.categories.elementAt(i);
          final length = wardrobe.items
              .where((val) => val.category.id == cat?.id)
              .length;
          final label = '${cat?.name} ($length)';
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
    final cat = wardrobe.wardrobeOptions.value?.categories.elementAt(
      _selectedCategory,
    );
    List<ItemModel> items = wardrobe.items
        .where((val) => val.category.name == cat?.name)
        .toList();

    return CustomGridHandler(
      childAspectRatio: _gridAspectRatio,
      mainAxisSpacing: _gridSpacing,
      crossAxisSpacing: _gridSpacing,
      onRefresh: () => wardrobe.getWardrobeItems().then((message) {
        if (message != "success") {
          customSnackBar(message);
        }
      }),
      children: List.generate(
        items.length,
        (index) => GestureDetector(
          onTap: () {
            Get.to(() => ItemDetails(item: items[index]));
          },
          child: WardrobeItemCard(item: items[index]),
        ),
      ),
    );
  }
}
