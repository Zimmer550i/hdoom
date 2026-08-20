import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdoom/controllers/ai_image_controller.dart';
import 'package:hdoom/utils/ai_loading.dart';
import 'package:hdoom/utils/app_colors.dart';
import 'package:hdoom/utils/app_texts.dart';
import 'package:hdoom/utils/custom_snackbar.dart';
import 'package:hdoom/utils/custom_svg.dart';
import 'package:hdoom/views/screens/avatar/avatar_creation.dart';
import 'package:hdoom/views/screens/avatar/generated_avatars.dart';
import 'package:hdoom/views/screens/avatar/upload_image.dart';
import 'package:hdoom/views/widgets/custom_button.dart';
import 'package:hdoom/views/widgets/custom_networked_image.dart';

class Avatar extends StatefulWidget {
  const Avatar({super.key});

  @override
  State<Avatar> createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  String type = "cartoon";

  void onSubmit() async {
    final avatar = Get.find<AiImageController>();

    final message = await avatar.createAvatar();

    if (message == "success") {
      Get.to(() => AvatarCreation());
    } else {
      customSnackBar(message);
    }
  }

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
                    Get.to(() => GeneratedAvatars());
                  },
                  child: CustomSvg(asset: "assets/icons/save.svg"),
                ),
                const SizedBox(width: 20),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Obx(() {
                  final avatar = Get.find<AiImageController>();
                  if (avatar.defaultAvatar.value == null &&
                      !avatar.isLoading.value) {
                    avatar.getDefaultAvatar(type: type);
                  }
                  return Column(
                    spacing: 12,
                    children: [
                      avatar.defaultAvatar.value == null || avatar.isLoading.value
                          ? AiLoading()
                          : CustomNetworkedImage(
                              height: MediaQuery.of(context).size.width,
                              url: avatar.defaultAvatar.value!.resultImage,
                              errorMessage: avatar.defaultAvatar.value?.errorMessage,
                            ),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text("Style", style: AppTexts.tmdm),
                            ),
                            SegmentedButton(
                              onSelectionChanged: (p0) {
                                setState(() {
                                  type = p0.first;
                                });
                                avatar.getDefaultAvatar(type: type);
                              },
                              style: ButtonStyle(
                                backgroundColor: WidgetStateColor.resolveWith((
                                  state,
                                ) {
                                  if (state.contains(WidgetState.selected)) {
                                    return AppColors.green[50]!;
                                  } else {
                                    return AppColors.bg;
                                  }
                                }),
                              ),
                              segments: [
                                ButtonSegment(
                                  value: "cartoon",
                                  label: Text("Cartoon", style: AppTexts.tsmr),
                                  enabled: true,
                                ),
                                ButtonSegment(
                                  value: "realistic",
                                  label: Text(
                                    "Realistic",
                                    style: AppTexts.tsmr,
                                  ),
                                  enabled: true,
                                ),
                              ],
                              selected: {type},
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            CustomButton(
                              onTap: () => Get.to(() => AvatarCreation()),
                              text: "use_this_image".tr,
                              isSecondary: true,
                              // isLoading: avatar.isLoading.value,
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
                                Get.to(() => UploadImage(
                                  type: type
                                ));
                              },
                              text: "upload_new_image".tr,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
