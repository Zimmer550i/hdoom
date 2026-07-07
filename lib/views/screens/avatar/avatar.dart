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
      // appBar: AppBar(
      //   titleSpacing: 0,
      //   backgroundColor: AppColors.bg,
      //   surfaceTintColor: AppColors.green,
      //   title: Row(
      //     children: [
      //       const SizedBox(width: 20),
      //       Expanded(
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: [
      //             Text(
      //               "Avatar Creation",
      //               style: AppTexts.txlm.copyWith(color: AppColors.green),
      //             ),
      //             Text(
      //               "Personalized your avatar for accurate outfit recommendations",
      //               style: AppTexts.tsmr.copyWith(
      //                 color: AppColors.black.shade400,
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //       const SizedBox(width: 16),
      //       CustomSvg(asset: "assets/icons/save.svg"),
      //       const SizedBox(width: 20),
      //     ],
      //   ),
      // ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: .start,
              children: [
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Avatar Creation",
                        style: AppTexts.txlm.copyWith(color: AppColors.green),
                      ),
                      Text(
                        "Personalized your avatar for accurate outfit recommendations",
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
            // const SizedBox(height: 16),
            // Padding(
            //   padding: .symmetric(horizontal: 20),
            //   child: LinearProgressIndicator(
            //     value: 0.25,
            //     color: AppColors.green.shade300,
            //     backgroundColor: AppColors.black.shade100,
            //     borderRadius: BorderRadius.circular(99),
            //   ),
            // ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: .symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          const SizedBox(height: 28),
                          Text("Select image or upload", style: AppTexts.txlm),
                          const SizedBox(height: 0),
                          Text(
                            "To suggest the best outfit for you, please first select or upload your reference picture",
                            style: AppTexts.tsmr,
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                    Image.asset("assets/images/avatar.png"),
                    Padding(
                      padding: .symmetric(horizontal: 20, vertical: 50),
                      child: Column(
                        children: [
                          CustomButton(
                            onTap: () {
                              Get.to(() => AvatarCreation());
                            },
                            text: "Use This Image",
                            isSecondary: true,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            spacing: 12,
                            children: [
                              Expanded(
                                child: Divider(color: Color(0xffeeeeee)),
                              ),
                              Text("or", style: AppTexts.tlgr),
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
                            text: "Upload New Image",
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
