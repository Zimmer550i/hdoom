import 'package:get/get.dart';
import 'package:hdoom/views/screens/design_system.dart';

class RedirectService {
  static const Duration splashDuration = Duration(seconds: 2);

  static Future<bool> getData() async {
    return false;
  }

  static Future<void> redirect() async {
    final stopWatch = Stopwatch();
    stopWatch.start();
    await getData();
    final apiTime = stopWatch.elapsed;

    if (splashDuration > apiTime) {
      await Future.delayed(splashDuration - apiTime);
    }

    Get.to(() => DesignSystem());
  }
}
