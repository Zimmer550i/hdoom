import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdoom/controllers/news_controller.dart';
import 'package:hdoom/models/news_model.dart';
import 'package:hdoom/utils/app_colors.dart';
import 'package:hdoom/utils/app_constants.dart';
import 'package:hdoom/utils/app_texts.dart';
import 'package:hdoom/utils/custom_snackbar.dart';
import 'package:hdoom/views/widgets/custom_app_bar.dart';
import 'package:hdoom/views/widgets/custom_loading.dart';
import 'package:hdoom/views/widgets/custom_networked_image.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:url_launcher/url_launcher.dart';

class News extends StatefulWidget {
  final NewsModel news;
  const News({super.key, required this.news});

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  final newsController = Get.find<NewsController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final news = newsController.news.firstWhere(
        (val) => val.slug == widget.news.slug,
      );
      if (news.content == null) {
        newsController.getNewsBySlug(widget.news.slug);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "style_news".tr),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Obx(() {
          final news = newsController.news.firstWhere(
            (val) => val.slug == widget.news.slug,
          );
          if (newsController.isLoading.value) {
            return Center(child: CustomLoading());
          }
          return SafeArea(
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              child: Container(
                decoration: BoxDecoration(color: AppColors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: CustomNetworkedImage(
                        url: news.featuredImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              gradient:
                                  AppConstants.DEFAULT_GRADIENT_BACKGROUND,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(8),
                              ),
                            ),
                            child: Text(
                              "exclusive".tr,
                              style: AppTexts.txlm.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(news.title, style: AppTexts.dxss),
                          const SizedBox(height: 12),
                          Html(
                            data:
                                cleanHtml(news.content) ??
                                "<p style=\"color: red; text-align: center;\">Error Fetching Content</p>",
                            style: {
                              "img": Style(
                                width: Width(MediaQuery.of(context).size.width/1.7),
                                height: Height(MediaQuery.of(context).size.width/1.7)
                              ),
                              "p": Style(
                                fontSize: FontSize(16),
                                lineHeight: LineHeight(1.5),
                                color: AppColors.black.shade400,
                              ),
                              "strong": Style(
                                fontWeight: FontWeight.bold,
                                fontSize: FontSize(16),
                                color: AppColors.black.shade400,
                              ),
                              "em": Style(
                                fontStyle: FontStyle.italic,
                                color: AppColors.black.shade400,
                              ),
                              "li": Style(
                                fontSize: FontSize(16),
                                color: AppColors.black.shade400,
                              ),
                              "ul": Style(
                                padding: HtmlPaddings(left: HtmlPadding(20)),
                              ),
                              "ol": Style(
                                padding: HtmlPaddings(left: HtmlPadding(20)),
                              ),
                              "a": Style(
                                color: Colors.blueAccent,
                                textDecoration: TextDecoration.underline,
                              ),
                            },
                            onLinkTap: (link, attributes, element) async {
                              var url = Uri.parse(link ?? "");

                              if (await canLaunchUrl(url)) {
                                launchUrl(url);
                              } else {
                                customSnackBar("Url cannot be launched");
                              }
                            },
                          ),
                          // Text(
                          //   news.content ?? "Error loading news",
                          //   style: AppTexts.tsmr.copyWith(
                          //     color: AppColors.black.shade400,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  /// Cleans HTML from React Quill and other sources
  String? cleanHtml(String? rawHtml) {
    if (rawHtml == null || rawHtml.trim().isEmpty) return null;

    final unescape = HtmlUnescape();

    // Remove leading/trailing whitespace and fix smart quotes
    String cleaned = rawHtml
        .replaceAll('“', '"')
        .replaceAll('”', '"')
        .replaceAll('’', "'")
        .replaceAll('\u2028', '') // line separator
        .replaceAll('\u00A0', ' ') // non-breaking space
        .replaceAll('\r', '');

    // Remove any leading closing tags that break flutter_html
    cleaned = cleaned.replaceAll(RegExp(r'^<\/p>|^<\/div>'), '');

    // Remove scripts for safety
    cleaned = cleaned.replaceAll(
      RegExp(r'<script[^>]*>.*?<\/script>', dotAll: true),
      '',
    );

    return unescape.convert(cleaned.trim());
  }
}
