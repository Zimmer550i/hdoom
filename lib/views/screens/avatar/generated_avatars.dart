import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdoom/controllers/ai_image_controller.dart';
import 'package:hdoom/utils/app_colors.dart';
import 'package:hdoom/utils/app_texts.dart';
import 'package:hdoom/utils/custom_list_handler.dart';
import 'package:hdoom/utils/custom_snackbar.dart';
import 'package:hdoom/utils/custom_svg.dart';
import 'package:hdoom/views/screens/avatar/image_viewer.dart';
import 'package:hdoom/views/widgets/custom_app_bar.dart';
import 'package:hdoom/views/widgets/profile_picture.dart';

class GeneratedAvatars extends StatefulWidget {
  const GeneratedAvatars({super.key});

  @override
  State<GeneratedAvatars> createState() => _GeneratedAvatarsState();
}

class _GeneratedAvatarsState extends State<GeneratedAvatars> {
  final avatar = Get.find<AiImageController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      avatar.getMyAvatars();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "My Avatars"),
      body: Obx(() {
        return CustomListHandler(
          spacing: 12,
          isLoading: avatar.isLoading.value,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: Row(
                children: [
                  // Expanded(
                  //   child: Text(
                  //     Formatter.dateFormatterLong(DateTime.now()),
                  //     style: AppTexts.tmdm.copyWith(
                  //       color: AppColors.black.shade400,
                  //     ),
                  //   ),
                  // ),
                  Text(
                    "items_count".trParams({
                      "count": avatar.avatars.length.toString(),
                    }),
                    style: AppTexts.tmdr.copyWith(
                      color: AppColors.black.shade400,
                    ),
                  ),
                ],
              ),
            ),
            for (var i in avatar.avatars)
              GestureDetector(
                onTap: () {
                  if (i.status == "done") {
                    Get.to(
                      () => ImageViewer(url: i.resultImage ?? i.sourcePhoto!),
                    );
                  } else if (i.status == "processing") {
                    customSnackBar("Avatar is still processing");
                  } else {
                    customSnackBar("Avatar was not generated");
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.green.shade100,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    spacing: 12,
                    children: [
                      ProfilePicture(
                        image: i.status == "done"
                            ? i.resultImage
                            : i.sourcePhoto,
                        size: 50,
                      ),
                      Expanded(child: getStatus(i.status)),
                      CustomSvg(asset: "assets/icons/arrow_right_circled.svg"),
                    ],
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }

  Widget getStatus(String status) {
    switch (status) {
      case "done":
        return Text(
          "Completed",
          style: AppTexts.tsms.copyWith(color: AppColors.green),
        );
      case "processing":
        return Text("Processing...", style: AppTexts.tsmm);
      case "failed":
        return Text(
          "Failed!",
          style: AppTexts.tsmm.copyWith(color: AppColors.red),
        );

      default:
        return Text(status, style: AppTexts.tsmr);
    }
  }
}
