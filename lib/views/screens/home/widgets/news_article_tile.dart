import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khzanti/models/news_model.dart';
import 'package:khzanti/utils/app_colors.dart';
import 'package:khzanti/utils/app_texts.dart';
import 'package:khzanti/views/screens/home/news.dart';
import 'package:khzanti/views/widgets/custom_networked_image.dart';

/// A compact article preview tile with a title, subtitle, and
/// circular thumbnail image. Used inside the Style News card.
class NewsArticleTile extends StatelessWidget {
  final NewsModel news;
  const NewsArticleTile({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => News(news: news));
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
                  Text(news.title, style: AppTexts.tlgm.copyWith(height: 1)),
                  // Text(
                  //   "street_style_subtitle".tr,
                  //   style: AppTexts.tsmr.copyWith(height: 1),
                  // ),
                ],
              ),
            ),
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.gold.shade300),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: CustomNetworkedImage(
                  url: news.featuredImage,
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
