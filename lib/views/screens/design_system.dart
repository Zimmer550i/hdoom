import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdoom/views/screens/splash.dart';
import 'package:hdoom/views/widgets/custom_app_bar.dart';
import 'package:hdoom/views/widgets/custom_bottom_navbar.dart';
import 'package:hdoom/views/widgets/custom_button.dart';
import 'package:hdoom/views/widgets/custom_text_field.dart';
import 'package:hdoom/views/widgets/profile_picture.dart';

class DesignSystem extends StatefulWidget {
  const DesignSystem({super.key});

  @override
  State<DesignSystem> createState() => _DesignSystemState();
}

class _DesignSystemState extends State<DesignSystem> {
  int index = 0;
  File? _assetImgae;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Design System"),
      bottomNavigationBar: CustomBottomNavbar(
        index: index,
        onChanged: (val) {
          setState(() {
            index = val;
          });
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          spacing: 16,
          children: [
            ProfilePicture(
              // image: "https://picsum.photos/500/500",
              imageFile: _assetImgae,
              isEditable: true,
              imagePickerCallback: (val) {
                setState(() {
                  _assetImgae = val;
                });
              },
            ),
            CustomTextField(
              leading: "assets/icons/phone.svg",
              hintText: "Mobile or Email",
            ),
            CustomTextField(
              leading: "assets/icons/lock.svg",
              hintText: "Password",
              isPassword: true,
            ),
            CustomButton(
              onTap: () {
                Get.to(() => Splash());
              },
              text: "Log In",
            ),
          ],
        ),
      ),
    );
  }
}
