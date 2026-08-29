import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdoom/controllers/feed_controller.dart';
import 'package:hdoom/utils/app_colors.dart';
import 'package:hdoom/utils/custom_snackbar.dart';
import 'package:hdoom/views/screens/wardrobe/widgets/image_uploader.dart';
import 'package:hdoom/views/widgets/custom_app_bar.dart';
import 'package:hdoom/views/widgets/custom_button.dart';
import 'package:hdoom/views/widgets/custom_text_field.dart';

class CreateFeed extends StatefulWidget {
  const CreateFeed({super.key});

  @override
  State<CreateFeed> createState() => _CreateFeedState();
}

class _CreateFeedState extends State<CreateFeed> {
  final feed = Get.find<FeedController>();
  final List<File> _images = [];
  final TextEditingController caption = TextEditingController();

  void onSubmit() async {
    final message = await feed.createPost(
      caption: caption.text,
      images: _images,
    );

    if (message == "success") {
      if (mounted) {
        Get.back();
      }
      customSnackBar("Post created successfully", isError: false);
    } else {
      customSnackBar(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Create Post"),
      body: SingleChildScrollView(
        padding: .symmetric(horizontal: 20),
        child: SafeArea(
          child: Column(
            children: [
              ImageUploader(
                onChange: (val) {
                  if (val != null) {
                    setState(() {
                      _images.add(val);
                    });
                  }
                },
              ),
              if (_images.isNotEmpty) const SizedBox(height: 20),
              if (_images.isNotEmpty)
                SizedBox(
                  height: 70,
                  child: ListView.builder(
                    scrollDirection: .horizontal,
                    itemCount: _images.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            borderRadius: .circular(8),
                            border: Border.all(color: AppColors.black.shade100),
                            image: DecorationImage(
                              image: FileImage(_images[index]),
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _images.removeAt(index);
                                });
                              },
                              child: Icon(
                                Icons.cancel,
                                color: AppColors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 8),
              CustomTextField(
                title: "Title",
                controller: caption,
                hintText: "Enter title",
                radius: 12,
              ),
              const SizedBox(height: 20),
              Obx(
                () => CustomButton(
                  text: "Post",
                  isLoading: feed.isCreateLoading.value,
                  onTap: onSubmit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
