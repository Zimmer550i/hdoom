import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdoom/controllers/user_controller.dart';
import 'package:hdoom/utils/app_colors.dart';
import 'package:hdoom/utils/app_texts.dart';
import 'package:hdoom/utils/custom_svg.dart';
import 'package:hdoom/views/screens/home/search_user.dart';
import 'package:hdoom/views/widgets/profile_picture.dart';

/// Builds the Home screen's custom [AppBar] with user greeting,
/// profile picture, and action icons.
AppBar buildHomeAppBar() {
  final userController = Get.find<UserController>();
  return AppBar(
    titleSpacing: 0,
    backgroundColor: AppColors.bg,
    surfaceTintColor: AppColors.green,
    title: Row(
      children: [
        const SizedBox(width: 20),
        Obx(
          () => ProfilePicture(
            image: userController.user?.profileImage,
            size: 36,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(
                () => Text(
                  "good_morning".trParams({
                    "name": userController.user?.name.isNotEmpty == true
                        ? userController.user!.name
                        : "User",
                  }),
                  style: AppTexts.txlm.copyWith(color: AppColors.green),
                ),
              ),
              Text(
                "heres_your_outfit".tr,
                style: AppTexts.tsmr.copyWith(color: AppColors.black.shade400),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: () => Get.to(() => SearchUser()),
          child: CustomSvg(asset: "assets/icons/search.svg", size: 28),
        ),
        const SizedBox(width: 20),
      ],
    ),
  );
}
