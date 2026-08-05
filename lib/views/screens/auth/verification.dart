import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdoom/utils/app_colors.dart';
import 'package:hdoom/utils/app_texts.dart';
import 'package:hdoom/views/screens/auth/reset_password.dart';
import 'package:hdoom/views/screens/profile/edit_profile.dart';
import 'package:hdoom/views/widgets/custom_app_bar.dart';
import 'package:hdoom/views/widgets/custom_button.dart';
import 'package:hdoom/controllers/auth_controller.dart';
import 'package:hdoom/utils/custom_snackbar.dart';
import 'package:hdoom/views/widgets/logo.dart';
import 'package:pinput/pinput.dart';

class Verification extends StatefulWidget {
  final String email;
  final bool isResettingPassword;
  const Verification({
    super.key,
    required this.email,
    this.isResettingPassword = false,
  });

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  bool canResend = false;
  int timeoutInSec = 5;
  int seconds = 5;
  Timer? _timer;
  final pinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void onSubmit() async {
    if (pinController.text.trim().length < 6) {
      customSnackBar("Please enter the 6-digit verification code");
      return;
    }
    final authController = Get.find<AuthController>();
    if (widget.isResettingPassword) {
      final res = await authController.verifyResetOtp(
        widget.email,
        pinController.text.trim(),
      );
      if (res == "success") {
        Get.to(() => ResetPassword());
      } else {
        customSnackBar(res);
      }
    } else {
      final res = await authController.verifyEmail(
        widget.email,
        pinController.text.trim(),
      );
      if (res == "success") {
        customSnackBar("Email verified successfully!", isError: false);
        Get.to(() => EditProfile(createAccount: true));
      } else {
        customSnackBar(res);
      }
    }
  }

  void resendCode() async {
    if (canResend) {
      final authController = Get.find<AuthController>();
      final res = await authController.resendOtp(
        widget.email,
        purpose: widget.isResettingPassword ? 'password_reset' : 'email_verification',
      );
      if (res == "success") {
        customSnackBar("Verification code resent successfully!", isError: false);
        startTimer();
      } else {
        customSnackBar(res);
      }
    }
  }

  @override
  void dispose() {
    pinController.dispose();
    if (_timer != null) {
      _timer!.cancel();
    }
    super.dispose();
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
                "verification_code".tr,
                style: AppTexts.dxsm.copyWith(fontSize: 28),
              ),
              const SizedBox(height: 4),
              Text(
                "verification_code_subtitle".trParams({"email": widget.email}),
                style: AppTexts.tmdr.copyWith(color: AppColors.black.shade400),
              ),
              const SizedBox(height: 32),
              Pinput(
                controller: pinController,
                length: 6,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                cursor: Container(height: 20, width: 2, color: AppColors.green),
                defaultPinTheme: PinTheme(
                  height: 50,
                  width: 50,
                  textStyle: AppTexts.tmds.copyWith(color: AppColors.green),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(
                      width: 0.5,
                      color: AppColors.black.shade100,
                    ),
                  ),
                ),
                focusedPinTheme: PinTheme(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(width: 0.5, color: AppColors.green),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              if (canResend)
                Center(
                  child: GestureDetector(
                    onTap: resendCode,
                    child: Text(
                      "resend_code".tr,
                      style: AppTexts.tsmm.copyWith(color: AppColors.green),
                    ),
                  ),
                ),
              if (!canResend)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "resend_code_in".tr,
                      style: AppTexts.tsmr.copyWith(
                        color: AppColors.black.shade400,
                      ),
                    ),
                    Text(
                      "00:${seconds.toString().padLeft(2, "0")}",
                      style: AppTexts.tsms.copyWith(color: AppColors.green),
                    ),
                  ],
                ),
              Spacer(),
              Obx(
                () => CustomButton(
                  isLoading: Get.find<AuthController>().isLoading.value,
                  onTap: onSubmit,
                  text: "verify_and_continue".tr,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void startTimer() {
    setState(() {
      canResend = false;
      seconds = timeoutInSec;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (val) {
      if (seconds == 0) {
        setState(() {
          canResend = true;
        });
        val.cancel();
      } else {
        setState(() {
          seconds = seconds - 1;
        });
      }
    });
  }
}
