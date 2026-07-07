import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdoom/utils/app_colors.dart';
import 'package:hdoom/utils/app_texts.dart';
import 'package:hdoom/utils/custom_svg.dart';
import 'package:hdoom/views/screens/home/show_card_lists.dart';

/// Horizontally-scrolling "BRAND NEW" product showcase section.
class BrandNewSection extends StatelessWidget {
  const BrandNewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        const SizedBox(height: 16),
        _buildProductList(),
      ],
    );
  }

  Widget _buildHeader() {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => ShowCardLists(
            title: "brand_new".tr,
            data: [for (int i = 0; i < 10; i++) "Hi", "End"],
            builder: (val) {
              return _buildProductCard(hasWidth: false);
            },
          ),
        );
      },
      child: Row(
        children: [
          Expanded(child: Text("brand_new".tr, style: AppTexts.txlm)),
          CustomSvg(
            asset: "assets/icons/arrow_forward.svg",
            color: AppColors.black.shade300,
          ),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    return SizedBox(
      height: 260,
      child: ListView(
        shrinkWrap: true,
        clipBehavior: Clip.none,
        scrollDirection: Axis.horizontal,
        children: [
          for (int i = 0; i < 10; i++)
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: _buildProductCard(),
            ),
        ],
      ),
    );
  }

  Widget _buildProductCard({bool hasWidth = true}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: hasWidth ? 150 : null,
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            Expanded(
              child: Image.asset("assets/images/bag.jpg", fit: BoxFit.cover),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "soft_leather_tote".tr,
                    style: AppTexts.tmdm.copyWith(
                      color: AppColors.black.shade400,
                    ),
                  ),
                  Text(
                    "essential_collection".tr,
                    style: AppTexts.tsmr.copyWith(
                      color: AppColors.black.shade400,
                    ),
                  ),
                  Text(
                    "SAR 450",
                    style: AppTexts.tsmm.copyWith(
                      color: AppColors.black.shade400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
