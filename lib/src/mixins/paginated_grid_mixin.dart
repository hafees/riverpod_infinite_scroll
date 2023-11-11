import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_infinite_scroll/src/extensions/widget.dart';
import 'package:riverpod_infinite_scroll/src/paginated_grid_view.dart';
import 'package:riverpod_infinite_scroll/src/widgets/generic_error.dart';
import 'package:riverpod_infinite_scroll/src/widgets/loading_indicator.dart';
import 'package:riverpod_infinite_scroll/src/widgets/no_items_found.dart';
import 'package:shimmer/shimmer.dart';

mixin PaginatedGridMixin<T> on State<PaginatedGridView<T>> {
  List<Widget> get skeletons =>
      List.generate(widget.numSkeletons, (_) => widget.skeleton!);

  bool get shouldRequireStatusRow =>
      widget.state.hasError || widget.state.isLoading;

  Widget get statusRow => widget.state.maybeWhen(
        loading: () {
          return widget.loadingBuilder?.call() ??
              LoadingIndicator.small.centered.withPaddingAll(10);
        },
        error: (error, stackTrace) =>
            widget.errorBuilder?.call(error, stackTrace) ??
            const Text('An error occurred').centered,
        orElse: SizedBox.shrink,
      );

  Widget get noItemsFound => NoItemsFound(
        onRetry: () => widget.notifier.refresh(),
      ).centered;

  Widget withRefreshIndicator(Widget child) {
    return widget.pullToRefresh
        ? child.withRefreshIndicator(
            onRefresh: () async {
              await widget.notifier.refresh();
            },
          )
        : child;
  }

  Widget get genericError {
    final errorWidget = GenericError(
      message: 'Sorry, an error occurred while trying to load the data.'
          ' Please try later',
      onRetry: widget.notifier.refresh,
    );
    return widget.useSliverGrid ? errorWidget.sliverToBoxAdapter : errorWidget;
  }

  Widget get loadingIndicator {
    final loading = const LoadingIndicator().centered;
    return widget.useSliverGrid ? loading.sliverToBoxAdapter : loading;
  }

  Widget get loadingBuilder {
    return widget.loadingBuilder?.call() ?? loadingIndicator;
  }

  Widget buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade400,
      highlightColor: Colors.grey.shade200,
      child: widget.useSliverGrid
          ? SliverList.list(children: skeletons)
          : ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: skeletons,
            ),
    );
  }

  Widget itemBuilder(
    BuildContext context,
    List<T> data,
    int index,
  ) {
    if (shouldRequireStatusRow && data.length == index) {
      return statusRow;
    }
    return widget.itemBuilder.call(data[index]);
  }

  FutureOr<void> onNextPage() {
    if (!widget.state.isLoading && widget.notifier.canFetch()) {
      widget.notifier.getNextPage();
    }
  }
}
