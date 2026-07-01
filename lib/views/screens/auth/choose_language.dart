import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdoom/utils/app_colors.dart';
import 'package:hdoom/utils/app_texts.dart';
import 'package:hdoom/utils/custom_svg.dart';
import 'package:hdoom/views/screens/auth/authentication.dart';
import 'package:hdoom/views/widgets/logo.dart';

class ChooseLanguage extends StatelessWidget {
  const ChooseLanguage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              Logo(showName: true),
              const SizedBox(height: 50),
              Row(
                children: [
                  Text(
                    "Welcome to HDOOMI /",
                    style: AppTexts.tlgm.copyWith(
                      color: AppColors.black.shade400,
                    ),
                  ),
                  Text(
                    " مرحباً بك في هدومي",
                    textAlign: TextAlign.end,
                    style: AppTexts.tlgm.copyWith(
                      color: AppColors.black.shade400,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Please select your preferred language",
                  style: AppTexts.tmdr.copyWith(
                    color: AppColors.black.shade400,
                  ),
                ),
              ),
              const SizedBox(height: 50),

              GestureDetector(
                onTap: () {
                  Get.to(() => Authentication());
                },
                child: Container(
                  height: 60,
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(33),
                  ),
                  child: Row(
                    spacing: 12,
                    children: [
                      CustomSvg(asset: "assets/icons/english.svg", size: 24),
                      Text(
                        "English",
                        style: AppTexts.tmdm.copyWith(
                          color: AppColors.black.shade400,
                        ),
                      ),
                      Spacer(),
                      CustomSvg(
                        asset: "assets/icons/arrow_forward.svg",
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 60,
                padding: EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(33),
                ),
                child: Row(
                  spacing: 12,
                  children: [
                    CustomSvg(asset: "assets/icons/arabic.svg", size: 24),
                    Text(
                      "مرحبا",
                      textAlign: TextAlign.end,
                      style: AppTexts.tmdm.copyWith(
                        color: AppColors.black.shade400,
                      ),
                    ),
                    Spacer(),
                    CustomSvg(
                      asset: "assets/icons/arrow_forward.svg",
                      size: 24,
                    ),
                  ],
                ),
              ),
              Spacer(),
              Text(
                "Experience luxury tailored for you",
                style: AppTexts.tsmr.copyWith(color: AppColors.green.shade600),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
