import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdoom/utils/app_colors.dart';
import 'package:hdoom/utils/app_texts.dart';
import 'package:hdoom/views/screens/home/save_outfit.dart';
import 'package:hdoom/views/screens/home/why_this_look.dart';
import 'package:hdoom/views/screens/home/widgets/home_text_button.dart';

/// Hero card displaying the AI-curated "Today's Look" outfit
/// with a blurred glass footer and action buttons.
class TodaysLookCard extends StatelessWidget {
  final bool hasActions;
  const TodaysLookCard({super.key, this.hasActions = true});

  @override
  Widget build(BuildContext context) {
    return Column(children: [_buildImageSection(), _buildDescriptionSection()]);
  }

  Widget _buildImageSection() {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 4 / 5,
            child: Image.asset("assets/images/avatar.png", fit: BoxFit.cover),
          ),
          if (hasActions)
            Positioned(
              left: 20,
              top: 26,
              child: Column(
                children: [
                  Text(
                    "todays_look".tr,
                    style: AppTexts.tsmm.copyWith(color: Colors.white),
                  ),
                  Container(height: 1, width: 85, color: Colors.white),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("elegant_everyday_abaya".tr, style: AppTexts.txlm),
          const SizedBox(height: 12),
          Text(
            "elegant_everyday_abaya_desc".tr,
            style: AppTexts.tsmr.copyWith(color: AppColors.black.shade400),
          ),
          if (hasActions) const SizedBox(height: 28),
          if (hasActions)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.green.shade50,
              ),
              child: Row(
                children: [
                  HomeTextButton(
                    title: "why_this_look".tr,
                    onTap: () {
                      Get.to(() => WhyThisLook());
                    },
                  ),
                  HomeTextButton(
                    title: "save_look".tr,
                    onTap: () {
                      Get.to(() => SaveOutfit());
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
