import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

class AiLoading extends StatelessWidget {
  const AiLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
        maxHeight: MediaQuery.of(context).size.width,
      ),
      child: LottieBuilder.asset("assets/images/ai_loading.json"),
    );
  }
}
