import 'package:flutter/material.dart';
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
              "HDOOM-I is a mobile-first, bilingual (Arabic–English) fashion platform created to empower women in the GCC with personalized, culturally relevant style guidance. By combining AI-driven recommendations with expert fashion consultant oversight, Fashion Hub delivers curated outfit suggestions, trend insights, and wardrobe-based styling tailored to regional preferences, seasons, and occasions. The platform brings together fashion news, brand updates, influencer content, and smart personalization to simplify everyday fashion decisions while celebrating modern style rooted in local culture.",
              style: AppTexts.tmdr,
            ),
          ],
        ),
      ),
    );
  }
}
