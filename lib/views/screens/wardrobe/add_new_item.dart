import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdoom/utils/app_colors.dart';
import 'package:hdoom/utils/app_texts.dart';
import 'package:hdoom/views/widgets/custom_app_bar.dart';
import 'package:hdoom/views/widgets/custom_button.dart';
import 'package:hdoom/views/widgets/custom_text_field.dart';


class AddNewItem extends StatefulWidget {
  const AddNewItem({super.key});

  @override
  State<AddNewItem> createState() => _AddNewItemState();
}

class _AddNewItemState extends State<AddNewItem> {
  String selectedCategory = 'Bag';
  String selectedSeason = 'Spring';
  String selectedOccasion = 'Event';

  List<String> get categories => ['kaftan'.tr, 'dresses'.tr, 'bag'.tr, 'hijab'.tr, 'bottoms'.tr];
  List<String> get seasons => ['summer'.tr, 'winter'.tr, 'spring'.tr, 'all'.tr];
  List<String> get occasions => ['daily'.tr, 'work'.tr, 'event'.tr, 'wedding'.tr, 'travel'.tr];

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
                    const SizedBox(height: 20),
                    _buildUploadPhoto(),
                    const SizedBox(height: 24),
                    _buildChipSection('category'.tr, categories, selectedCategory, (val) => setState(() => selectedCategory = val)),
                    const SizedBox(height: 24),
                    _buildChipSection('best_for_season'.tr, seasons, selectedSeason, (val) => setState(() => selectedSeason = val)),
                    const SizedBox(height: 24),
                    _buildChipSection('occasion'.tr, occasions, selectedOccasion, (val) => setState(() => selectedOccasion = val)),
                    const SizedBox(height: 24),
                    Text('source_of_purchases'.tr, style: AppTexts.txsb),
                    const SizedBox(height: 12),
                    CustomTextField(
                      hintText: 'write_here'.tr,
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: CustomButton(
                text: 'save_item'.tr,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadPhoto() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.black.shade200, style: BorderStyle.solid),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.green.shade500,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.camera_alt_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text('upload_photo'.tr, style: AppTexts.tlgm),
          const SizedBox(height: 4),
          Text('upload_from_gallery'.tr, style: AppTexts.tsmr.copyWith(color: AppColors.black.shade300)),
        ],
      ),
    );
  }

  Widget _buildChipSection(String title, List<String> items, String selectedValue, Function(String) onSelect) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTexts.txsb),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: items.map((item) {
            bool isSelected = item == selectedValue;
            return GestureDetector(
              onTap: () => onSelect(item),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.green.shade500 : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: isSelected ? AppColors.green.shade500 : AppColors.black.shade200),
                ),
                child: Text(
                  item,
                  style: AppTexts.tsmr.copyWith(
                    color: isSelected ? Colors.white : AppColors.black.shade400,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
