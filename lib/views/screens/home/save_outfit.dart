import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdoom/utils/app_texts.dart';
import 'package:hdoom/views/screens/home/widgets/custom_calender.dart';
import 'package:hdoom/views/widgets/custom_app_bar.dart';
import 'package:hdoom/views/widgets/custom_button.dart';

class SaveOutfit extends StatelessWidget {
  const SaveOutfit({super.key});

  void onSubmit() async {}

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
                  child: Image.asset(
                    "assets/images/avatar.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text("select_date".tr, style: AppTexts.txlm),
              const SizedBox(height: 16),
              CustomCalendar(),
              const SizedBox(height: 50),
              CustomButton(onTap: onSubmit, text: "save_now".tr),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
