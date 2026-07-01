import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hdoom/utils/app_colors.dart';

Future<File?> customImagePicker({
  bool isCircular = true,
  bool isSquared = true,
}) async {
  final picker = ImagePicker();
  final cropper = ImageCropper();

  final XFile? pickedImage = await picker.pickImage(
    source: ImageSource.gallery,
  );

  if (pickedImage != null) {
    final CroppedFile? croppedImage = await cropper.cropImage(
      sourcePath: pickedImage.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop your image',
          toolbarColor: AppColors.green,
          toolbarWidgetColor: Colors.blue[50],
          backgroundColor: AppColors.green,
          statusBarLight: false,
          cropStyle: isCircular ? CropStyle.circle : CropStyle.rectangle,
          hideBottomControls: isSquared,
          initAspectRatio: CropAspectRatioPreset.square,
        ),
        IOSUiSettings(
          cropStyle: isCircular ? CropStyle.circle : CropStyle.rectangle,
          showCancelConfirmationDialog: true,
        ),
      ],
    );

    if (croppedImage != null) {
      return File(croppedImage.path);
    }
  }

  return null;
}
