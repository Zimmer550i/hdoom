import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdoom/models/public_user_model.dart';
import 'package:hdoom/utils/app_texts.dart';
import 'package:hdoom/views/screens/profile/profile.dart';
import 'package:hdoom/views/widgets/profile_picture.dart';

class UserCard extends StatelessWidget {
  final PublicUserModel userInfo;
  const UserCard({super.key, required this.userInfo});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => Profile(username: userInfo.username));
      },
      child: Row(
        children: [
          AbsorbPointer(
            child: ProfilePicture(image: userInfo.profileImage, size: 52),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userInfo.name, style: AppTexts.tlgm),
                Text("${userInfo.username}@gmail.com", style: AppTexts.tmdr),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
