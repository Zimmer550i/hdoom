import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khzanti/controllers/outfit_controller.dart';
import 'package:khzanti/utils/custom_grid_handler.dart';
import 'package:khzanti/utils/custom_snackbar.dart';
import 'package:khzanti/views/screens/wardrobe/outfit_details.dart';
import 'package:khzanti/views/screens/wardrobe/widgets/outfit_card.dart';

// ──────────────────────────────────────────────
// CUSTOMIZABLE VARIABLES — Change these to style
// ──────────────────────────────────────────────

// Grid
const _gridAspectRatio = 0.58;
const _gridSpacing = 12.0;

// Layout
const _horizontalPadding = 20.0;

// ──────────────────────────────────────────────

class OutfitsTab extends StatefulWidget {
  const OutfitsTab({super.key});

  @override
  State<OutfitsTab> createState() => _OutfitsTabState();
}

class _OutfitsTabState extends State<OutfitsTab> {
  final outfit = Get.find<OutfitController>();

  @override
  void initState() {
    super.initState();
    outfit.getSavedOutfits().then((message) {
      if (message != "success") {
        customSnackBar(message);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CustomGridHandler(
        horizontalPadding: _horizontalPadding,
        childAspectRatio: _gridAspectRatio,
        mainAxisSpacing: _gridSpacing,
        crossAxisSpacing: _gridSpacing,
        isLoading: outfit.isSavedLoading.value,
        children: List.generate(
          outfit.savedOutfits.length,
          (index) => OutfitCard(
            outfit: outfit.savedOutfits[index],
            onTap: () =>
                Get.to(() => OutfitDetails(outfit: outfit.savedOutfits[index])),
          ),
        ),
      ),
    );
  }
}
