import 'dart:async';

import 'package:flutter/material.dart';

mixin PaginatedScrollController<T extends StatefulWidget> on State<T> {
  static int scrollDelta = 200;
  ScrollController scrollController = ScrollController();

  FutureOr<void> onNextPage();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<void> _handleScroll() async {
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.position.pixels;
    if (maxScroll - currentScroll <= scrollDelta) {
      await onNextPage.call();
    }
  }
}
