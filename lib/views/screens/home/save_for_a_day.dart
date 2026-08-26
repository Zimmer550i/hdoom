import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdoom/controllers/outfit_controller.dart';
import 'package:hdoom/models/outfit_job_model.dart';
import 'package:hdoom/utils/app_texts.dart';
import 'package:hdoom/utils/custom_snackbar.dart';
import 'package:hdoom/views/screens/home/widgets/custom_calender.dart';
import 'package:hdoom/views/widgets/custom_app_bar.dart';
import 'package:hdoom/views/widgets/custom_button.dart';
import 'package:hdoom/views/widgets/custom_networked_image.dart';

class SaveForADay extends StatefulWidget {
  final OutfitJobModel outfit;
  const SaveForADay({super.key, required this.outfit});

  @override
  State<SaveForADay> createState() => _SaveOutfitState();
}

class _SaveOutfitState extends State<SaveForADay> {
  final outfitCtrl = Get.find<OutfitController>();

  void onSubmit() async {
    final message = await outfitCtrl.setOutfitsOfTheDay(widget.outfit.id);

    if (message == "success") {
      if (mounted) {
        Get.back();
      }
      customSnackBar("Outfit saved for the day.", isError: false);
      outfitCtrl.getOutfitsOfTheDay();
    } else {
      customSnackBar(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "save_outfit".tr),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: AspectRatio(
                  aspectRatio: 4 / 5,
                  child: CustomNetworkedImage(url: widget.outfit.resultImage),
                ),
              ),
              const SizedBox(height: 12),
              Text("select_date".tr, style: AppTexts.txlm),
              const SizedBox(height: 16),
              Obx(
                () => CustomCalendar(
                  selectedDate: outfitCtrl.outfitsOfTheDayDate.value,
                  markedDates: outfitCtrl.outfitsOfTheDay
                      .map((val) => val.generatedDate)
                      .toList(),
                  onDateSelected: (date) {
                    outfitCtrl.outfitsOfTheDayDate.value = date;
                  },
                  onMonthChanged: (date) {
                    outfitCtrl.outfitsOfTheDayDate.value = date;
                  },
                  isLoading: outfitCtrl.isOutfitOfTheDayLoading.value,
                ),
              ),
              const SizedBox(height: 50),
              Obx(
                () => CustomButton(
                  onTap: onSubmit,
                  isLoading: outfitCtrl.isSavedLoading.value,
                  text: "save_now".tr,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
