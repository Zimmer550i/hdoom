import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdoom/utils/app_colors.dart';
import 'package:hdoom/utils/app_texts.dart';
import 'package:hdoom/utils/custom_svg.dart';
import 'package:hdoom/views/screens/home/widgets/todays_look_card.dart';
import 'package:hdoom/views/widgets/custom_app_bar.dart';
import 'package:hdoom/views/widgets/custom_button.dart';

class WhyThisLook extends StatelessWidget {
  const WhyThisLook({super.key});

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
              TodaysLookCard(hasActions: false),
              const SizedBox(height: 20),
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
                    for (int i = 0; i < 4; i++)
                      reasons(
                        i + 1,
                        "style_matched".tr,
                        "style_matched_desc".tr,
                      ),

                    const SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppColors.green.shade50,
                      ),
                      child: Column(
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
                            "style_note_desc".tr,
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
