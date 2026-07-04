import 'package:flutter/material.dart';
import 'package:hdoom/utils/app_colors.dart';
import 'package:hdoom/views/widgets/custom_loading.dart';

class CustomGridHandler extends StatelessWidget {
  final Future<void> Function()? onRefresh;
  final Future<void> Function()? onLoadMore;
  final double scrollThreshold;
  final double horizontalPadding;
  final double verticalPadding;
  final List<Widget> children;
  final String endIndicator;
  final Widget? endWidget;
  final String placeholder;
  final TextStyle textStyle;
  final bool isLoading;
  final bool isLoadingMore;
  final ScrollController? controller;
  final ScrollPhysics? physics;

  // Grid-specific properties
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;
  final SliverGridDelegate? gridDelegate;

  const CustomGridHandler({
    super.key,
    this.children = const [],
    this.onRefresh,
    this.onLoadMore,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.endIndicator = "End of the list",
    this.endWidget,
    this.placeholder = "Nothing to show",
    this.textStyle = const TextStyle(
      color: Colors.blueGrey,
      fontWeight: FontWeight.w300,
    ),
    this.scrollThreshold = 200,
    this.horizontalPadding = 20,
    this.verticalPadding = 12,
    this.controller,
    this.physics,
    this.crossAxisCount = 2,
    this.mainAxisSpacing = 16,
    this.crossAxisSpacing = 16,
    this.childAspectRatio = 0.66,
    this.gridDelegate,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (onLoadMore == null || isLoadingMore || isLoading) {
          return false;
        }

        final metrics = scrollInfo.metrics;

        if (!metrics.hasContentDimensions || metrics.maxScrollExtent <= 0) {
          return false;
        }

        if (metrics.pixels >= metrics.maxScrollExtent - scrollThreshold) {
          onLoadMore!();
        }

        return false;
      },
      child: isLoading
          ? Center(child: CustomLoading())
          : RefreshIndicator(
              onRefresh: onRefresh ?? () async {},
              color: AppColors.black,
              backgroundColor: AppColors.black[25],
              child: _buildGrid(),
            ),
    );
  }

  Widget _buildGrid() {
    if (children.isEmpty && !isLoadingMore) {
      return CustomScrollView(
        controller: controller,
        physics: physics ?? const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(placeholder, style: textStyle),
              ),
            ),
          ),
        ],
      );
    }

    final delegate = gridDelegate ??
        SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: mainAxisSpacing,
          crossAxisSpacing: crossAxisSpacing,
          childAspectRatio: childAspectRatio,
        );

    return CustomScrollView(
      controller: controller,
      physics: physics ?? const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) => children[index],
              childCount: children.length,
            ),
            gridDelegate: delegate,
          ),
        ),
        SliverToBoxAdapter(
          child: isLoadingMore
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CustomLoading()),
                )
              : SafeArea(
                  child: endWidget ??
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(endIndicator, style: textStyle),
                        ),
                      ),
                ),
        ),
      ],
    );
  }
}
