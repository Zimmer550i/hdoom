import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khzanti/controllers/wardrobe_controller.dart';
import 'package:khzanti/utils/app_colors.dart';
import 'package:khzanti/utils/app_texts.dart';
import 'package:khzanti/utils/custom_snackbar.dart';
import 'package:khzanti/views/screens/wardrobe/item_details.dart';
import 'package:khzanti/views/screens/wardrobe/widgets/image_uploader.dart';
import 'package:khzanti/views/widgets/custom_app_bar.dart';
import 'package:khzanti/views/widgets/custom_button.dart';
import 'package:khzanti/views/widgets/custom_text_field.dart';

class AddNewItem extends StatefulWidget {
  const AddNewItem({super.key});

  @override
  State<AddNewItem> createState() => _AddNewItemState();
}

class _AddNewItemState extends State<AddNewItem> {
  final wardrobe = Get.find<WardrobeController>();

  File? _image;
  int selectedCategory = -1;
  int selectedSeason = -1;
  int selectedOccasion = -1;
  final source = TextEditingController();

  void onSubmit() async {
    if (_image == null ||
        selectedCategory == -1 ||
        selectedSeason == -1 ||
        selectedOccasion == -1) {
      customSnackBar("Fill in all the informations");
      return;
    }

    final image = _image!;
    final category =
        wardrobe.wardrobeOptions.value!.categories[selectedCategory].id;
    final season =
        wardrobe.wardrobeOptions.value!.seasons[selectedSeason].value;
    final occasion =
        wardrobe.wardrobeOptions.value!.occasions[selectedOccasion].value;

    final message = await wardrobe.createWardrobeItem(
      image,
      category,
      season,
      occasion,
      source.text,
    );

    if (message == "success") {
      Get.off(() => ItemDetails(item: wardrobe.currentItem.value!));
      customSnackBar("Item created successfully", isError: false);
    } else {
      customSnackBar(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: CustomAppBar(title: 'add_new_item'.tr),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "For the best results, please follow these simple guidelines:",
                      style: AppTexts.tmdr,
                    ),
                    const SizedBox(height: 12),
                    Text("1. One item per photo", style: AppTexts.tsms),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(
                        "Upload a picture containing only one specific wardrobe item.",
                        style: AppTexts.tsmr,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text("2. Keep the background simple", style: AppTexts.tsms),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(
                        "Use a clean, plain, and uncluttered background so the item can be detected accurately.",
                        style: AppTexts.tsmr,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ImageUploader(
                      image: _image,
                      onChange: (val) {
                        setState(() {
                          _image = val;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    _buildChipSection(
                      'category'.tr,
                      wardrobe.wardrobeOptions.value!.categories
                          .map((val) => val.name)
                          .toList(),
                      selectedCategory,
                      (val) => setState(() => selectedCategory = val),
                    ),
                    const SizedBox(height: 24),
                    _buildChipSection(
                      'best_for_season'.tr,
                      wardrobe.wardrobeOptions.value!.seasons
                          .map((val) => val.label)
                          .toList(),
                      selectedSeason,
                      (val) => setState(() => selectedSeason = val),
                    ),
                    const SizedBox(height: 24),
                    _buildChipSection(
                      'occasion'.tr,
                      wardrobe.wardrobeOptions.value!.occasions
                          .map((val) => val.label)
                          .toList(),
                      selectedOccasion,
                      (val) => setState(() => selectedOccasion = val),
                    ),
                    const SizedBox(height: 24),
                    Text('source_of_purchases'.tr, style: AppTexts.txsb),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: source,
                      hintText: 'write_here'.tr,
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SafeArea(
                child: Obx(
                  () => CustomButton(
                    text: 'save_item'.tr,
                    isLoading: wardrobe.isWardrobeItemCreating.value,
                    onTap: onSubmit,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChipSection(
    String title,
    List<String> items,
    int selected,
    Function(int) onSelect,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTexts.txsb),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (int i = 0; i < items.length; i++)
              GestureDetector(
                onTap: () => onSelect(i),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: i == selected
                        ? AppColors.gold.shade500
                        : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: i == selected
                          ? AppColors.gold.shade500
                          : AppColors.black.shade200,
                    ),
                  ),
                  child: Text(
                    items[i],
                    style: AppTexts.tsmr.copyWith(
                      color: i == selected
                          ? Colors.white
                          : AppColors.black.shade400,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
