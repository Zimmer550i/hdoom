import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khzanti/controllers/outfit_controller.dart';
import 'package:khzanti/utils/ai_loading.dart';
import 'package:khzanti/utils/custom_snackbar.dart';
import 'package:khzanti/views/widgets/custom_app_bar.dart';
import 'package:khzanti/views/widgets/custom_button.dart';
import 'package:khzanti/views/widgets/custom_networked_image.dart';

class TryOn extends StatefulWidget {
  const TryOn({super.key});

  @override
  State<TryOn> createState() => _TryOnState();
}

class _TryOnState extends State<TryOn> {
  final tryOn = Get.find<OutfitController>();

  void onSubmit() async {
    final message = await tryOn.saveTryOn();

    if (message == "success") {
      Get.until(((route) => route.settings.name == "/app"));
      customSnackBar("Outfit saved successfully", isError: false);
    } else {
      customSnackBar(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Try On"),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Obx(
            () => Column(
              children: [
                tryOn.currentTryOnJob.value?.status == "processing"
                    ? AiLoading()
                    : ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.width,
                        ),
                        child: CustomNetworkedImage(
                          url: tryOn.currentTryOnJob.value?.resultImage,
                          errorMessage:
                              tryOn.currentTryOnJob.value?.errorMessage,
                        ),
                      ),
                if (tryOn.currentTryOnJob.value?.status != "processing")
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: CustomButton(
                      text: "Save Outfit",
                      onTap: onSubmit,
                      isLoading: tryOn.isTryOnLoading.value,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
