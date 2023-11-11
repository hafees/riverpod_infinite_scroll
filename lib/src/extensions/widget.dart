import 'package:flutter/material.dart';

extension WidgetUtils on Widget {
  Widget withPadding(EdgeInsetsGeometry edgeInsets) {
    return Padding(
      padding: edgeInsets,
      child: this,
    );
  }

  Widget withPaddingAll(double padding) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: this,
    );
  }

  Widget withHorizontalPadding(double padding) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: this,
    );
  }

  Widget withVerticalPadding(double padding) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: padding),
      child: this,
    );
  }

  Widget withSymmetricPadding({
    required double horizontalPadding,
    required double verticalPadding,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: verticalPadding,
        horizontal: horizontalPadding,
      ),
      child: this,
    );
  }

  Widget withPaddingBottom(double bottom) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: this,
    );
  }

  Widget withPaddingTop(double top) {
    return Padding(
      padding: EdgeInsets.only(top: top),
      child: this,
    );
  }

  Widget withRefreshIndicator({required Future<void> Function() onRefresh}) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: this,
    );
  }

  Widget get centered {
    return Center(
      child: this,
    );
  }

  Widget get expanded {
    return Expanded(
      child: this,
    );
  }

  Widget get flexible {
    return Flexible(
      child: this,
    );
  }

  Widget get sliverToBoxAdapter {
    return SliverToBoxAdapter(
      child: this,
    );
  }
}
