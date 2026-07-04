import 'package:flutter/material.dart';
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

  final List<String> categories = ['Kaftan', 'Dresses', 'Bag', 'Hijab', 'Bottoms'];
  final List<String> seasons = ['Summer', 'Winter', 'Spring', 'All'];
  final List<String> occasions = ['Daily', 'Work', 'Event', 'Wedding', 'Travel'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: CustomAppBar(title: 'Add New Item'),
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
                    _buildChipSection('Category', categories, selectedCategory, (val) => setState(() => selectedCategory = val)),
                    const SizedBox(height: 24),
                    _buildChipSection('Best for Season', seasons, selectedSeason, (val) => setState(() => selectedSeason = val)),
                    const SizedBox(height: 24),
                    _buildChipSection('Occasion', occasions, selectedOccasion, (val) => setState(() => selectedOccasion = val)),
                    const SizedBox(height: 24),
                    Text('The Source Of Purchases', style: AppTexts.txsb),
                    const SizedBox(height: 12),
                    const CustomTextField(
                      hintText: 'Write here',
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: CustomButton(
                text: 'Save Item',
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
    // A dashed border container using a CustomPaint or simple BoxDecoration if dotted_border package is not available. 
    // We will use a Container with a border since we can't guarantee dotted_border is in pubspec, but it's often used.
    // Let's stick to standard Flutter widgets.
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.black.shade200, style: BorderStyle.solid), // Fallback to solid if dashed not possible natively easily
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
          Text('Upload Photo', style: AppTexts.tlgm),
          const SizedBox(height: 4),
          Text('Upload from your gallery', style: AppTexts.tsmr.copyWith(color: AppColors.black.shade300)),
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
