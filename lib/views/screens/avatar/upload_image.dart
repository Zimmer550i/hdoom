import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdoom/utils/app_colors.dart';
import 'package:hdoom/utils/app_texts.dart';
import 'package:hdoom/utils/custom_image_picker.dart';
import 'package:hdoom/utils/custom_svg.dart';
import 'package:hdoom/views/screens/avatar/avatar_creation.dart';
import 'package:hdoom/views/widgets/custom_app_bar.dart';
import 'package:hdoom/views/widgets/custom_button.dart';
import 'package:image_picker/image_picker.dart';

class UploadImage extends StatefulWidget {
  const UploadImage({super.key});

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Upload Image"),
      body: SingleChildScrollView(
        padding: .symmetric(horizontal: 20),
        child: SafeArea(
          child: Column(
            children: [
              Text(
                "Please upload a reference image or a clear photo of yourself so We can easily create your avatar and suggest the best outfit for you.",
                style: AppTexts.tsmr,
              ),
              const SizedBox(height: 32),
              GestureDetector(
                onTap: () async {
                  final temp = await customImagePicker(
                    isCircular: false,
                    isSquared: false,
                  );
                  setState(() {
                    _image = temp;
                  });
                },
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.green.shade200,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: _image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(32),
                          child: Image.file(_image!, fit: .cover),
                        )
                      : Column(
                          mainAxisAlignment: .center,
                          spacing: 8,
                          children: [
                            CustomSvg(asset: "assets/icons/image.svg"),
                            Text("Select file", style: AppTexts.tmdr),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                spacing: 12,
                children: [
                  Expanded(child: Divider(color: Color(0xffeeeeee))),
                  Text("or", style: AppTexts.tlgr),
                  Expanded(child: Divider(color: Color(0xffeeeeee))),
                ],
              ),
              const SizedBox(height: 16),
              CustomButton(
                onTap: () async {
                  final picker = ImagePicker();
                  final picked = await picker.pickImage(
                    source: ImageSource.camera,
                  );
                  if (picked != null) {
                    setState(() {
                      _image = File(picked.path);
                    });
                  }
                },
                text: "Open Camera & Take Photo",
                isSecondary: true,
                leading: "assets/icons/camera.svg",
              ),
              const SizedBox(height: 40),
              CustomButton(
                onTap: () {
                  Get.to(() => AvatarCreation());
                },
                text: "Next",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
