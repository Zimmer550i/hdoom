import 'package:flutter/material.dart';
import 'package:hdoom/utils/app_colors.dart';

class Logo extends StatelessWidget {
  final bool showName;
  const Logo({super.key, this.showName = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 6,
      children: [
        Image.asset("assets/images/logo.png", height: 50),
        if (showName)
          Image.asset(
            "assets/images/name.png",
            fit: BoxFit.cover,
            height: 28,
            width: 90,
          ),
        if (showName)
          Container(width: 112, height: 0.5, color: AppColors.green.shade100),
        if (showName)
          Image.asset(
            "assets/images/name_ar.png",
            fit: BoxFit.cover,
            height: 28,
            width: 90,
          ),
      ],
    );
  }
}
