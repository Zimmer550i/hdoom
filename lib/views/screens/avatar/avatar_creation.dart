import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdoom/utils/app_colors.dart';
import 'package:hdoom/utils/app_icons.dart';
import 'package:hdoom/utils/app_texts.dart';
import 'package:hdoom/utils/custom_svg.dart';
import 'package:hdoom/views/screens/avatar/outfit_recommendation.dart';
import 'package:hdoom/views/widgets/custom_app_bar.dart';
import 'package:hdoom/views/widgets/custom_button.dart';

class AvatarCreation extends StatefulWidget {
  const AvatarCreation({super.key});

  @override
  State<AvatarCreation> createState() => _AvatarCreationState();
}

class _AvatarCreationState extends State<AvatarCreation> {
  int index = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "avatar_creation".tr),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Text("avatar_created".tr, style: AppTexts.tlgm),
                  const SizedBox(height: 4),
                  Text(
                    "avatar_created_subtitle".tr,
                    style: AppTexts.tsmr.copyWith(
                      color: AppColors.black.shade400,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),
            Image.asset("assets/images/avatar.png"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: SafeArea(
                child: Column(
                  spacing: 12,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "select_item_from_wardrobe".tr,
                      style: AppTexts.tlgm,
                    ),
                    const SizedBox(),
                    selector("dresses".tr, 0),
                    selector("shoes".tr, 1),
                    selector("bag".tr, 2),
                    const SizedBox(height: 40),
                    CustomButton(
                      onTap: () {
                        Get.to(() => OutfitRecommendation());
                      },
                      text: "create_avatar".tr,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container selector(String title, int pos) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 0.5, color: AppColors.black.shade50),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        spacing: 12,
        children: [
          GestureDetector(
            onTap: () {
              if (index == pos) {
                setState(() {
                  index = -1;
                });
              } else {
                setState(() {
                  index = pos;
                });
              }
            },
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: AppTexts.tmdr.copyWith(
                      color: AppColors.black.shade400,
                    ),
                  ),
                ),
                AnimatedRotation(
                  duration: Duration(milliseconds: 300),
                  turns: index == pos ? 0.5 : 1,
                  child: CustomSvg(asset: AppIcons.arrowDown, size: 24),
                ),
              ],
            ),
          ),
          if (index == pos)
            SizedBox(
              height: 50,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: [
                  for (int i = 0; i < 10; i++)
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: _buildProductCard(),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget loading() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Text("wait_a_minute".tr, style: AppTexts.tlgm),
            const SizedBox(height: 4),
            Text(
              "wait_a_minute_subtitle".tr,
              style: AppTexts.tsmr.copyWith(color: AppColors.black.shade400),
            ),
            const SizedBox(height: 200),
            Center(
              child: SizedBox(
                height: 200,
                width: 200,
                child: CircularProgressIndicator(
                  color: AppColors.green.shade400,
                  strokeCap: StrokeCap.round,
                  strokeWidth: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 50,
        decoration: BoxDecoration(color: Colors.white),
        child: Image.asset("assets/images/bag.jpg", fit: BoxFit.cover),
      ),
    );
  }
}
