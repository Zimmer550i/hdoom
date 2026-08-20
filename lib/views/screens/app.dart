import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdoom/controllers/wardrobe_controller.dart';
import 'package:hdoom/utils/custom_snackbar.dart';
import 'package:hdoom/views/screens/avatar/avatar.dart';
import 'package:hdoom/views/screens/home/home.dart';
import 'package:hdoom/views/screens/profile/profile.dart';
import 'package:hdoom/views/screens/wardrobe/wardrobe.dart';
import 'package:hdoom/views/widgets/custom_bottom_navbar.dart';

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
