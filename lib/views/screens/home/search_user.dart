import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdoom/controllers/social_controller.dart';
import 'package:hdoom/utils/custom_list_handler.dart';
import 'package:hdoom/views/screens/home/widgets/user_card.dart';
import 'package:hdoom/views/widgets/custom_app_bar.dart';
import 'package:hdoom/views/widgets/custom_button.dart';
import 'package:hdoom/views/widgets/custom_text_field.dart';

class SearchUser extends StatefulWidget {
  const SearchUser({super.key});

  @override
  State<SearchUser> createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchUser> {
  final social = Get.find<SocialController>();
  final search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Search"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            CustomTextField(
              controller: search,
              leading: "assets/icons/search.svg",
              hintText: "Search users...",
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: CustomButton(
                onTap: () => social.searchUsers(search.text),
                text: "Search",
                width: null,
                padding: 20,
                height: 36,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Obx(
                () => CustomListHandler(
                  isLoading: social.isSearchLoading.value,
                  onRefresh: () => social.searchUsers(search.text),
                  children: [
                    for (var i in social.searchResults) UserCard(userInfo: i),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
