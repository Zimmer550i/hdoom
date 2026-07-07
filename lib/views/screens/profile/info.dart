import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdoom/utils/app_texts.dart';
import 'package:hdoom/views/widgets/custom_app_bar.dart';
import 'package:hdoom/views/widgets/logo.dart';

class Info extends StatelessWidget {
  final String title;
  const Info({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: title),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Center(child: Logo(showName: true)),
            const SizedBox(height: 20,),
            Text(
              "about_hdoomi".tr,
              style: AppTexts.tmdr,
            ),
          ],
        ),
      ),
    );
  }
}
