import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdoom/controllers/outfit_controller.dart';
import 'package:hdoom/utils/ai_loading.dart';
import 'package:hdoom/utils/app_colors.dart';
import 'package:hdoom/utils/app_texts.dart';
import 'package:hdoom/utils/custom_snackbar.dart';
import 'package:hdoom/views/screens/home/save_outfit.dart';
import 'package:hdoom/views/screens/home/why_this_look.dart';
import 'package:hdoom/views/screens/home/widgets/home_text_button.dart';
import 'package:hdoom/views/widgets/custom_networked_image.dart';

/// Hero card displaying the AI-curated "Today's Look" outfit
/// with a blurred glass footer and action buttons.
class TodaysLookCard extends StatefulWidget {
  final bool hasActions;
  const TodaysLookCard({super.key, this.hasActions = true});

  @override
  State<TodaysLookCard> createState() => _TodaysLookCardState();
}

class _TodaysLookCardState extends State<TodaysLookCard> {
  final outfit = Get.find<OutfitController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          _buildImageSection(),
          if (outfit.todayOutfit.value != null) _buildDescriptionSection(),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      child: Stack(
        children: [
          Obx(() {
            if (!outfit.isTodayLoading.value &&
                outfit.todayOutfit.value == null) {
              outfit.getTodayOutfit().then((message) {
                if (message != "success") {
                  customSnackBar(message);
                }
              });
            }
            return AspectRatio(
              aspectRatio: 1,
              child:
                  outfit.isTodayLoading.value ||
                      outfit.todayOutfit.value == null ||
                      outfit.todayOutfit.value?.status == "processing"
                  ? AiLoading()
                  : CustomNetworkedImage(
                      url: outfit.todayOutfit.value?.resultImage,
                      errorMessage: outfit.todayOutfit.value?.errorMessage,
                    ),
            );
          }),
          if (widget.hasActions)
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
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            outfit.todayOutfit.value?.reasoningTitle ?? "",
            style: AppTexts.txlm,
          ),
          const SizedBox(height: 12),
          Text(
            outfit.todayOutfit.value?.reasoningSubtitle ?? "",
            style: AppTexts.tsmr.copyWith(color: AppColors.black.shade400),
          ),
          if (widget.hasActions) const SizedBox(height: 28),
          if (widget.hasActions)
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
                      Get.to(
                        () => WhyThisLook(outfitJob: outfit.todayOutfit.value!),
                      );
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
