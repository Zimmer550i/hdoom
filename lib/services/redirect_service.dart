import 'package:get/get.dart';
import 'package:hdoom/views/screens/app.dart';
import 'package:hdoom/views/screens/auth/choose_language.dart';

class RedirectService {
  static const Duration splashDuration = Duration(seconds: 2);

  static Future<bool> getUserData() async {
    return false;
  }

  static Future<void> redirectFromSplash() async {
    final stopWatch = Stopwatch();
    stopWatch.start();
    await getUserData();
    final apiTime = stopWatch.elapsed;

    if (splashDuration > apiTime) {
      await Future.delayed(splashDuration - apiTime);
    }

    Get.to(() => ChooseLanguage());
  }

  static void gotoApp() {
    Get.offAll(() => App(), routeName: "/app");
  }
}
