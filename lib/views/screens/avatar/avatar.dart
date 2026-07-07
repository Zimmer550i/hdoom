import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdoom/utils/app_colors.dart';
import 'package:hdoom/utils/app_texts.dart';
import 'package:hdoom/utils/custom_svg.dart';
import 'package:hdoom/views/screens/avatar/avatar_creation.dart';
import 'package:hdoom/views/screens/avatar/saved_outfits.dart';
import 'package:hdoom/views/screens/avatar/upload_image.dart';
import 'package:hdoom/views/widgets/custom_button.dart';

class Avatar extends StatelessWidget {
  const Avatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "avatar_creation".tr,
                        style: AppTexts.txlm.copyWith(color: AppColors.green),
                      ),
                      Text(
                        "avatar_creation_subtitle".tr,
                        style: AppTexts.tsmr.copyWith(
                          color: AppColors.black.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () {
                    Get.to(() => SavedOutfits());
                  },
                  child: CustomSvg(asset: "assets/icons/save.svg"),
                ),
                const SizedBox(width: 20),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 28),
                          Text("select_image_or_upload".tr, style: AppTexts.txlm),
                          const SizedBox(height: 0),
                          Text(
                            "select_image_or_upload_subtitle".tr,
                            style: AppTexts.tsmr,
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                    Image.asset("assets/images/avatar.png"),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                      child: Column(
                        children: [
                          CustomButton(
                            onTap: () {
                              Get.to(() => AvatarCreation());
                            },
                            text: "use_this_image".tr,
                            isSecondary: true,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            spacing: 12,
                            children: [
                              Expanded(
                                child: Divider(color: Color(0xffeeeeee)),
                              ),
                              Text("or".tr, style: AppTexts.tlgr),
                              Expanded(
                                child: Divider(color: Color(0xffeeeeee)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          CustomButton(
                            onTap: () {
                              Get.to(() => UploadImage());
                            },
                            text: "upload_new_image".tr,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
