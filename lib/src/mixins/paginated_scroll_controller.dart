import 'dart:async';

import 'package:flutter/material.dart';

///A mixin to track the scroll position of a ScrollController in Scroll views
///If the threshold is reached, a fetch next page request can be fired.
///
mixin PaginatedScrollController<T extends StatefulWidget> on State<T> {
  static double scrollDelta = 200;
  ScrollController scrollController = ScrollController();
  bool scrollControllerAutoDispose = true;
  FutureOr<void> onNextPage();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    if (scrollControllerAutoDispose) {
      scrollController.dispose();
    }
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
