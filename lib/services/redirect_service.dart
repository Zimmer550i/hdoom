import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdoom/controllers/auth_controller.dart';
import 'package:hdoom/controllers/user_controller.dart';
import 'package:hdoom/services/shared_prefs_service.dart';
import 'package:hdoom/utils/custom_snackbar.dart';
import 'package:hdoom/views/screens/app.dart';
import 'package:hdoom/views/screens/auth/choose_language.dart';
import 'package:hdoom/views/screens/auth/verification.dart';

class RedirectService {
  static const Duration splashDuration = Duration(seconds: 2);

  static Future<bool> getUserData() async {
    final user = Get.find<UserController>();
    final token = await SharedPrefsService.get('token');
    debugPrint("Token Retrived: $token");
    if (token != null) {
      final message = await user.getUserInfo();
      if (message == "success") {
        return true;
      }
    }
    return false;
  }

  static Future<void> redirectFromSplash() async {
    final stopWatch = Stopwatch();
    stopWatch.start();
    final isLoggedIn = await getUserData();
    final apiTime = stopWatch.elapsed;

    if (splashDuration > apiTime) {
      await Future.delayed(splashDuration - apiTime);
    }

    if (isLoggedIn) {
      gotoApp();
    } else {
      Get.to(() => ChooseLanguage());
    }
  }

  static void gotoApp() {
    Get.offAll(() => App(), routeName: "/app");
  }

  static void gotoVerification(String email) async {
    await Get.find<AuthController>().resendOtp(email).then((message) {
      if (message != "success") {
        customSnackBar(message);
      }
    });
    Get.to(() => Verification(email: email));
  }
}
