import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdoom/utils/app_colors.dart';
import 'package:hdoom/utils/app_texts.dart';
import 'package:hdoom/views/screens/auth/verification.dart';
import 'package:hdoom/views/widgets/custom_app_bar.dart';
import 'package:hdoom/views/widgets/custom_button.dart';
import 'package:hdoom/controllers/auth_controller.dart';
import 'package:hdoom/utils/custom_snackbar.dart';
import 'package:hdoom/views/widgets/custom_text_field.dart';
import 'package:hdoom/views/widgets/logo.dart';

class ForgotPassword extends StatefulWidget {
  final String? email;
  const ForgotPassword({super.key, this.email});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    emailController.text = widget.email ?? "";
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void onSubmit() async {
    if (emailController.text.trim().isEmpty) {
      customSnackBar("Please enter your email address");
      return;
    }
    final res = await Get.find<AuthController>().forgotPassword(
      emailController.text.trim(),
    );
    if (res == "success") {
      customSnackBar("Verification code sent to your email!", isError: false);
      Get.to(
        () => Verification(
          email: emailController.text.trim(),
          isResettingPassword: true,
        ),
      );
    } else {
      customSnackBar(res);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: ""),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(child: Logo()),
              const SizedBox(height: 40),
              Text(
                "forgot_password_title".tr,
                style: AppTexts.dxsm.copyWith(fontSize: 28),
              ),
              const SizedBox(height: 4),
              Text(
                "forgot_password_subtitle".tr,
                style: AppTexts.tmdr.copyWith(color: AppColors.black.shade400),
              ),
              const SizedBox(height: 32),
              CustomTextField(
                controller: emailController,
                leading: "assets/icons/phone.svg",
                hintText: "mobile_or_email".tr,
              ),
              Spacer(),
              Obx(
                () => CustomButton(
                  isLoading: Get.find<AuthController>().isLoading.value,
                  onTap: onSubmit,
                  text: "send_code".tr,
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
