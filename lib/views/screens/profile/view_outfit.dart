import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdoom/utils/app_colors.dart';
import 'package:hdoom/utils/app_texts.dart';
import 'package:hdoom/views/screens/profile/rate_outfit.dart';
import 'package:hdoom/views/widgets/custom_app_bar.dart';
import 'package:hdoom/views/widgets/custom_button.dart';

class ViewOutfit extends StatefulWidget {
  const ViewOutfit({super.key});

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
              Image.asset("assets/images/avatar.png"),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  spacing: 8,
                  children: [
                    Row(
                      children: [
                        Text("overall_rating".tr, style: AppTexts.tlgm),
                        Spacer(),
                        Text("8/10", style: AppTexts.tlgm),
                      ],
                    ),
                    const SizedBox(),
                    ratingWidget("color_harmony", 8),
                    ratingWidget("trendy", 8),
                    ratingWidget("overall_matching", 8),
                    ratingWidget("accessories", 8),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              Row(
                children: [
                  const SizedBox(width: 20),
                  Expanded(child: CustomButton(text: "download_now".tr)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      onTap: () => Get.to(() => RateOutfit()),
                      text: "rate_now".tr,
                      isSecondary: true,
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
          Text(name.tr, style: AppTexts.tsmr),
          Spacer(),
          Text("${rating.toInt()}/10", style: AppTexts.tsmr),
        ],
      ),
    );
  }
}
