import 'package:flutter/material.dart';
import 'package:hdoom/utils/app_colors.dart';
import 'package:hdoom/views/widgets/custom_app_bar.dart';

// ──────────────────────────────────────────────
// CUSTOMIZABLE VARIABLES — Change these to style
// ──────────────────────────────────────────────

// Layout
const _crossAxisCount = 2;
const _mainAxisSpacing = 16.0;
const _crossAxisSpacing = 16.0;
const _defaultAspectRatio = 0.66;
const _horizontalPadding = 20.0;
const _bottomPadding = 20.0;

// Colors
final _scaffoldBg = AppColors.bg;

// ──────────────────────────────────────────────

class ShowCardLists<T> extends StatelessWidget {
  final String title;
  final List<T> data;
  final Widget Function(T item) builder;
  final double? aspectRatio;

  const ShowCardLists({
    super.key,
    required this.title,
    required this.data,
    required this.builder,
    this.aspectRatio,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _scaffoldBg,
      appBar: CustomAppBar(title: title),
      body: GridView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: _horizontalPadding,
        ).copyWith(bottom: _bottomPadding),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _crossAxisCount,
          mainAxisSpacing: _mainAxisSpacing,
          crossAxisSpacing: _crossAxisSpacing,
          childAspectRatio: aspectRatio ?? _defaultAspectRatio,
        ),
        itemCount: data.length,
        itemBuilder: (context, index) => builder(data[index]),
      ),
    );
  }
}
