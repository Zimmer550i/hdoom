import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdoom/controllers/outfit_controller.dart';
import 'package:hdoom/controllers/social_controller.dart';
import 'package:hdoom/utils/app_colors.dart';
import 'package:hdoom/utils/app_texts.dart';
import 'package:hdoom/utils/formatter.dart';
import 'package:hdoom/views/screens/profile/profile_menu.dart';
import 'package:hdoom/views/screens/profile/subscription.dart';
import 'package:hdoom/views/screens/profile/users_list.dart';
import 'package:hdoom/views/screens/profile/view_outfit.dart';
import 'package:hdoom/views/widgets/custom_app_bar.dart';
import 'package:hdoom/views/widgets/custom_button.dart';
import 'package:hdoom/views/widgets/custom_loading.dart';
import 'package:hdoom/views/widgets/custom_networked_image.dart';
import 'package:hdoom/views/widgets/profile_picture.dart';
import 'package:hdoom/controllers/user_controller.dart';
import 'package:hdoom/utils/custom_snackbar.dart';

class Profile extends StatefulWidget {
  final bool isUserProfile;
  final String? username;
  const Profile({super.key, this.isUserProfile = false, this.username});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final social = Get.find<SocialController>();
  final outfit = Get.find<OutfitController>();
  final OverlayPortalController _overlayController = OverlayPortalController();
  final LayerLink _layerLink = LayerLink();

  bool isPublic = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.username == null) {
        getUserData();
      } else {
        getPublicData();
      }
    });
  }

  void getUserData() {
    final String username = Get.find<UserController>().user!.username ?? "";
    social.getUserProfile(username).then((message) {
      if (message != "success") {
        customSnackBar(message);
      }
    });

    outfit.getPublicSavedOutfits(username).then((message) {
      if (message != "success") {
        customSnackBar(message);
      }
    });
  }

  void getPublicData() {
    social.getUserProfile(widget.username!).then((message) {
      if (message != "success") {
        customSnackBar(message);
      }
    });

    outfit.getPublicSavedOutfits(widget.username!).then((message) {
      if (message != "success") {
        customSnackBar(message);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        hasLeading: widget.username != null,
        title: "profile".tr,
      ),
      body: Obx(
        () => social.isProfileLoading.value && widget.username != null
            ? CustomLoading()
            : SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SafeArea(
                  child: Column(
                    children: [
                      Obx(
                        () => widget.username == null
                            ? userProfile()
                            : publicProfile(),
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("outfit".tr, style: AppTexts.txlm),
                      ),
                      const SizedBox(height: 16),
                      Obx(
                        () => outfit.isPublicLoading.value
                            ? CustomLoading()
                            : outfit.publicOutfits.isEmpty
                            ? Text("Nothing to show")
                            : GridView(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 16,
                                      crossAxisSpacing: 16,
                                      childAspectRatio: 0.66,
                                    ),
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                children: [
                                  for (var i in outfit.publicOutfits)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: GestureDetector(
                                        onTap: () => Get.to(() => ViewOutfit()),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                          ),
                                          child: Column(
                                            children: [
                                              Expanded(
                                                child: SizedBox.expand(
                                                  child: CustomNetworkedImage(
                                                    url: i
                                                        .outfitJob
                                                        ?.resultImage,
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
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "soft_beige_evening".tr,
                                                      style: AppTexts.tmdm,
                                                    ),
                                                    Text(
                                                      "casual".tr,
                                                      style: AppTexts.tsmr,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget userProfile() {
    final userController = Get.find<UserController>();
    return Column(
      children: [
        Row(
          children: [
            ProfilePicture(image: userController.user?.profileImage, size: 72),
            const SizedBox(width: 12),
            Expanded(
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userController.user?.name.isNotEmpty == true
                          ? userController.user!.name
                          : "your_name_here".tr,
                      style: AppTexts.tlgm,
                    ),
                    if (userController.user?.email.isNotEmpty == true)
                      Text(userController.user!.email, style: AppTexts.tmdr),
                  ],
                ),
              ),
            ),
            // Overlay trigger button
            ProfileMenu(
              layerLink: _layerLink,
              overlayController: _overlayController,
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
              Obx(
                () => social.isProfileLoading.value
                    ? CustomLoading()
                    : Row(
                        spacing: 12,
                        children: [
                          statBox(
                            "style".tr,
                            social.viewedProfile.value?.sharedOutfitsCount ?? 0,
                            isGreen: true,
                          ),
                          statBox(
                            "followers".tr,
                            social.viewedProfile.value?.followersCount ?? 0,
                            isGreen: true,
                            onTap: () {
                              Get.to(
                                () => UsersList(
                                  username: userController.user!.username!,
                                  type: UserListType.followers,
                                ),
                              );
                            },
                          ),
                          statBox(
                            "following".tr,
                            social.viewedProfile.value?.followingCount ?? 0,
                            isGreen: true,
                            onTap: () {
                              Get.to(
                                () => UsersList(
                                  username: userController.user!.username!,
                                  type: UserListType.following,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
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

  Column publicProfile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ProfilePicture(
          image: social.viewedProfile.value?.profileImage,
          size: 72,
        ),
        const SizedBox(height: 12),
        Text(social.viewedProfile.value?.name ?? "", style: AppTexts.tlgm),
        Text(
          "${social.viewedProfile.value?.username}@gmail.com",
          style: AppTexts.tmdr,
        ),
        const SizedBox(height: 20),
        Obx(
          () => social.isFollowActionLoading.value
              ? CustomLoading()
              : CustomButton(
                  onTap: () {
                    social.toggleFollow(
                      widget.username!,
                      isFollowing:
                          social.viewedProfile.value?.isFollowing ?? false,
                    );
                  },
                  text: social.viewedProfile.value?.isFollowing == true
                      ? "Following"
                      : "Follow",
                  isSecondary: social.viewedProfile.value?.isFollowing == true,
                  height: 40,
                  width: null,
                ),
        ),
        const SizedBox(height: 20),
        Obx(
          () => social.isProfileLoading.value
              ? CustomLoading()
              : Row(
                  spacing: 12,
                  children: [
                    statBox(
                      "style".tr,
                      social.viewedProfile.value?.sharedOutfitsCount ?? 0,
                    ),
                    statBox(
                      "followers".tr,
                      social.viewedProfile.value?.followersCount ?? 0,
                      onTap: () {
                        Get.to(
                          () => UsersList(
                            username: social.viewedProfile.value!.username,
                            type: UserListType.followers,
                          ),
                        );
                      },
                    ),
                    statBox(
                      "following".tr,
                      social.viewedProfile.value?.followingCount ?? 0,
                      onTap: () {
                        Get.to(
                          () => UsersList(
                            username: social.viewedProfile.value!.username,
                            type: UserListType.following,
                          ),
                        );
                      },
                    ),
                  ],
                ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Expanded statBox(
    String name,
    int value, {
    bool isGreen = false,
    void Function()? onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
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
      ),
    );
  }
}
