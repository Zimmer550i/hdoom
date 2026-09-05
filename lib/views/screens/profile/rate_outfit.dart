import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdoom/controllers/outfit_controller.dart';
import 'package:hdoom/models/saved_outfit_model.dart';
import 'package:hdoom/utils/app_colors.dart';
import 'package:hdoom/utils/app_texts.dart';
import 'package:hdoom/utils/custom_snackbar.dart';
import 'package:hdoom/views/widgets/custom_app_bar.dart';
import 'package:hdoom/views/widgets/custom_button.dart';
import 'package:hdoom/views/widgets/custom_networked_image.dart';

class RateOutfit extends StatefulWidget {
  final SavedOutfitModel outfit;
  const RateOutfit({super.key, required this.outfit});

  @override
  State<RateOutfit> createState() => _RateOutfitState();
}

class _RateOutfitState extends State<RateOutfit> {
  final outfitCtrl = Get.find<OutfitController>();

  final Map<String, double> ratingValues = {
    "color_harmony": 0.5,
    "trendy": 0.5,
    "overall_matching": 0.5,
    "accessories": 0.5,
  };

  void onSubmit() async {
    final message = await outfitCtrl.rateOutfit(
      widget.outfit.id,
      colorHarmony: (ratingValues["color_harmony"]! * 10).toInt(),
      trendy: (ratingValues["trendy"]! * 10).toInt(),
      overallMatching: (ratingValues["overall_matching"]! * 10).toInt(),
      accessories: (ratingValues["accessories"]! * 10).toInt(),
    );

    if (message == "success") {
      if (mounted) {
        Get.back();
      }

      customSnackBar("Submited outfit rating", isError: false);
    } else {
      customSnackBar(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "rate_outfit".tr),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              CustomNetworkedImage(
                url: widget.outfit.outfitJob?.resultImage,
                errorMessage: widget.outfit.outfitJob?.errorMessage,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  spacing: 8,
                  children: [
                    Row(
                      children: [
                        Text("rate_this_outfit".tr, style: AppTexts.tlgm),
                      ],
                    ),
                    const SizedBox(),
                    for (var i in ratingValues.entries)
                      ratingWidget(i.key, i.value),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              Row(
                children: [
                  const SizedBox(width: 20),
                  Expanded(
                    child: CustomButton(
                      onTap: () => Get.back(),
                      text: "cancel".tr,
                      isSecondary: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Obx(
                      () => CustomButton(
                        text: "rate_now".tr,
                        onTap: onSubmit,
                        isLoading: outfitCtrl.isRatingLoading.value,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Container ratingWidget(String name, double rating) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: .circular(20),
        border: Border.all(width: 0.5, color: AppColors.black.shade50),
      ),
      child: Row(
        children: [
          Expanded(child: Text(name.tr, style: AppTexts.tsmr)),
          Slider(
            value: rating.toDouble(),
            onChanged: (val) {
              setState(() {
                ratingValues[name] = val;
              });
            },
            activeColor: AppColors.gold,
            thumbColor: AppColors.gold,
            showValueIndicator: ShowValueIndicator.alwaysVisible,
            padding: .zero,
          ),
          const SizedBox(width: 12),
          Text((rating * 10).toInt().toString(), style: AppTexts.tsmr),
        ],
      ),
    );
  }
}
