import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdoom/controllers/wardrobe_controller.dart';
import 'package:hdoom/models/item_model.dart';
import 'package:hdoom/utils/app_colors.dart';
import 'package:hdoom/utils/app_texts.dart';
import 'package:hdoom/utils/custom_snackbar.dart';
import 'package:hdoom/views/widgets/custom_app_bar.dart';
import 'package:hdoom/views/widgets/custom_button.dart';
import 'package:hdoom/views/widgets/custom_networked_image.dart';
import 'package:hdoom/views/widgets/overlay_confirmation.dart';

class ItemDetails extends StatelessWidget {
  final ItemModel item;
  const ItemDetails({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: CustomAppBar(title: 'item_details'.tr),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Stack(
                  children: [
                    // Image
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: CustomNetworkedImage(
                          width: double.infinity,
                          url: item.analysis?.processedImage ?? item.image,
                          fit: .cover,
                        ),
                      ),
                    ),
                    // Details Card (positioned at the bottom overlapping)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 0),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, -5),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildDetailItem('category'.tr, item.category.name),
                            _buildDetailItem('season'.tr, item.season),
                            _buildDetailItem('occasion'.tr, item.occasion),
                            _buildDetailItem('source'.tr, item.purchaseSource),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildSecondaryButton('remove_item'.tr, context),
                  const SizedBox(height: 12),
                  CustomButton(text: 'try_on'.tr, onTap: () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTexts.txss.copyWith(color: AppColors.black.shade300),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTexts.tsmm.copyWith(color: AppColors.black.shade500),
        ),
      ],
    );
  }

  Widget _buildSecondaryButton(String text, BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => OverlayConfirmation(
            title: "Are you sure your want to delete this item?",
            buttonTextLeft: "Confirm",
            buttonCallBackLeft: () {
              Get.back();
              Get.back();
              Get.find<WardrobeController>().deleteWardrobeItem(item.id).then((
                message,
              ) {
                if (message == "success") {
                  customSnackBar("Item has been deleted", isError: false);
                } else {
                  customSnackBar(message);
                }
              });
            },
            buttonTextRight: "Go Back",
            buttonCallBackRight: () {
              Get.back();
            },
          ),
        );
      },
      borderRadius: BorderRadius.circular(99),
      child: Container(
        width: double.infinity,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(99),
          border: Border.all(color: AppColors.black.shade100),
        ),
        child: Text(
          text,
          style: AppTexts.tmdm.copyWith(color: AppColors.black.shade400),
        ),
      ),
    );
  }
}
