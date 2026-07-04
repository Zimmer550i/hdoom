import 'package:flutter/material.dart';
import 'package:hdoom/utils/app_colors.dart';
import 'package:hdoom/utils/app_texts.dart';
import 'package:hdoom/utils/custom_svg.dart';
import 'package:hdoom/views/screens/home/widgets/todays_look_card.dart';
import 'package:hdoom/views/widgets/custom_app_bar.dart';
import 'package:hdoom/views/widgets/custom_button.dart';

class WhyThisLook extends StatelessWidget {
  const WhyThisLook({super.key});

  void onSubmit() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Why this look"),
      body: SingleChildScrollView(
        padding: .symmetric(horizontal: 20),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              TodaysLookCard(hasActions: false),
              const SizedBox(height: 20),
              Text("Why we chose this for you?", style: AppTexts.txlm),
              const SizedBox(height: 16),
              Container(
                padding: .symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: .circular(20),
                ),
                child: Column(
                  children: [
                    for (int i = 0; i < 4; i++)
                      reasons(
                        i + 1,
                        "Style Matched",
                        "Neutral colors with soft textures create an elegant and timeless look everyday wear.",
                      ),

                    const SizedBox(height: 20),
                    Container(
                      padding: .symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: .circular(20),
                        color: AppColors.green.shade50,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: .center,
                            children: [
                              CustomSvg(asset: "assets/icons/note.svg"),
                              Text("Style Note", style: AppTexts.tlgm),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "The outfit balanced and elegance, allowing you to feel confident while staying true to your personal guide",
                            style: AppTexts.tsmr,
                            textAlign: .center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              CustomButton(
                onTap: onSubmit,
                text: "Save This Look",
                leading: "assets/icons/save.svg",
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget reasons(int num, String title, String details) {
    return Container(
      padding: .all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.green.shade50)),
      ),
      child: Column(
        children: [
          Row(
            spacing: 8,
            children: [
              Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  shape: .circle,
                  color: AppColors.green.shade50,
                ),
                child: Center(
                  child: Text(
                    num.toString(),
                    style: AppTexts.tmdr.copyWith(color: AppColors.green),
                  ),
                ),
              ),
              Expanded(child: Text(title, style: AppTexts.tmdm)),
            ],
          ),
          const SizedBox(height: 8),
          Text(details, style: AppTexts.tsmr),
        ],
      ),
    );
  }
}
