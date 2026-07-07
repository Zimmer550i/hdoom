import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdoom/utils/app_colors.dart';
import 'package:hdoom/utils/app_texts.dart';
import 'package:hdoom/utils/custom_svg.dart';
import 'package:hdoom/views/widgets/profile_picture.dart';

/// Builds the Home screen's custom [AppBar] with user greeting,
/// profile picture, and action icons.
AppBar buildHomeAppBar() {
  return AppBar(
    titleSpacing: 0,
    backgroundColor: AppColors.bg,
    surfaceTintColor: AppColors.green,
    title: Row(
      children: [
        const SizedBox(width: 20),
        ProfilePicture(image: "https://picsum.photos/200/200", size: 36),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "good_morning".trParams({"name": "Ayesha"}),
                style: AppTexts.txlm.copyWith(color: AppColors.green),
              ),
              Text(
                "heres_your_outfit".tr,
                style: AppTexts.tsmr.copyWith(
                  color: AppColors.black.shade400,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        CustomSvg(asset: "assets/icons/save.svg"),
        const SizedBox(width: 20),
      ],
    ),
  );
}
