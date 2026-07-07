import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdoom/views/widgets/custom_app_bar.dart';
import 'package:hdoom/views/widgets/custom_button.dart';
import 'package:hdoom/views/widgets/custom_text_field.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final oldPassCtrl = TextEditingController();
  final newPassCtrl = TextEditingController();
  final conPassCtrl = TextEditingController();

  void onSubmit() async {
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "change_password".tr),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          spacing: 20,
          children: [
            const SizedBox(height: 0,),
            // Center(child: Logo(showName: false)),
            CustomTextField(
              leading: "assets/icons/lock.svg",
              hintText: "old_password".tr,
              controller: oldPassCtrl,
              isPassword: true,
            ),
            CustomTextField(
              leading: "assets/icons/lock.svg",
              hintText: "new_password".tr,
              controller: newPassCtrl,
              isPassword: true,
            ),
            CustomTextField(
              leading: "assets/icons/lock.svg",
              hintText: "confirm_password".tr,
              controller: conPassCtrl,
              isPassword: true,
            ),
            const SizedBox(height: 20),
            CustomButton(onTap: onSubmit, text: "save_password".tr),
          ],
        ),
      ),
    );
  }
}
