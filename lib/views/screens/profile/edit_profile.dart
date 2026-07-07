import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdoom/services/redirect_service.dart';
import 'package:hdoom/utils/app_colors.dart';
import 'package:hdoom/utils/app_texts.dart';
import 'package:hdoom/utils/custom_svg.dart';
import 'package:hdoom/views/widgets/custom_app_bar.dart';
import 'package:hdoom/views/widgets/custom_button.dart';
import 'package:hdoom/views/widgets/custom_drop_down.dart';
import 'package:hdoom/views/widgets/custom_text_field.dart';
import 'package:hdoom/views/widgets/profile_picture.dart';

class EditProfile extends StatefulWidget {
  final bool createAccount;
  const EditProfile({super.key, this.createAccount = false});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? _pickedImage;
  List<String> styles = [
    "formal",
    "casual",
    "bridal",
    "luxury",
    "elegant",
    "trendy",
  ];
  List<String> selectedStyles = [];

  void onSubmit() {
    if (widget.createAccount) {
      RedirectService.gotoApp();
    } else {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (var i in styles) {
        precacheImage(AssetImage("assets/images/style_$i.jpg"), context);
      }
    });

    return Scaffold(
      appBar: CustomAppBar(
        title: widget.createAccount ? "complete_profile".tr : "edit_profile".tr,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              ProfilePicture(
                imageFile: _pickedImage,
                isEditable: true,
                imagePickerCallback: (val) {
                  setState(() {
                    _pickedImage = val;
                  });
                },
              ),
              const SizedBox(height: 12),
              Text("upload_photo".tr, style: AppTexts.tmdm),
              const SizedBox(height: 24),
              Column(
                spacing: 16,
                children: [
                  Row(
                    spacing: 16,
                    children: [
                      Expanded(
                        child: CustomTextField(
                          hintText: "age".tr,
                          textInputType: TextInputType.number,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: CustomDropDown(
                          hintText: "gender".tr,
                          options: ["male".tr, "female".tr],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: CustomTextField(
                          hintText: "height_cm".tr,
                          textInputType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    spacing: 16,
                    children: [
                      Expanded(
                        child: CustomDropDown(
                          hintText: "select_body_type".tr,
                          options: ["slim".tr, "athletic".tr, "stocky".tr, "curvy".tr],
                        ),
                      ),
                      Expanded(child: CustomTextField(hintText: "country".tr)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: Text("your_aesthetic".tr, style: AppTexts.tlgm)),
                  Text("select_up_to_3".tr, style: AppTexts.tsmr),
                ],
              ),
              const SizedBox(height: 16),
              GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: 0.88,
                ),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [for (var i in styles) styleCard(i)],
              ),
              const SizedBox(height: 50),
              CustomButton(onTap: onSubmit, text: "continue_btn".tr),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget styleCard(String name) {
    bool isSelected = selectedStyles.contains(name);
    return GestureDetector(
      onTap: () {
        if (isSelected) {
          setState(() {
            selectedStyles.remove(name);
          });
        } else if (selectedStyles.length < 3) {
          setState(() {
            selectedStyles.add(name);
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(width: 2, color: AppColors.green.shade400)
              : null,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage("assets/images/style_$name.jpg"),
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: [0, .5],
                    colors: [
                      Color.fromRGBO(7, 3, 1, 0.81),
                      Color.fromRGBO(202, 183, 175, 0.02),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                children: [
                  if (isSelected)
                    Align(
                      alignment: Alignment.centerRight,
                      child: CustomSvg(
                        asset: "assets/icons/tick_circle_selected.svg",
                      ),
                    ),
                  Spacer(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      name.substring(0, 1).toUpperCase() + name.substring(1),
                      style: AppTexts.tmds.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
