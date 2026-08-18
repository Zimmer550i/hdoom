import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdoom/utils/custom_svg.dart';
import 'package:hdoom/views/widgets/custom_networked_image.dart';
import 'package:url_launcher/url_launcher.dart';

class ImageViewer extends StatelessWidget {
  final String url;
  const ImageViewer({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const SizedBox(width: 20),
            GestureDetector(
              onTap: () => Get.back(),
              child: CustomSvg(
                asset: "assets/icons/back.svg",
                color: Colors.white,
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                launchUrl(Uri.parse(url));
              },
              child: Icon(
                Icons.file_download_rounded,
                size: 36,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 20),
          ],
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: InteractiveViewer(
              maxScale: 20,
              minScale: 0.5,
              // boundaryMargin: EdgeInsets.all(MediaQuery.of(context).size.width),
              child: CustomNetworkedImage(url: url, fit: .contain),
            ),
          ),
        ],
      ),
      // body: Column(
      //   children: [
      //     Expanded(
      //       child: Image.asset("assets/images/avatar.png", fit: BoxFit.cover),
      //     ),
      //     const SizedBox(height: 50),
      //     Row(
      //       children: [
      //         const SizedBox(width: 20),
      //         Expanded(
      //           flex: 2,
      //           child: CustomButton(
      //             onTap: () {
      //               // Get.to(() => SavedOutfits());
      //             },
      //             text: "save_this_avatar".tr,
      //             padding: 0,
      //             leading: "assets/icons/save.svg",
      //           ),
      //         ),
      //         const SizedBox(width: 20),
      //         Expanded(
      //           child: CustomButton(
      //             onTap: () {},
      //             text: "share_now".tr,
      //             padding: 0,
      //             isSecondary: true,
      //           ),
      //         ),
      //         const SizedBox(width: 20),
      //       ],
      //     ),
      //     const SizedBox(height: 20),
      //   ],
      // ),
    );
  }
}
