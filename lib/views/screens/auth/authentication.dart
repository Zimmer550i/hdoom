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
            crossAxisAlignment: .start,
            children: [
              const SizedBox(height: 20),
              Center(child: Logo(showName: true)),
              const SizedBox(height: 50),
              Text(
                index == 0 ? "Welcome Back!" : "Welcome!",
                style: AppTexts.dxsm.copyWith(fontSize: 28),
              ),
              const SizedBox(height: 4),
              Text(
                index == 0
                    ? "Discover the latest trends"
                    : "Join the exclusive fashion community",
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
                  children: [typeButton("Log In", 0), typeButton("Sign Up", 1)],
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
                      hintText: "Name",
                    ),
                  CustomTextField(
                    controller: emailController,
                    leading: "assets/icons/phone.svg",
                    hintText: "Mobile or Email",
                  ),
                  CustomTextField(
                    controller: passwordController,
                    leading: "assets/icons/lock.svg",
                    hintText: "Password",
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
                          "Forgot Password?",
                          style: AppTexts.tsmr.copyWith(color: AppColors.green),
                        ),
                      ),
                    ),
                ],
              ),
              Spacer(),
              CustomButton(
                onTap: onSubmit,
                text: index == 0 ? "Log In" : "Sign Up",
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
