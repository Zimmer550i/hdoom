import 'package:flutter/material.dart';
import 'package:hdoom/views/screens/home/widgets/brand_new_section.dart';
import 'package:hdoom/views/screens/home/widgets/friends_style_section.dart';
import 'package:hdoom/views/screens/home/widgets/home_app_bar.dart';
import 'package:hdoom/views/screens/home/widgets/style_news_card.dart';
import 'package:hdoom/views/screens/home/widgets/todays_look_card.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildHomeAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            TodaysLookCard(),
            const SizedBox(height: 20),
            StyleNewsCard(),
            const SizedBox(height: 20),
            BrandNewSection(),
            const SizedBox(height: 20),
            FriendsStyleSection(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
