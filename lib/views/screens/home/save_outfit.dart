import 'package:flutter/material.dart';
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
      appBar: CustomAppBar(title: "Save Outfit"),
      body: SingleChildScrollView(
        padding: .symmetric(horizontal: 20),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: .start,
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
              Text("Select Date", style: AppTexts.txlm),
              const SizedBox(height: 16),
              CustomCalendar(),
              const SizedBox(height: 50),
              CustomButton(onTap: onSubmit, text: "Save Now"),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
