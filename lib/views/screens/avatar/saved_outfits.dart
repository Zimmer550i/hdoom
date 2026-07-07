import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdoom/utils/app_colors.dart';
import 'package:hdoom/utils/app_texts.dart';
import 'package:hdoom/utils/custom_list_handler.dart';
import 'package:hdoom/utils/custom_svg.dart';
import 'package:hdoom/utils/formatter.dart';
import 'package:hdoom/views/screens/avatar/outfit_recommendation.dart';
import 'package:hdoom/views/widgets/custom_app_bar.dart';
import 'package:hdoom/views/widgets/profile_picture.dart';

class SavedOutfits extends StatelessWidget {
  const SavedOutfits({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "save_item".tr),
      body: CustomListHandler(
        spacing: 12,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    Formatter.dateFormatterLong(DateTime.now()),
                    style: AppTexts.tmdm.copyWith(
                      color: AppColors.black.shade400,
                    ),
                  ),
                ),
                Text(
                  "items_count".trParams({"count": "11"}),
                  style: AppTexts.tmdr.copyWith(
                    color: AppColors.black.shade400,
                  ),
                ),
              ],
            ),
          ),
          for (int i = 0; i < 10; i++)
            GestureDetector(
              onTap: () {
                Get.to(() => OutfitRecommendation());
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.green.shade100,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  spacing: 12,
                  children: [
                    ProfilePicture(
                      image: "https://picsum.photos/200/200",
                      size: 50,
                    ),
                    Expanded(child: Text("casual".tr, style: AppTexts.tsmr)),
                    CustomSvg(asset: "assets/icons/arrow_right_circled.svg"),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
