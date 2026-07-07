import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdoom/services/redirect_service.dart';
import 'package:hdoom/utils/app_colors.dart';
import 'package:hdoom/utils/app_constants.dart';
import 'package:hdoom/utils/app_texts.dart';
import 'package:hdoom/views/screens/auth/forgot_password.dart';
import 'package:hdoom/views/screens/auth/verification.dart';
import 'package:hdoom/views/widgets/custom_button.dart';
import 'package:hdoom/views/widgets/custom_text_field.dart';
import 'package:hdoom/views/widgets/logo.dart';

class Authentication extends StatefulWidget {
  const Authentication({super.key});

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  int index = 0;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void onSubmit() async {
    if (index == 0) {
      RedirectService.gotoApp();
    } else {
      Get.to(() => Verification(email: emailController.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(child: Logo(showName: true)),
              const SizedBox(height: 50),
              Text(
                index == 0 ? "welcome_back".tr : "welcome".tr,
                style: AppTexts.dxsm.copyWith(fontSize: 28),
              ),
              const SizedBox(height: 4),
              Text(
                index == 0
                    ? "discover_latest_trends".tr
                    : "join_exclusive_community".tr,
                style: AppTexts.tmdr.copyWith(color: AppColors.black.shade400),
              ),
              const SizedBox(height: 32),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(99),
                  color: Colors.white,
                  border: Border.all(
                    color: AppColors.green.shade100,
                    width: 0.5,
                  ),
                ),
                child: Row(
                  children: [typeButton("log_in".tr, 0), typeButton("sign_up".tr, 1)],
                ),
              ),
              const SizedBox(height: 32),
              Column(
                spacing: 16,
                children: [
                  if (index == 1)
                    CustomTextField(
                      controller: nameController,
                      leading: "assets/icons/name.svg",
                      hintText: "name".tr,
                    ),
                  CustomTextField(
                    controller: emailController,
                    leading: "assets/icons/phone.svg",
                    hintText: "mobile_or_email".tr,
                  ),
                  CustomTextField(
                    controller: passwordController,
                    leading: "assets/icons/lock.svg",
                    hintText: "password".tr,
                    isPassword: true,
                  ),
                  if (index == 0)
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Get.to(
                            () => ForgotPassword(email: emailController.text),
                          );
                        },
                        child: Text(
                          "forgot_password".tr,
                          style: AppTexts.tsmr.copyWith(color: AppColors.green),
                        ),
                      ),
                    ),
                ],
              ),
              Spacer(),
              CustomButton(
                onTap: onSubmit,
                text: index == 0 ? "log_in".tr : "sign_up".tr,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Expanded typeButton(String title, int pos) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            index = pos;
          });
        },
        child: Container(
          height: 43,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(99),
            gradient: index == pos
                ? AppConstants.DEFAULT_GRADIENT_BACKGROUND
                : null,
          ),
          child: Center(
            child: Text(
              title,
              style: AppTexts.tmdm.copyWith(
                color: index == pos ? Colors.white : AppColors.black.shade400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
