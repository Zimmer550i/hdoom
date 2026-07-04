import 'package:flutter/material.dart';
import 'package:hdoom/utils/app_colors.dart';
import 'package:hdoom/utils/app_constants.dart';
import 'package:hdoom/utils/app_texts.dart';
import 'package:hdoom/views/widgets/custom_app_bar.dart';

class News extends StatelessWidget {
  const News({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Style News"),
      body: SingleChildScrollView(
        padding: .symmetric(horizontal: 20),
        child: SafeArea(
          child: ClipRRect(
            borderRadius: .all(Radius.circular(12)),
            child: Container(
              decoration: BoxDecoration(color: AppColors.white),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: Image.asset(
                      "assets/images/avatar.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            gradient: AppConstants.DEFAULT_GRADIENT_BACKGROUND,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(8),
                            ),
                          ),
                          child: Text(
                            "EXCLUSIVE",
                            style: AppTexts.txlm.copyWith(color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text("The Ramadan Edit:", style: AppTexts.dxss),
                        const SizedBox(height: 12),
                        for (int i = 0; i < 10; i++)
                          Text(
                            "Ramadan is a season of reflection, connection, and timeless elegance. As the holy month approaches, fashion takes on a new meaning—one that balances contemporary style with the values of modesty, grace, and cultural heritage.\n",
                            style: AppTexts.tsmr.copyWith(
                              color: AppColors.black.shade400,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
