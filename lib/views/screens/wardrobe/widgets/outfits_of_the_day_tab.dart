import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdoom/controllers/outfit_controller.dart';
import 'package:hdoom/utils/app_colors.dart';
import 'package:hdoom/utils/app_texts.dart';
import 'package:hdoom/utils/custom_snackbar.dart';
import 'package:hdoom/views/screens/home/widgets/custom_calender.dart';
import 'package:hdoom/views/widgets/custom_loading.dart';
import 'package:hdoom/views/widgets/custom_networked_image.dart';

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
  final outfit = Get.find<OutfitController>();
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    if (outfit.outfitsOfTheDay.isEmpty) {
      outfit.getOutfitsOfTheDay().then((message) {
        if (message != "success") {
          customSnackBar(message);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
      child: Obx(
        () => outfit.isOutfitOfTheDayLoading.value
            ? CustomLoading()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section title
                  Text('chose_date'.tr, style: AppTexts.tlgm),
                  const SizedBox(height: 12),

                  // Calendar
                  CustomCalendar(
                    selectedDate: outfit.outfitsOfTheDayDate.value,
                    markedDates: outfit.outfitsOfTheDay
                        .map((val) => val.savedDate)
                        .toList(),
                    onDateSelected: (date) {
                      setState(() => outfit.outfitsOfTheDayDate.value = date);
                    },
                  ),

                  const SizedBox(height: 20),

                  // Featured outfit image
                  _buildOutfitImage(),

                  const SizedBox(height: 16),

                  // Why we chose this for you
                  // _buildExpandableSection(),
                  const SizedBox(height: 24),

                  const SizedBox(height: 20),
                ],
              ),
      ),
    );
  }

  Widget _buildOutfitImage() {
    return Obx(() {
      final savedOutfit = outfit.outfitsOfTheDay.firstWhere(
        (val) =>
            val.savedDate.difference(outfit.outfitsOfTheDayDate.value).abs() <
            Duration(days: 1),
      );

      return CustomNetworkedImage(url: savedOutfit.outfitJob?.resultImage);
    });
  }

  // Widget _buildExpandableSection() {
  //   return Column(
  //     children: [
  //       GestureDetector(
  //         onTap: () => setState(() => _isExpanded = !_isExpanded),
  //         behavior: HitTestBehavior.opaque,
  //         child: Row(
  //           children: [
  //             Expanded(
  //               child: Text(
  //                 'why_we_chose_this_expanded'.tr,
  //                 style: AppTexts.tmdm.copyWith(color: _expandHeaderColor),
  //               ),
  //             ),
  //             Icon(
  //               _isExpanded
  //                   ? Icons.keyboard_arrow_up_rounded
  //                   : Icons.keyboard_arrow_down_rounded,
  //               color: _expandIconColor,
  //             ),
  //           ],
  //         ),
  //       ),
  //       if (_isExpanded) ...[
  //         const SizedBox(height: 12),
  //         Text(
  //           'why_we_chose_this_expanded_desc'.tr,
  //           style: AppTexts.tsmr.copyWith(color: AppColors.black.shade300),
  //         ),
  //       ],
  //     ],
  //   );
  // }
}
