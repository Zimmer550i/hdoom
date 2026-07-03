import 'package:flutter/material.dart';
import 'package:hdoom/utils/app_colors.dart';
import 'package:hdoom/utils/app_constants.dart';
import 'package:hdoom/utils/app_texts.dart';
import 'package:hdoom/utils/custom_svg.dart';
import 'package:hdoom/views/screens/home/widgets/news_article_tile.dart';

/// Editorial "STYLE NEWS" card with a gradient-overlayed hero image,
/// an exclusive badge, and a list of article previews below.
class StyleNewsCard extends StatelessWidget {
  const StyleNewsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        const SizedBox(height: 16),
        _buildHeroImage(),
        _buildArticleList(),
      ],
    );
  }

  Widget _buildHeader() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text("STYLE NEWS", style: AppTexts.txlm),
    );
  }

  Widget _buildHeroImage() {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Image.asset(
              "assets/images/avatar.png",
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
                  padding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: AppConstants.DEFAULT_GRADIENT_BACKGROUND,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(8),
                    ),
                  ),
                  child: Text(
                    "EXCLUSIVE",
                    style: AppTexts.txlm.copyWith(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "The Ramadan Edit:",
                  style: AppTexts.dxss.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  "Remaining Modern Modesty",
                  style: AppTexts.dxss.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 12),
                Text(
                  "Discover the exclusive collection by Saudi Designers blending traditional silhouette",
                  style: AppTexts.tsmr.copyWith(color: Colors.white),
                ),
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
                        "5 MIN READ",
                        style: AppTexts.tsmr.copyWith(
                          color: Colors.white,
                        ),
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
    );
  }

  Widget _buildArticleList() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NewsArticleTile(),
          Container(
            width: double.infinity,
            height: 0.5,
            color: AppColors.green.shade100,
          ),
          NewsArticleTile(),
        ],
      ),
    );
  }
}
