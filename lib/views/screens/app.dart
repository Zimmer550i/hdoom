import 'package:flutter/material.dart';
import 'package:hdoom/views/screens/home/home.dart';
import 'package:hdoom/views/screens/profile/profile.dart';
import 'package:hdoom/views/widgets/custom_bottom_navbar.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int index = 0;
  List<Widget> pages = [
    Home(),
    FlutterLogo(size: 200),
    FlutterLogo(size: 200),
    Profile(isUserProfile: true),
  ];

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
