import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khzanti/controllers/ai_image_controller.dart';
import 'package:khzanti/controllers/outfit_controller.dart';
import 'package:khzanti/controllers/wardrobe_controller.dart';
import 'package:khzanti/utils/custom_snackbar.dart';
import 'package:khzanti/views/screens/avatar/avatar.dart';
import 'package:khzanti/views/screens/home/home.dart';
import 'package:khzanti/views/screens/profile/profile.dart';
import 'package:khzanti/views/screens/wardrobe/wardrobe.dart';
import 'package:khzanti/views/widgets/custom_bottom_navbar.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int index = 0;
  final List<Widget> pages = [
    Home(key: PageStorageKey("home")),
    Wardrobe(key: PageStorageKey("wardrobe")),
    Avatar(key: PageStorageKey("avatar")),
    Profile(isUserProfile: true),
  ];

  @override
  void initState() {
    super.initState();
    Get.find<OutfitController>().todayOutfit.value = null;
    Get.find<AiImageController>().defaultAvatar.value = null;
    Get.find<WardrobeController>().getWardrobeOptions().then((message) {
      if (message != 'success') {
        customSnackBar("Failed to initialize Wardrobe features");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: CustomBottomNavbar(
        index: index,
        onChanged: (val) {
          setState(() {
            index = val;
          });
        },
      ),
    );
  }
}
