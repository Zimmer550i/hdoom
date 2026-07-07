import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdoom/utils/app_colors.dart';
import 'package:hdoom/utils/app_texts.dart';
import 'package:hdoom/views/widgets/custom_app_bar.dart';
import 'package:hdoom/views/widgets/custom_button.dart';

class Subscription extends StatelessWidget {
  const Subscription({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "subscription".tr),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 4),
                          blurRadius: 4,
                          color: Colors.black.withValues(alpha: 0.08),
                        ),
                      ],
                    ),
                    child: Column(
                      spacing: 12,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.width / 3),
                        Text(
                          "features".tr,
                          style: AppTexts.tlgm.copyWith(color: AppColors.green),
                        ),
                        featureRow(
                          "feature_unlimited_recommendations".tr,
                        ),
                        featureRow(
                          "feature_advanced_ai".tr,
                        ),
                        featureRow("feature_event_based".tr),
                        featureRow(
                          "feature_why_this_look".tr,
                        ),
                        featureRow("feature_influencer_content".tr),
                        featureRow(
                          "feature_save_unlimited".tr,
                        ),
                        featureRow("feature_ad_free".tr),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                  Positioned(
                    top: -20,
                    left: 0,
                    right: 0,
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Center(
                          child: Image.asset(
                            "assets/images/banner.png",
                            width: MediaQuery.of(context).size.width / 2,
                          ),
                        ),
                        Column(
                          children: [
                            const SizedBox(height: 14),
                            Text(
                              "premium".tr,
                              style: AppTexts.dxsm.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "per_month".tr,
                              style: AppTexts.txsr.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 3,
                                  color: Colors.white,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "\$",
                                    style: AppTexts.txsm.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "50",
                                    style: AppTexts.tlgm.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: -20,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: CustomButton(
                        text: "buy_now".tr,
                        height: 50,
                        width: MediaQuery.of(context).size.width / 1.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  Row featureRow(String feature) {
    return Row(
      spacing: 6,
      children: [
        Container(
          height: 8,
          width: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.green,
          ),
        ),
        Expanded(child: Text(feature, style: AppTexts.tsmr)),
      ],
    );
  }
}
