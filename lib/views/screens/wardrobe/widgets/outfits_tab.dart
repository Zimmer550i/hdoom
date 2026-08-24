import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdoom/controllers/outfit_controller.dart';
import 'package:hdoom/utils/custom_grid_handler.dart';
import 'package:hdoom/utils/custom_snackbar.dart';
import 'package:hdoom/views/screens/wardrobe/widgets/outfit_card.dart';

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
    return CustomGridHandler(
      horizontalPadding: _horizontalPadding,
      childAspectRatio: _gridAspectRatio,
      mainAxisSpacing: _gridSpacing,
      crossAxisSpacing: _gridSpacing,
      children: List.generate(
        outfit.savedOutfits.length,
        (index) => OutfitCard(outfit: outfit.savedOutfits[index]),
      ),
    );
  }
}
