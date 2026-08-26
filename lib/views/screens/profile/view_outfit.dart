import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdoom/models/saved_outfit_model.dart';
import 'package:hdoom/utils/app_colors.dart';
import 'package:hdoom/utils/app_texts.dart';
import 'package:hdoom/views/screens/profile/rate_outfit.dart';
import 'package:hdoom/views/widgets/custom_app_bar.dart';
import 'package:hdoom/views/widgets/custom_button.dart';
import 'package:hdoom/views/widgets/custom_networked_image.dart';

class ViewOutfit extends StatefulWidget {
  final SavedOutfitModel outfit;
  final bool canRate;
  const ViewOutfit({super.key, required this.outfit, this.canRate = true});

  @override
  State<ViewOutfit> createState() => _ViewOutfitState();
}

class _ViewOutfitState extends State<ViewOutfit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "soft_beige_evening".tr),
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
                        Text("overall_rating".tr, style: AppTexts.tlgm),
                        Spacer(),
                        if (widget.outfit.averageRating != null)
                          Text(
                            "${widget.outfit.averageRating}/10",
                            style: AppTexts.tlgm,
                          ),
                        if (widget.outfit.averageRating == null)
                          Text("Not rated yet", style: AppTexts.tsmr),
                      ],
                    ),
                    const SizedBox(),
                    ratingWidget(
                      "color_harmony",
                      widget.outfit.ratingBreakdown?['color_harmony'] ?? 0,
                    ),
                    ratingWidget(
                      "trendy",
                      widget.outfit.ratingBreakdown?['trendy'] ?? 0,
                    ),
                    ratingWidget(
                      "overall_matching",
                      widget.outfit.ratingBreakdown?['overall_matching'] ?? 0,
                    ),
                    ratingWidget(
                      "accessories",
                      widget.outfit.ratingBreakdown?['accessories'] ?? 0,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              if (widget.canRate)
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: CustomButton(
                    onTap: () =>
                        Get.to(() => RateOutfit(outfit: widget.outfit)),
                    text: "rate_now".tr,
                    isSecondary: true,
                  ),
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
          Text(name.tr, style: AppTexts.tsmr),
          Spacer(),
          Text("${rating.toInt()}/10", style: AppTexts.tsmr),
        ],
      ),
    );
  }
}
