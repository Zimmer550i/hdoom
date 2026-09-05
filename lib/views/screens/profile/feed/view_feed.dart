import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdoom/controllers/feed_controller.dart';
import 'package:hdoom/models/feed_model.dart';
import 'package:hdoom/utils/app_colors.dart';
import 'package:hdoom/utils/app_texts.dart';
import 'package:hdoom/utils/custom_snackbar.dart';
import 'package:hdoom/views/widgets/custom_app_bar.dart';
import 'package:hdoom/views/widgets/custom_button.dart';
import 'package:hdoom/views/widgets/custom_networked_image.dart';
import 'package:hdoom/views/widgets/overlay_confirmation.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ViewFeed extends StatefulWidget {
  final FeedModel feed;
  final bool canRate;
  const ViewFeed({super.key, required this.feed, this.canRate = true});

  @override
  State<ViewFeed> createState() => _ViewOutfitState();
}

class _ViewOutfitState extends State<ViewFeed> {
  final PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.feed.caption),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.width,
                child: PageView.builder(
                  controller: controller,
                  scrollDirection: .horizontal,
                  itemCount: widget.feed.images.length,
                  itemBuilder: (context, index) {
                    return CustomNetworkedImage(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width,
                      url: widget.feed.images[index].image,
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              SmoothPageIndicator(
                controller: controller,
                effect: WormEffect(activeDotColor: AppColors.gold),
                count: widget.feed.images.length,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  spacing: 8,
                  children: [
                    Row(
                      children: [
                        Text("overall_rating".tr, style: AppTexts.tlgm),
                        Spacer(),
                        Text(
                          "${widget.feed.totalRatings}/10",
                          style: AppTexts.tlgm,
                        ),
                        // if (widget.feed.totalRatings == null)
                        //   Text("Not rated yet", style: AppTexts.tsmr),
                      ],
                    ),
                    const SizedBox(),
                    ratingWidget(
                      "color_harmony",
                      widget.feed.avgColorHarmony?.toDouble() ?? 0,
                    ),
                    ratingWidget(
                      "trendy",
                      widget.feed.avgTrendy?.toDouble() ?? 0,
                    ),
                    ratingWidget(
                      "overall_matching",
                      widget.feed.avgOverallMatching?.toDouble() ?? 0,
                    ),
                    ratingWidget(
                      "accessories",
                      widget.feed.avgAccessories?.toDouble() ?? 0,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              if (widget.canRate)
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: CustomButton(
                    // onTap: () => Get.to(() => RateOutfit(feed: widget.feed)),
                    text: "rate_now".tr,
                    isSecondary: true,
                  ),
                ),
              if (!widget.canRate)
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: CustomButton(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => OverlayConfirmation(
                          title: "Are you sure your want to delete this post?",
                          buttonTextLeft: "Confirm",
                          buttonCallBackLeft: () {
                            Get.back();
                            Get.back();
                            Get.find<FeedController>()
                                .deletePost(widget.feed.id)
                                .then((message) {
                                  if (message == "success") {
                                    customSnackBar(
                                      "Post has been deleted",
                                      isError: false,
                                    );
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
                    isSecondary: true,
                    text: "Remove this post",
                  ),
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Container ratingWidget(String name, double rating) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: .circular(20),
        border: Border.all(width: 0.5, color: AppColors.black.shade50),
      ),
      child: Row(
        children: [
          Text(name.tr, style: AppTexts.tsmr),
          Spacer(),
          Text("${rating.toInt()}/10", style: AppTexts.tsmr),
        ],
      ),
    );
  }
}
