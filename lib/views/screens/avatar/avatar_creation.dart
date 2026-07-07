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
      appBar: CustomAppBar(title: "Avatar Creation"),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  const SizedBox(height: 12),
                  Text("Avatar Created", style: AppTexts.tlgm),
                  const SizedBox(height: 4),
                  Text(
                    "Your avatar has been generated. Now please select your preferences, and we’ll create the best outfit for you using items from your wardrobe.",
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
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      "Select Item From Your Wardrobe",
                      style: AppTexts.tlgm,
                    ),
                    const SizedBox(),
                    selector("Dresses", 0),
                    selector("Shoes", 1),
                    selector("Bag", 2),
                    const SizedBox(height: 40),
                    CustomButton(
                      onTap: () {
                        Get.to(() => OutfitRecommendation());
                      },
                      text: "Create Avatar",
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
      padding: .all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 0.5, color: AppColors.black.shade50),
        borderRadius: .circular(20),
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
      padding: .symmetric(horizontal: 20),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: .start,
          children: [
            const SizedBox(height: 12),
            Text("Wait a minute", style: AppTexts.tlgm),
            const SizedBox(height: 4),
            Text(
              "An image is being created from your uploaded image. Please wait...",
              style: AppTexts.tsmr.copyWith(color: AppColors.black.shade400),
            ),
            const SizedBox(height: 200),
            Center(
              child: SizedBox(
                height: 200,
                width: 200,
                child: CircularProgressIndicator(
                  color: AppColors.green.shade400,
                  strokeCap: .round,
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
