import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdoom/utils/app_colors.dart';
import 'package:hdoom/utils/app_texts.dart';
import 'package:hdoom/utils/custom_svg.dart';
import 'package:hdoom/views/screens/home/show_card_lists.dart';
import 'package:hdoom/views/widgets/profile_picture.dart';

/// Horizontally-scrolling "FRIENDS STYLE" social feed section
/// showing friends' outfit photos with their handles.
class FriendsStyleSection extends StatelessWidget {
  const FriendsStyleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        const SizedBox(height: 16),
        _buildFriendsList(),
      ],
    );
  }

  Widget _buildHeader() {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => ShowCardLists(
            title: "Friend's Styles",
            data: [for (int i = 0; i < 10; i++) "Hi", "End"],
            builder: (val) {
              return _buildFriendCard();
            },
          ),
        );
      },
      child: Row(
        children: [
          Expanded(child: Text("FRIENDS STYLE", style: AppTexts.txlm)),
          CustomSvg(
            asset: "assets/icons/arrow_forward.svg",
            color: AppColors.black.shade300,
          ),
        ],
      ),
    );
  }

  Widget _buildFriendsList() {
    return SizedBox(
      height: 260,
      child: ListView(
        shrinkWrap: true,
        clipBehavior: Clip.none,
        scrollDirection: Axis.horizontal,
        children: [
          for (int i = 0; i < 10; i++)
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: _buildFriendCard(),
            ),
        ],
      ),
    );
  }

  Widget _buildFriendCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 200,
        decoration: BoxDecoration(color: Colors.white),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset("assets/images/style_casual.jpg", fit: BoxFit.cover),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.5, 1],
                    colors: [
                      Colors.black.withValues(alpha: 0),
                      Colors.black.withValues(alpha: 0.3),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Row(
                spacing: 4,
                children: [
                  ProfilePicture(size: 32),
                  Expanded(
                    child: Text(
                      "@loura_2",
                      style: AppTexts.tmdm.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
