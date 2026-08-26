import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdoom/controllers/ai_image_controller.dart';
import 'package:hdoom/controllers/outfit_controller.dart';
import 'package:hdoom/controllers/wardrobe_controller.dart';
import 'package:hdoom/models/item_model.dart';
import 'package:hdoom/utils/ai_loading.dart';
import 'package:hdoom/utils/app_colors.dart';
import 'package:hdoom/utils/app_icons.dart';
import 'package:hdoom/utils/app_texts.dart';
import 'package:hdoom/utils/custom_snackbar.dart';
import 'package:hdoom/utils/custom_svg.dart';
import 'package:hdoom/views/screens/avatar/try_on.dart';
import 'package:hdoom/views/widgets/custom_app_bar.dart';
import 'package:hdoom/views/widgets/custom_button.dart';
import 'package:hdoom/views/widgets/custom_loading.dart';
import 'package:hdoom/views/widgets/custom_networked_image.dart';

class AvatarCreation extends StatefulWidget {
  final bool useDefault;
  final List<int> alreadySelectedOutfit;
  const AvatarCreation({
    super.key,
    this.useDefault = false,
    this.alreadySelectedOutfit = const [],
  });

  @override
  State<AvatarCreation> createState() => _AvatarCreationState();
}

class _AvatarCreationState extends State<AvatarCreation> {
  final avatar = Get.find<AiImageController>();
  final wardrobe = Get.find<WardrobeController>();
  final outfit = Get.find<OutfitController>();

  List<int> selectedItems = [];
  int index = -1;

  @override
  void initState() {
    super.initState();
    selectedItems = widget.alreadySelectedOutfit.toList();
    WidgetsBinding.instance.addPostFrameCallback((val) {
      wardrobe.getWardrobeItems().then((message) {
        if (message != "success") {
          customSnackBar(message);
        }
      });
      if (widget.useDefault && avatar.defaultAvatar.value == null) {
        avatar.getDefaultAvatar().then((message) {
          if (message != "success") {
            customSnackBar(message);
          }
        });
      }
    });
  }

  void onSubmit() async {
    final message = await outfit.createTryOn(
      avatarId: widget.useDefault
          ? avatar.defaultAvatar.value!.id
          : avatar.currentAvatar.value!.id,
      wardrobeItemIds: selectedItems,
    );

    if (message == "success") {
      Get.to(() => TryOn());
    } else {
      customSnackBar(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "avatar_creation".tr),
      body: SingleChildScrollView(
        child: Obx(
          () =>
              widget.useDefault &&
                  (avatar.defaultAvatar.value == null || avatar.isLoading.value)
              ? AiLoading()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),
                          !widget.useDefault &&
                                  avatar.currentAvatar.value?.status ==
                                      "processing"
                              ? Text("Generating Avatar", style: AppTexts.tlgm)
                              : Text("avatar_created".tr, style: AppTexts.tlgm),
                          const SizedBox(height: 4),
                          if (!widget.useDefault &&
                              avatar.currentAvatar.value?.status ==
                                  "processing")
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
                    widget.useDefault
                        ? Center(
                            child: CustomNetworkedImage(
                              height: MediaQuery.of(context).size.width,
                              url: avatar.defaultAvatar.value!.resultImage,
                            ),
                          )
                        : avatar.currentAvatar.value?.status == "processing"
                        ? AiLoading()
                        : Center(
                            child: CustomNetworkedImage(
                              height: MediaQuery.of(context).size.width,
                              url: avatar.currentAvatar.value?.resultImage,
                            ),
                          ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 24,
                      ),
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
                            getWardrobe(),
                            const SizedBox(height: 40),
                            Obx(
                              () => CustomButton(
                                onTap: onSubmit,
                                isLoading: outfit.isTryOnLoading.value,
                                text: "Generate Outfit",
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget selector(String title, List<ItemModel> items, int pos) {
    return GestureDetector(
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
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 0.5, color: AppColors.black.shade50),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          spacing: 12,
          crossAxisAlignment: .start,
          children: [
            Row(
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
            if (index == pos)
              SizedBox(
                height: 50,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (var i in items)
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: _buildProductCard(i),
                      ),
                  ],
                ),
              ),
          ],
        ),
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

  Widget _buildProductCard(ItemModel item) {
    bool hasError = !["done", "processing"].contains(item.analysis?.status);
    return GestureDetector(
      onTap: () {
        if (hasError) return;
        setState(() {
          if (selectedItems.contains(item.id)) {
            selectedItems.remove(item.id);
          } else {
            selectedItems.add(item.id);
          }
        });
      },
      child: Stack(
        alignment: .center,
        children: [
          Container(
            width: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              border: selectedItems.contains(item.id)
                  ? Border.all(color: AppColors.green)
                  : null,
              borderRadius: BorderRadius.circular(12),
            ),
            child: AbsorbPointer(
              child: CustomNetworkedImage(
                radius: selectedItems.contains(item.id) ? 12 : 0,
                url: item.analysis?.displayUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          if (hasError)
            Center(child: Icon(Icons.error, color: Colors.redAccent)),
        ],
      ),
    );
  }

  Widget getWardrobe() {
    return Obx(
      () => wardrobe.isWardrobeItemsLoading.value
          ? CustomLoading()
          : Column(
              spacing: 4,
              children: [
                if(wardrobe.itemCategories.entries.isEmpty)
                  Center(child: Text("No items in your wardrobe", style: AppTexts.tsmr,)),
                for (var i in wardrobe.itemCategories.entries.indexed)
                  selector(i.$2.key.name, i.$2.value, i.$1),
              ],
            ),
    );
  }
}
