import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdoom/utils/app_colors.dart';
import 'package:hdoom/utils/app_texts.dart';
import 'package:hdoom/views/screens/auth/password_updated.dart';
import 'package:hdoom/views/widgets/custom_app_bar.dart';
import 'package:hdoom/views/widgets/custom_button.dart';
import 'package:hdoom/controllers/auth_controller.dart';
import 'package:hdoom/utils/custom_snackbar.dart';
import 'package:hdoom/views/widgets/custom_text_field.dart';
import 'package:hdoom/views/widgets/logo.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void onSubmit() async {
    if (newPasswordController.text.isEmpty || confirmPasswordController.text.isEmpty) {
      customSnackBar("Please enter and confirm your new password");
      return;
    }
    if (newPasswordController.text != confirmPasswordController.text) {
      customSnackBar("Passwords do not match");
      return;
    }
    final res = await Get.find<AuthController>().resetPassword(
      newPasswordController.text,
      confirmPasswordController.text,
    );
    if (res == "success") {
      customSnackBar("Password reset successfully!", isError: false);
      Get.offAll(() => PasswordUpdated());
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
                "create_new_password".tr,
                style: AppTexts.dxsm.copyWith(fontSize: 28),
              ),
              const SizedBox(height: 4),
              Text(
                "create_new_password_subtitle".tr,
                style: AppTexts.tmdr.copyWith(color: AppColors.black.shade400),
              ),
              const SizedBox(height: 32),
              CustomTextField(
                controller: newPasswordController,
                leading: "assets/icons/lock.svg",
                hintText: "new_password".tr,
                isPassword: true,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: confirmPasswordController,
                leading: "assets/icons/lock.svg",
                hintText: "re_enter_password".tr,
                isPassword: true,
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
