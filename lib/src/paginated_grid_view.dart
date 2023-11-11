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
    super.key,
    this.errorBuilder,
    this.loadingBuilder,
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
  });
  final AsyncValue<List<T>> state;
  final PaginatedNotifier<T> notifier;
  final Widget Function()? emptyListBuilder;
  final Widget Function(T data) itemBuilder;
  final Widget Function(Object error, StackTrace stackTrace)? errorBuilder;
  final Widget Function()? loadingBuilder;
  final Widget Function(
    BuildContext context,
    List<T> data,
  )? gridListBuilder;
  final Widget? skeleton;
  final int numSkeletons;
  final Axis scrollDirection;
  final bool pullToRefresh;
  final bool useSliverGrid;
  final ScrollController? customScrollController;
  final int? customScrollDelta;
  final bool shrinkWrap;

  @override
  State<PaginatedGridView<T>> createState() => _PaginatedGridViewState<T>();
}

class _PaginatedGridViewState<T> extends State<PaginatedGridView<T>>
    with PaginatedScrollController, PaginatedGridMixin {
  @override
  void initState() {
    scrollController = widget.customScrollController ?? scrollController;
    PaginatedScrollController.scrollDelta = widget.customScrollDelta ?? 200;
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
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 1 / 1.2,
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
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

    listView = SliverList.builder(
      itemCount: shouldRequireStatusRow ? data.length + 1 : data.length,
      itemBuilder: (BuildContext context, int index) =>
          itemBuilder(context, data, index),
    );
    return withRefreshIndicator(listView);
  }
}
