import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_infinite_scroll/riverpod_infinite_scroll.dart';
import 'package:riverpod_infinite_scroll/src/extensions/widget.dart';
import 'package:riverpod_infinite_scroll/src/mixins/paginated_grid_mixin.dart';

class PaginatedGridView<T> extends StatefulWidget {
  const PaginatedGridView({
    required this.state,
    required this.itemBuilder,
    required this.notifier,
    required this.gridDelegate,
    super.key,
    this.errorBuilder,
    this.loadingBuilder,
    this.initialLoadingBuilder,
    this.emptyListBuilder,
    this.gridListBuilder,
    this.skeleton,
    this.numSkeletons = 4,
    this.scrollDirection = Axis.vertical,
    this.pullToRefresh = false,
    this.shrinkWrap = false,
    this.useSliverGrid = false,
    this.customScrollController,
    this.customScrollDelta,
  }) : assert(
          !(useSliverGrid && customScrollController == null),
          'ScrollController required for Slivers. '
          'You should also assign this scrollController to your'
          ' CustomScrollView widget',
        );
  final AsyncValue<List<T>> state;
  final PaginatedNotifier<T> notifier;
  final Widget Function()? emptyListBuilder;
  final Widget Function(T data) itemBuilder;
  final Widget Function(Object error, StackTrace stackTrace)? errorBuilder;
  final Widget Function(Pagination pagination)? loadingBuilder;
  final Widget Function()? initialLoadingBuilder;
  final Widget Function(
    BuildContext context,
    List<T> data,
  )? gridListBuilder;
  final SliverGridDelegate gridDelegate;
  final Widget? skeleton;
  final int numSkeletons;
  final Axis scrollDirection;
  final bool pullToRefresh;
  final bool useSliverGrid;
  final ScrollController? customScrollController;
  final double? customScrollDelta;
  final bool shrinkWrap;

  @override
  State<PaginatedGridView<T>> createState() => _PaginatedGridViewState<T>();
}

class _PaginatedGridViewState<T> extends State<PaginatedGridView<T>>
    with PaginatedScrollController, PaginatedGridMixin {
  @override
  void initState() {
    if (widget.customScrollController != null) {
      scrollController = widget.customScrollController!;
      scrollControllerAutoDispose = false;
    }
    scrollController = widget.customScrollController ?? scrollController;
    PaginatedScrollController.scrollDelta = widget.customScrollDelta ?? 200.0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.state.when(
      data: _listBuilder,
      error: (error, stackTrace) {
        if (widget.notifier.hasData()) {
          return _listBuilder(widget.notifier.getCurrentData());
        }
        return widget.errorBuilder?.call(error, stackTrace) ?? genericError;
      },
      loading: () {
        if (widget.notifier.hasData()) {
          return _listBuilder(widget.notifier.getCurrentData());
        }
        if (widget.initialLoadingBuilder != null) {
          return widget.initialLoadingBuilder!.call();
        }
        if (widget.skeleton != null) {
          return buildShimmer();
        }
        return loadingBuilder;
      },
    );
  }

  Widget _listBuilder(List<T> data) {
    if (widget.gridListBuilder != null) {
      return widget.gridListBuilder!.call(context, data);
    }

    return widget.useSliverGrid ? _sliverGridList(data) : _gridList(data);
  }

  Widget _gridList(List<T> data) {
    Widget? listView;
    if (data.isEmpty) {
      return widget.emptyListBuilder?.call() ?? noItemsFound;
    }
    listView = GridView.builder(
      scrollDirection: widget.scrollDirection,
      controller: scrollController,
      shrinkWrap: widget.shrinkWrap,
      gridDelegate: widget.gridDelegate,
      itemCount: shouldRequireStatusRow ? data.length + 1 : data.length,
      itemBuilder: (BuildContext context, int index) =>
          itemBuilder(context, data, index),
    );

    return withRefreshIndicator(listView);
  }

  Widget _sliverGridList(List<T> data) {
    Widget? listView;

    if (data.isEmpty) {
      return widget.emptyListBuilder?.call() ?? noItemsFound.sliverToBoxAdapter;
    }

    listView = SliverGrid.builder(
      gridDelegate: widget.gridDelegate,
      itemCount: shouldRequireStatusRow ? data.length + 1 : data.length,
      itemBuilder: (BuildContext context, int index) =>
          itemBuilder(context, data, index),
    );
    return withRefreshIndicator(listView);
  }
}
