import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdoom/utils/app_colors.dart';
import 'package:hdoom/utils/app_texts.dart';
import 'package:hdoom/utils/custom_image_picker.dart';

class ImageUploader extends StatelessWidget {
  final File? image;
  final void Function(File?) onChange;
  const ImageUploader({super.key, this.image, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.width / 2,
        maxHeight: MediaQuery.of(context).size.width / 1.5,
      ),
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: Colors.white,
        image: image != null ? DecorationImage(image: FileImage(image!)) : null,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.black.shade200,
          style: BorderStyle.solid,
        ),
      ),
      child: image == null
          ? Column(
              mainAxisSize: .min,
              mainAxisAlignment: .center,
              children: [
                Row(
                  mainAxisSize: .min,
                  spacing: 12,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final picked = await customImagePicker(
                          isCircular: false,
                          isSquared: false,
                          source: .camera,
                        );

                        onChange(picked!);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.gold.shade500,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                    Container(
                      height: 64,
                      width: 2,
                      color: AppColors.black.shade200,
                    ),
                    GestureDetector(
                      onTap: () async {
                        final picked = await customImagePicker(
                          isCircular: false,
                          isSquared: false,
                        );

                        onChange(picked!);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.gold.shade500,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.photo_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text('upload_photo'.tr, style: AppTexts.tlgm),
                const SizedBox(height: 4),
                Text(
                  'upload_from_gallery'.tr,
                  style: AppTexts.tsmr.copyWith(
                    color: AppColors.black.shade300,
                  ),
                ),
              ],
            )
          : SizedBox(),
    );
  }
}
