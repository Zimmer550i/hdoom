import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdoom/controllers/news_controller.dart';
import 'package:hdoom/utils/app_colors.dart';
import 'package:hdoom/utils/app_constants.dart';
import 'package:hdoom/utils/app_texts.dart';
import 'package:hdoom/utils/custom_svg.dart';
import 'package:hdoom/views/screens/home/news.dart';
import 'package:hdoom/views/screens/home/widgets/news_article_tile.dart';
import 'package:hdoom/views/widgets/custom_loading.dart';
import 'package:hdoom/views/widgets/custom_networked_image.dart';

/// Editorial "STYLE NEWS" card with a gradient-overlayed hero image,
/// an exclusive badge, and a list of article previews below.
class StyleNewsCard extends StatefulWidget {
  const StyleNewsCard({super.key});

  @override
  State<StyleNewsCard> createState() => _StyleNewsCardState();
}

class _StyleNewsCardState extends State<StyleNewsCard> {
  final newsController = Get.find<NewsController>();

  @override
  void initState() {
    super.initState();
    if (newsController.news.isEmpty) {
      newsController.getNews();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          if (newsController.isLoading.value) CustomLoading(),
          if (!newsController.isLoading.value) _buildHeroImage(),
          if (!newsController.isLoading.value) _buildArticleList(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text("style_news".tr, style: AppTexts.txlm),
    );
  }

  Widget _buildHeroImage() {
    final news = newsController.news.first;

    return GestureDetector(
      onTap: () {
        Get.to(() => News(news: news));
      },
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        child: Stack(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: CustomNetworkedImage(
                url: news.featuredImage,
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withValues(alpha: 0.02),
                      Color(0xff190700),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 24,
              right: 24,
              bottom: 32,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: AppConstants.DEFAULT_GRADIENT_BACKGROUND,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(8),
                      ),
                    ),
                    child: Text(
                      "exclusive".tr,
                      style: AppTexts.txlm.copyWith(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    news.title,
                    style: AppTexts.dxss.copyWith(color: Colors.white),
                  ),
                  // const SizedBox(height: 8),
                  // Text(
                  //   "remaining_modern_modesty".tr,
                  //   style: AppTexts.dxss.copyWith(color: Colors.white),
                  // ),
                  // const SizedBox(height: 12),
                  // Text(
                  //   "discover_exclusive_collection".tr,
                  //   style: AppTexts.tsmr.copyWith(color: Colors.white),
                  // ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    height: 0.5,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "five_min_read".tr,
                          style: AppTexts.tsmr.copyWith(color: Colors.white),
                        ),
                      ),
                      CustomSvg(
                        asset: "assets/icons/arrow_forward.svg",
                        color: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleList() {
    final news = newsController.news.sublist(1);
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < news.length; i++)
            Column(
              children: [
                NewsArticleTile(news: news[i]),
                if (i != news.length - 1)
                  Container(
                    width: double.infinity,
                    height: 0.5,
                    color: AppColors.green.shade100,
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
