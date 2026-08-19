import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdoom/controllers/social_controller.dart';
import 'package:hdoom/utils/custom_list_handler.dart';
import 'package:hdoom/views/screens/home/widgets/user_card.dart';
import 'package:hdoom/views/widgets/custom_app_bar.dart';

enum UserListType { followers, following }

class UsersList extends StatefulWidget {
  final String username;
  final UserListType type;
  const UsersList({super.key, required this.username, required this.type});

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  final social = Get.find<SocialController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: getTitle()),
      body: Obx(
        () => CustomListHandler(isLoading: isLoading(), children: getData()),
      ),
    );
  }

  String getTitle() {
    switch (widget.type) {
      case UserListType.followers:
        return "Followers";
      case UserListType.following:
        return "Following";
    }
  }

  bool isLoading() {
    switch (widget.type) {
      case UserListType.followers:
        return social.isFollowersLoading.value;
      case UserListType.following:
        return social.isFollowingLoading.value;
    }
  }

  List<Widget> getData() {
    switch (widget.type) {
      case UserListType.followers:
        return social.followers.map((val) => UserCard(userInfo: val)).toList();
      case UserListType.following:
        return social.following.map((val) => UserCard(userInfo: val)).toList();
    }
  }

  void fetchData() {
    switch (widget.type) {
      case UserListType.followers:
        social.getFollowers(widget.username);
        break;
      case UserListType.following:
        social.getFollowing(widget.username);
        break;
    }
  }
}
