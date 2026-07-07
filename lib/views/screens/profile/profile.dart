import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdoom/utils/app_colors.dart';
import 'package:hdoom/utils/app_texts.dart';
import 'package:hdoom/utils/custom_svg.dart';
import 'package:hdoom/utils/formatter.dart';
import 'package:hdoom/views/screens/auth/authentication.dart';
import 'package:hdoom/views/screens/profile/change_password.dart';
import 'package:hdoom/views/screens/profile/edit_profile.dart';
import 'package:hdoom/views/screens/profile/info.dart';
import 'package:hdoom/views/screens/profile/subscription.dart';
import 'package:hdoom/views/widgets/custom_app_bar.dart';
import 'package:hdoom/views/widgets/custom_button.dart';
import 'package:hdoom/views/widgets/overlay_confirmation.dart';
import 'package:hdoom/views/widgets/profile_picture.dart';

class Profile extends StatefulWidget {
  final bool isUserProfile;
  const Profile({super.key, this.isUserProfile = false});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final OverlayPortalController _overlayController = OverlayPortalController();
  final LayerLink _layerLink = LayerLink();

  bool isPublic = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        hasLeading: !widget.isUserProfile,
        title: "profile".tr,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SafeArea(
          child: Column(
            children: [
              widget.isUserProfile ? userProfile() : publicProfile(),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("outfit".tr, style: AppTexts.txlm),
              ),
              const SizedBox(height: 16),
              GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.66,
                ),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  for (int i = 0; i < 6; i++)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white),
                        child: Column(
                          children: [
                            Expanded(
                              child: SizedBox.expand(
                                child: Image.asset(
                                  "assets/images/style_casual.jpg",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "soft_beige_evening".tr,
                                    style: AppTexts.tmdm,
                                  ),
                                  Text("casual".tr, style: AppTexts.tsmr),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget userProfile() {
    return Column(
      children: [
        Row(
          children: [
            ProfilePicture(image: "https://picsum.photos/200/200", size: 72),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("your_name_here".tr, style: AppTexts.tlgm),
                  Text("mrjohn123@gmail.com", style: AppTexts.tmdr),
                ],
              ),
            ),
            // Overlay trigger button
            CompositedTransformTarget(
              link: _layerLink,
              child: OverlayPortal(
                controller: _overlayController,
                overlayChildBuilder: (context) {
                  return Stack(
                    children: [
                      // Dismiss barrier
                      Positioned.fill(
                        child: GestureDetector(
                          onTap: () => _overlayController.hide(),
                          behavior: HitTestBehavior.opaque,
                          child: SizedBox.expand(
                            child: Container(
                              color: Colors.black.withValues(alpha: 0.3),
                            ),
                          ),
                        ),
                      ),
                      // Overlay content
                      CompositedTransformFollower(
                        link: _layerLink,
                        targetAnchor: Get.locale == const Locale('ar')
                            ? Alignment.bottomLeft
                            : Alignment.bottomRight,
                        followerAnchor: Get.locale == const Locale('ar')
                            ? Alignment.topLeft
                            : Alignment.topRight,
                        offset: const Offset(0, 8),
                        child: Container(
                          width: MediaQuery.of(context).size.width - 40,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              menuRow("edit_profile".tr, "user", () {
                                Get.to(() => EditProfile());
                              }),
                              menuRow("change_password".tr, "password", () {
                                Get.to(() => ChangePassword());
                              }),
                              menuRow("privacy_policy".tr, "privacy", () {
                                Get.to(() => Info(title: "privacy_policy".tr));
                              }),
                              menuRow("about_us".tr, "about", () {
                                Get.to(() => Info(title: "about_us".tr));
                              }),
                              menuRow("log_out".tr, "logout", () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => OverlayConfirmation(
                                    title: "logout_confirm".tr,
                                    highlight: "logout".tr,
                                    buttonTextLeft: "cancel".tr,
                                    buttonCallBackLeft: () {
                                      Get.back();
                                      Get.back();
                                    },
                                    buttonTextRight: "logout".tr,
                                    buttonCallBackRight: () {
                                      Get.offAll(() => Authentication());
                                    },
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
                child: GestureDetector(
                  onTap: () => _overlayController.toggle(),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.green),
                    ),
                    child: Icon(
                      Icons.more_vert,
                      size: 18,
                      color: AppColors.green,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Color(0xffFBF0F2)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            spacing: 12,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "HDOOM-i",
                      style: AppTexts.tmds.copyWith(color: AppColors.green),
                    ),
                    Text("subscription_active".tr, style: AppTexts.tsmr),
                  ],
                ),
              ),
              CustomButton(
                onTap: () {
                  Get.to(() => Subscription());
                },
                text: "manage".tr,
                width: null,
                height: 40,
                padding: 24,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Row(
                spacing: 12,
                children: [
                  statBox("style".tr, 247, isGreen: true),
                  statBox("followers".tr, 1024, isGreen: true),
                  statBox("following".tr, 268, isGreen: true),
                ],
              ),
              Divider(thickness: 1, height: 32, color: AppColors.green.shade50),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("public_profile".tr, style: AppTexts.tmdm),
                        Text(
                          "allow_others_see_profile".tr,
                          style: AppTexts.tsmr,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                    width: 36,
                    child: Switch(
                      value: isPublic,
                      activeTrackColor: AppColors.green,
                      onChanged: (val) {
                        setState(() {
                          isPublic = val;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget menuRow(String title, String iconName, void Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Row(
          spacing: 8,
          children: [
            CustomSvg(asset: "assets/icons/$iconName.svg", size: 24),
            Expanded(child: Text(title, style: AppTexts.tmdr)),
            CustomSvg(asset: "assets/icons/arrow_right.svg", size: 24),
          ],
        ),
      ),
    );
  }

  Column publicProfile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ProfilePicture(image: "https://picsum.photos/200/200", size: 72),
        const SizedBox(height: 12),
        Text("your_name_here".tr, style: AppTexts.tlgm),
        Text("mrjohn123@gmail.com", style: AppTexts.tmdr),
        const SizedBox(height: 20),
        CustomButton(text: "follow".tr, height: 40, width: null),
        const SizedBox(height: 20),
        Row(
          spacing: 12,
          children: [
            statBox("style".tr, 247),
            statBox("followers".tr, 1024),
            statBox("following".tr, 268),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Expanded statBox(String name, int value, {bool isGreen = false}) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isGreen ? AppColors.green.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(Formatter.compactNumber(value), style: AppTexts.tmds),
            Text(name, style: AppTexts.tmdr),
          ],
        ),
      ),
    );
  }
}
