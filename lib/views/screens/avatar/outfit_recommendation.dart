import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdoom/views/screens/avatar/saved_outfits.dart';
import 'package:hdoom/views/widgets/custom_app_bar.dart';
import 'package:hdoom/views/widgets/custom_button.dart';

class OutfitRecommendation extends StatelessWidget {
  const OutfitRecommendation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Outfit Recommendation"),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Image.asset("assets/images/avatar.png", fit: .cover),
            ),
            const SizedBox(height: 50),
            Row(
              children: [
                const SizedBox(width: 20),
                Expanded(
                  flex: 2,
                  child: CustomButton(
                    onTap: () {
                      Get.to(() => SavedOutfits());
                    },
                    text: "Save this Avatar",
                    padding: 0,
                    leading: "assets/icons/save.svg",
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: CustomButton(
                    onTap: () {},
                    text: "Share Now",
                    padding: 0,
                    isSecondary: true,
                  ),
                ),
                const SizedBox(width: 20),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
