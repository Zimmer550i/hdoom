import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdoom/models/outfit_job_model.dart';
import 'package:hdoom/utils/app_colors.dart';
import 'package:hdoom/utils/app_texts.dart';
import 'package:hdoom/utils/custom_svg.dart';
import 'package:hdoom/views/widgets/custom_app_bar.dart';
import 'package:hdoom/views/widgets/custom_button.dart';
import 'package:hdoom/views/widgets/custom_networked_image.dart';

class WhyThisLook extends StatelessWidget {
  final OutfitJobModel outfitJob;
  const WhyThisLook({super.key, required this.outfitJob});

  void onSubmit() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "why_this_look_title".tr),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: .vertical(top: Radius.circular(12)),
                child: CustomNetworkedImage(
                  url: outfitJob.resultImage,
                  errorMessage: outfitJob.errorMessage,
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(outfitJob.reasoningTitle ?? "", style: AppTexts.txlm),
                    const SizedBox(height: 12),
                    Text(
                      outfitJob.reasoningSubtitle ?? "",
                      style: AppTexts.tsmr.copyWith(
                        color: AppColors.black.shade400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (outfitJob.reasoningItems.isNotEmpty)
                Text("why_we_chose_this".tr, style: AppTexts.txlm),
              const SizedBox(height: 16),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    for (int i = 0; i < outfitJob.reasoningItems.length; i++)
                      reasons(
                        i + 1,
                        outfitJob.reasoningItems[i].title,
                        outfitJob.reasoningItems[i].description,
                      ),

                    const SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppColors.green.shade50,
                      ),
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomSvg(asset: "assets/icons/note.svg"),
                              Text("style_note".tr, style: AppTexts.tlgm),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            outfitJob.reasoningNote ?? "",
                            style: AppTexts.tsmr,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              CustomButton(
                onTap: onSubmit,
                text: "save_this_look".tr,
                leading: "assets/icons/save.svg",
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget reasons(int num, String title, String details) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.green.shade50)),
      ),
      child: Column(
        children: [
          Row(
            spacing: 8,
            children: [
              Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.green.shade50,
                ),
                child: Center(
                  child: Text(
                    num.toString(),
                    style: AppTexts.tmdr.copyWith(color: AppColors.green),
                  ),
                ),
              ),
              Expanded(child: Text(title, style: AppTexts.tmdm)),
            ],
          ),
          const SizedBox(height: 8),
          Text(details, style: AppTexts.tsmr),
        ],
      ),
    );
  }
}
