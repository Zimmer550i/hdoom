import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdoom/utils/app_colors.dart';
import 'package:hdoom/utils/app_texts.dart';
import 'package:hdoom/views/screens/home/news.dart';

/// A compact article preview tile with a title, subtitle, and
/// circular thumbnail image. Used inside the Style News card.
class NewsArticleTile extends StatelessWidget {
  const NewsArticleTile({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(()=> News());
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(),
        child: Row(
          spacing: 12,
          children: [
            Expanded(
              child: Column(
                spacing: 12,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "street_style_title".tr,
                    style: AppTexts.tlgm.copyWith(height: 1),
                  ),
                  Text(
                    "street_style_subtitle".tr,
                    style: AppTexts.tsmr.copyWith(height: 1),
                  ),
                ],
              ),
            ),
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.green.shade300),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: Image.asset(
                  "assets/images/style_casual.jpg",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
