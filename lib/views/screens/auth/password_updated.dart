import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdoom/utils/app_colors.dart';
import 'package:hdoom/utils/app_texts.dart';
import 'package:hdoom/utils/custom_svg.dart';
import 'package:hdoom/views/screens/auth/authentication.dart';
import 'package:hdoom/views/widgets/custom_button.dart';

class PasswordUpdated extends StatelessWidget {
  const PasswordUpdated({super.key});

  void onSubmit() async {
    Get.offAll(() => Authentication());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 100),
              Text(
                "Password Updated",
                style: AppTexts.dsmm.copyWith(fontSize: 32),
              ),
              const SizedBox(height: 50),
              CustomSvg(asset: "assets/icons/updated.svg"),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Your password has been successfully reset. You can now log in with your new credentials to access your account.",
                  style: AppTexts.tmdr.copyWith(
                    color: AppColors.black.shade400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Spacer(),
              CustomButton(onTap: onSubmit, text: "Go To Log In"),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
