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
mixin PaginatedListMixin<T> on State<PaginatedListView<T>> {
  List<Widget> get skeletons =>
      List.generate(widget.numSkeletons, (_) => widget.skeleton!);

  bool get shouldRequireStatusRow =>
      widget.state.hasError || widget.state.isLoading;

  Widget get statusRow {
    final config = InfiniteScrollPaginationConfig.of(context);
    return widget.state.maybeWhen(
      loading: () {
        if (widget.loadingBuilder != null) {
          return widget.loadingBuilder!
              .call(context, widget.notifier.getPaginationData());
        }
        return config?.loadingBuilder
                ?.call(context, widget.notifier.getPaginationData()) ??
            LoadingIndicator.small.centered.withPaddingAll(10);
      },
      error: (error, stackTrace) {
        if (widget.errorBuilder != null) {
          return widget.errorBuilder!.call(context, error, stackTrace);
        }
        return config?.errorBuilder?.call(context, error, stackTrace) ??
            const Text('An error occurred').centered;
      },
      orElse: SizedBox.shrink,
    );
  }

  Widget get noItemsFound => NoItemsFound(
        onRetry: () => widget.notifier.refresh(),
      ).centered;

  Widget withRefreshIndicator(Widget child) {
    return widget.pullToRefresh && !widget.useSliver
        ? child.withRefreshIndicator(
            onRefresh: () async {
              await widget.notifier.refresh();
            },
          )
        : child;
  }

  Widget maybeWrapWithSliverToBoxAdapter(Widget child) {
    return widget.useSliver ? child.sliverFillRemaining : child;
  }

  Widget maybeWrapWithSliverFill(Widget child) {
    return widget.useSliver ? child.sliverFillRemaining : child;
  }

  Widget get genericError {
    return GenericError(
      message: 'Sorry, an error occurred while trying to load the data.'
          ' Please try later',
      onRetry: widget.notifier.refresh,
    ).centered;
  }

  Widget get loadingIndicator {
    final loading = const LoadingIndicator().centered;
    return widget.useSliver ? loading.sliverToBoxAdapter : loading;
  }

  Widget get initialLoadingBuilder {
    return widget.initialLoadingBuilder?.call(
          context,
        ) ??
        loadingIndicator;
  }

  Widget buildShimmer() {
    return widget.useSliver
        ? Skeletonizer.sliver(
            child: SliverList.list(children: skeletons),
          )
        : Skeletonizer(
            child: ListView(
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
    return widget.itemBuilder.call(context, data[index]);
  }

  FutureOr<void> onNextPage() {
    if (!widget.state.isLoading &&
        !widget.state.hasError &&
        widget.notifier.canFetch()) {
      widget.notifier.getNextPage();
    }
  }
}
