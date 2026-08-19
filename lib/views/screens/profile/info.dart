import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:hdoom/controllers/user_controller.dart';
import 'package:hdoom/utils/app_colors.dart';
import 'package:hdoom/utils/custom_snackbar.dart';
import 'package:hdoom/views/widgets/custom_app_bar.dart';
import 'package:hdoom/views/widgets/custom_loading.dart';
import 'package:hdoom/views/widgets/logo.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:url_launcher/url_launcher.dart';

class Info extends StatelessWidget {
  final String title;
  const Info({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.find<UserController>().aboutUs.value == null ||
          Get.find<UserController>().privacyPolicy.value == null) {
        Get.find<UserController>().getAppInfo().then((message) {
          if (message != "success") {
            customSnackBar(message);
          }
        });
      }
    });

    return Scaffold(
      appBar: CustomAppBar(title: title),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Obx(
          () => Get.find<UserController>().isAppInfoLoading.value
              ? CustomLoading()
              : Column(
                  children: [
                    Center(child: Logo(showName: true)),
                    const SizedBox(height: 20),
                    SafeArea(
                      child: Html(
                        data:
                            cleanHtml(getData()) ??
                            "<p style=\"color: red; text-align: center;\">Error Fetching Content</p>",
                        style: {
                          "img": Style(
                            width: Width(MediaQuery.of(context).size.width / 1.7),
                            height: Height(
                              MediaQuery.of(context).size.width / 1.7,
                            ),
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
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  String? getData() {
    final controller = Get.find<UserController>();
    if (title.toLowerCase().contains("about")) {
      return controller.aboutUs.value;
    } else {
      return controller.privacyPolicy.value;
    }
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
