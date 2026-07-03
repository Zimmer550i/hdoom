import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hdoom/utils/app_colors.dart';
import 'package:hdoom/utils/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hdoom/utils/custom_image_picker.dart';
import 'package:hdoom/utils/custom_svg.dart';

// ──────────────────────────────────────────────
// CUSTOMIZABLE VARIABLES — Change these to style
// ──────────────────────────────────────────────

// Colors
final _progressColor = AppColors.green[400]!;
final _errorBackgroundColor = AppColors.green[100]!;
const _errorIconColor = Colors.blue;
final _placeholderIconColor = AppColors.green[400]!;

// Sizing
const _defaultSize = 100.0;
const _avatarRadius = 100.0;
const _placeholderPaddingScale = 0.17;
const _progressStrokeWidth = 2.0;
const _editIconSize = 24.0;

// Icons
const _placeholderIcon = AppIcons.person;
const _editIcon = AppIcons.edit;

// ──────────────────────────────────────────────

class ProfilePicture extends StatelessWidget {
  final double size;
  final String? image;
  final File? imageFile;
  final bool showLoading;
  final bool isEditable;
  final Function(File)? imagePickerCallback;

  const ProfilePicture({
    super.key,
    this.image,
    this.size = _defaultSize,
    this.showLoading = true,
    this.isEditable = false,
    this.imagePickerCallback,
    this.imageFile,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        if (!isEditable) {
          return;
        }

        File? image = await customImagePicker();

        if (image != null && imagePickerCallback != null) {
          imagePickerCallback!(image);
        }
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(_avatarRadius),
            child: imageFile != null
                ? Image.file(
                    imageFile!,
                    width: size,
                    height: size,
                    fit: BoxFit.cover,
                  )
                : image != null
                ? CachedNetworkImage(
                    imageUrl: image!,
                    progressIndicatorBuilder: (context, url, progress) {
                      return SizedBox(
                        width: size,
                        height: size,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: progress.progress,
                            strokeWidth: _progressStrokeWidth,
                            color: _progressColor,
                          ),
                        ),
                      );
                    },
                    errorWidget: (context, url, error) {
                      return Container(
                        width: size,
                        height: size,
                        color: _errorBackgroundColor,
                        child: Icon(Icons.error, color: _errorIconColor),
                      );
                    },
                    width: size,
                    height: size,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: size,
                    height: size,
                    padding: EdgeInsets.all(size * _placeholderPaddingScale),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        _placeholderIcon,
                        colorFilter: ColorFilter.mode(
                          _placeholderIconColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
          ),
          if (isEditable)
            Positioned(
              bottom: 8,
              right: 0,
              child: CustomSvg(asset: _editIcon, size: _editIconSize),
            ),
        ],
      ),
    );
  }
}
