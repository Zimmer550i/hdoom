import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hdoom/utils/app_colors.dart';
import 'package:hdoom/utils/app_texts.dart';
import 'package:shimmer/shimmer.dart';

// ──────────────────────────────────────────────
// CUSTOMIZABLE VARIABLES — Change these to style
// ──────────────────────────────────────────────

// Colors
final _errorBackgroundColor = AppColors.black.shade200;
final _errorIconColor = AppColors.black.shade400;
final _errorTextColor = AppColors.black.shade400;
final _shimmerBaseColor = AppColors.green.shade300;
final _shimmerHighlightColor = AppColors.green[25]!;
const _shimmerChildColor = Colors.white;

// Sizing
const _defaultRadius = 10.0;

// Animation
const _shimmerDuration = Duration(milliseconds: 800);

// Typography
final _errorTextStyle = AppTexts.tsmr;

// ──────────────────────────────────────────────

class CustomNetworkedImage extends StatelessWidget {
  final String? url;
  final File? file;
  final String? randomSeed;
  final double? height;
  final double? width;
  final double radius;
  final bool shimmer;
  final BoxFit? fit;
  const CustomNetworkedImage({
    super.key,
    this.url,
    this.randomSeed,
    this.height,
    this.width,
    this.radius = _defaultRadius,
    this.fit = BoxFit.cover,
    this.shimmer = true,
    this.file,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadiusGeometry.circular(radius),
      child: file != null
          ? Image.file(file!, height: height, width: width, fit: fit)
          : url == null
          ? Container(
              height: height,
              width: width,
              decoration: BoxDecoration(color: _errorBackgroundColor),
              child: Center(child: Icon(Icons.error_outline_rounded)),
            )
          : CachedNetworkImage(
              imageUrl: url!,
              height: height,
              width: width,
              fit: fit,
              errorWidget: (context, url, error) {
                return Container(
                  height: height,
                  width: width,
                  color: _errorBackgroundColor,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error, color: _errorIconColor),
                        Expanded(
                          child: Text(
                            error.toString(),
                            textAlign: TextAlign.center,
                            style: _errorTextStyle.copyWith(
                              color: _errorTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              placeholder: (context, url) {
                return Shimmer.fromColors(
                  baseColor: _shimmerBaseColor,
                  highlightColor: _shimmerHighlightColor,
                  period: _shimmerDuration,
                  child: Container(
                    height: height ?? width,
                    width: width ?? height,
                    color: _shimmerChildColor,
                  ),
                );
              },
            ),
    );
  }
}
