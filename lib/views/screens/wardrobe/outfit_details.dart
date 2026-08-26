import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdoom/controllers/outfit_controller.dart';
import 'package:hdoom/models/saved_outfit_model.dart';
import 'package:hdoom/utils/app_colors.dart';
import 'package:hdoom/utils/app_texts.dart';
import 'package:hdoom/utils/custom_snackbar.dart';
import 'package:hdoom/views/screens/home/save_for_a_day.dart';
import 'package:hdoom/views/screens/home/why_this_look.dart';
import 'package:hdoom/views/widgets/custom_app_bar.dart';
import 'package:hdoom/views/widgets/custom_button.dart';
import 'package:hdoom/views/widgets/custom_loading.dart';
import 'package:hdoom/views/widgets/custom_networked_image.dart';
import 'package:hdoom/views/widgets/overlay_confirmation.dart';

class OutfitDetails extends StatefulWidget {
  final SavedOutfitModel outfit;
  const OutfitDetails({super.key, required this.outfit});

  @override
  State<OutfitDetails> createState() => _OutfitDetailsState();
}

class _OutfitDetailsState extends State<OutfitDetails> {
  final outfitCtrl = Get.find<OutfitController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Outfit Details"),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: CustomNetworkedImage(
                  url: widget.outfit.outfitJob?.resultImage,
                ),
              ),
              Padding(
                padding: .all(20),
                child: Column(
                  crossAxisAlignment: .start,
                  spacing: 8,
                  children: [
                    Text(
                      widget.outfit.outfitJob?.reasoningTitle ?? "",
                      style: AppTexts.txlm,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.outfit.outfitJob?.reasoningSubtitle ?? "",
                      style: AppTexts.tsmr.copyWith(
                        color: AppColors.black.shade400,
                      ),
                    ),
                    Row(
                      children: [
                        Text("Show Public", style: AppTexts.tmdr),
                        Spacer(),
                        Obx(() {
                          final idx = outfitCtrl.savedOutfits.indexWhere(
                            (element) => element.id == widget.outfit.id,
                          );

                          final liveOutfit = outfitCtrl.savedOutfits
                              .elementAtOrNull(idx);

                          return Row(
                            spacing: 12,
                            children: [
                              if (outfitCtrl.isSavedLoading.value)
                                CustomLoading(padding: 0),

                              Switch(
                                value: liveOutfit?.isShared ?? false,
                                padding: EdgeInsets.zero,
                                activeTrackColor: AppColors.green,
                                onChanged: (val) {
                                  outfitCtrl
                                      .updateSavedOutfit(
                                        widget.outfit.id,
                                        isShared: val,
                                      )
                                      .then((message) {
                                        if (message != "success") {
                                          customSnackBar(message);
                                        }
                                      });
                                },
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                    CustomButton(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => OverlayConfirmation(
                            title:
                                "Are you sure your want to delete this outfit?",
                            buttonTextLeft: "Confirm",
                            buttonCallBackLeft: () {
                              Get.back();
                              Get.back();
                              Get.find<OutfitController>()
                                  .deleteSavedOutfit(widget.outfit.id)
                                  .then((message) {
                                    if (message == "success") {
                                      customSnackBar(
                                        "Outfit has been deleted",
                                        isError: false,
                                      );
                                    } else {
                                      customSnackBar(message);
                                    }
                                  });
                            },
                            buttonTextRight: "Go Back",
                            buttonCallBackRight: () {
                              Get.back();
                            },
                          ),
                        );
                      },
                      isSecondary: true,
                      text: "Remove this outfit",
                    ),
                    CustomButton(
                      onTap: () {
                        if (widget.outfit.outfitJob != null) {
                          Get.to(
                            () => WhyThisLook(
                              outfitJob: widget.outfit.outfitJob!,
                            ),
                          );
                        }
                      },
                      text: "Why this look?",
                    ),
                    CustomButton(
                      onTap: () {
                        if (widget.outfit.outfitJob != null) {
                          Get.to(
                            () => SaveForADay(outfit: widget.outfit.outfitJob!),
                          );
                        }
                      },
                      text: "Save for a day",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
