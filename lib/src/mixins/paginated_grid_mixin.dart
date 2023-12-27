import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_infinite_scroll_pagination/src/extensions/widget.dart';
import 'package:riverpod_infinite_scroll_pagination/src/paginated_grid_view.dart';
import 'package:riverpod_infinite_scroll_pagination/src/widgets/generic_error.dart';
import 'package:riverpod_infinite_scroll_pagination/src/widgets/infinite_scroll_pagination_config.dart';
import 'package:riverpod_infinite_scroll_pagination/src/widgets/loading_indicator.dart';
import 'package:riverpod_infinite_scroll_pagination/src/widgets/no_items_found.dart';
import 'package:skeletonizer/skeletonizer.dart';

@internal

///To be used in GridView
mixin PaginatedGridMixin<T> on State<PaginatedGridView<T>> {
  List<Widget> get skeletons =>
      List.generate(widget.numSkeletons, (_) => widget.skeleton!);

  bool get shouldRequireStatusRow => widget.state.isLoading;

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

  Widget maybeWithRefreshIndicator(Widget child) {
    final config = InfiniteScrollPaginationConfig.of(context);
    return (config?.pullToRefresh ?? false || widget.pullToRefresh) &&
            !widget.useSliver
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
    return maybeWrapWithSliverToBoxAdapter(errorWidget);
  }

  Widget get loadingIndicator {
    final loading = const LoadingIndicator().centered;
    return maybeWrapWithSliverToBoxAdapter(loading);
  }

  Widget maybeWrapWithSliverToBoxAdapter(Widget child) {
    return widget.useSliver ? child.sliverToBoxAdapter : child;
  }

  Widget get initialLoadingBuilder {
    final config = InfiniteScrollPaginationConfig.of(context);
    if (widget.loadingBuilder != null) {
      return widget.loadingBuilder!
          .call(context, widget.notifier.getPaginationData());
    }
    if (config?.initialLoadingBuilder != null) {
      return maybeWrapWithSliverToBoxAdapter(
        config!.initialLoadingBuilder!.call(context),
      );
    }
    return loadingIndicator;
  }

  Widget buildShimmer() {
    return widget.useSliver
        ? Skeletonizer.sliver(
            child: SliverGrid.builder(
              gridDelegate: widget.gridDelegate,
              itemCount: widget.numSkeletons,
              itemBuilder: (_, __) => widget.skeleton,
            ),
          )
        : Skeletonizer(
            child: GridView.builder(
              gridDelegate: widget.gridDelegate,
              itemCount: widget.numSkeletons,
              itemBuilder: (_, __) => widget.skeleton,
            ),
          );
  }

  Widget itemBuilder(
    BuildContext context,
    List<T> data,
    int index,
  ) {
    if (widget.state.isLoading &&
        widget.skeleton != null &&
        index >= data.length) {
      return Skeletonizer(
        child: widget.skeleton!,
      );
    }
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
