import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_infinite_scroll_pagination/riverpod_infinite_scroll_pagination.dart';
import 'package:riverpod_infinite_scroll_pagination/src/extensions/widget.dart';
import 'package:riverpod_infinite_scroll_pagination/src/widgets/generic_error.dart';
import 'package:riverpod_infinite_scroll_pagination/src/widgets/loading_indicator.dart';
import 'package:riverpod_infinite_scroll_pagination/src/widgets/no_items_found.dart';
import 'package:skeletonizer/skeletonizer.dart';

@internal

///To be used in ListView
mixin PaginatedWidgetMixin<T> on PaginatedListView<T>, State {
  List<Widget> get skeletons => List.generate(numSkeletons, (_) => skeleton!);

  bool get shouldRequireStatusRow => state.hasError || state.isLoading;

  Widget get statusRow {
    final config = InfiniteScrollPaginationConfig.of(context);
    return state.maybeWhen(
      loading: () {
        if (loadingBuilder != null) {
          return loadingBuilder!.call(context, notifier.getPaginationData());
        }
        return config?.loadingBuilder
                ?.call(context, notifier.getPaginationData()) ??
            LoadingIndicator.small.centered.withPaddingAll(10);
      },
      error: (error, stackTrace) {
        if (errorBuilder != null) {
          return errorBuilder!.call(context, error, stackTrace);
        }
        return config?.errorBuilder?.call(context, error, stackTrace) ??
            const Text('An error occurred').centered;
      },
      orElse: SizedBox.shrink,
    );
  }

  Widget get noItemsFound => NoItemsFound(
        onRetry: notifier.refresh,
      ).centered;

  Widget withRefreshIndicator(Widget child) {
    return pullToRefresh && !useSliver
        ? child.withRefreshIndicator(
            onRefresh: () async {
              await notifier.refresh();
            },
          )
        : child;
  }

  Widget maybeWrapWithSliverToBoxAdapter(Widget child) {
    return useSliver ? child.sliverFillRemaining : child;
  }

  Widget maybeWrapWithSliverFill(Widget child) {
    return useSliver ? child.sliverFillRemaining : child;
  }

  Widget get genericError {
    return GenericError(
      message: 'Sorry, an error occurred while trying to load the data.'
          ' Please try later',
      onRetry: notifier.refresh,
    ).centered;
  }

  Widget get loadingIndicator {
    final loading = const LoadingIndicator().centered;
    return useSliver ? loading.sliverToBoxAdapter : loading;
  }

  Widget get initialLoading {
    return initialLoadingBuilder?.call(
          context,
        ) ??
        loadingIndicator;
  }

  Widget buildShimmer() {
    return useSliver
        ? Skeletonizer.sliver(
            child: SliverList.list(children: skeletons),
          )
        : Skeletonizer(
            child: ListView(
              children: skeletons,
            ),
          );
  }

  Widget itemBuilderWidget(
    BuildContext context,
    List<T> data,
    int index,
  ) {
    if (shouldRequireStatusRow && data.length == index) {
      return statusRow;
    }
    return itemBuilder.call(context, data[index]);
  }

  FutureOr<void> onNextPage() {
    if (!state.isLoading && !state.hasError && notifier.canFetch()) {
      notifier.getNextPage();
    }
  }
}
