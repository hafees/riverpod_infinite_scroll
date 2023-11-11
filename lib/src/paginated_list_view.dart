import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_infinite_scroll/riverpod_infinite_scroll.dart';
import 'package:riverpod_infinite_scroll/src/extensions/widget.dart';
import 'package:riverpod_infinite_scroll/src/mixins/paginated_list_mixin.dart';

class PaginatedListView<T> extends StatefulWidget {
  const PaginatedListView({
    required this.state,
    required this.itemBuilder,
    required this.notifier,
    super.key,
    this.errorBuilder,
    this.loadingBuilder,
    this.emptyListBuilder,
    this.separatorBuilder,
    this.listViewBuilder,
    this.skeleton,
    this.numSkeletons = 4,
    this.scrollDirection = Axis.vertical,
    this.pullToRefresh = false,
    this.useSliverList = false,
    this.shrinkWrap = false,
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
  )? listViewBuilder;
  final Widget? skeleton;
  final int numSkeletons;
  final Widget Function(BuildContext, int)? separatorBuilder;
  final Axis scrollDirection;
  final bool pullToRefresh;
  final bool useSliverList;
  final ScrollController? customScrollController;
  final int? customScrollDelta;
  final bool shrinkWrap;

  @override
  State<PaginatedListView<T>> createState() => _PaginatedListViewState<T>();
}

class _PaginatedListViewState<T> extends State<PaginatedListView<T>>
    with PaginatedScrollController, PaginatedListMixin {
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
    if (widget.listViewBuilder != null) {
      return widget.listViewBuilder!.call(context, data);
    }

    return widget.useSliverList ? _sliverListView(data) : _listView(data);
  }

  Widget _listView(List<T> data) {
    Widget? listView;
    if (data.isEmpty) {
      return widget.emptyListBuilder?.call() ?? noItemsFound;
    }
    if (widget.separatorBuilder != null) {
      listView = ListView.separated(
        scrollDirection: widget.scrollDirection,
        controller: scrollController,
        itemCount: shouldRequireStatusRow ? data.length + 1 : data.length,
        itemBuilder: (BuildContext context, int index) =>
            itemBuilder(context, data, index),
        separatorBuilder: widget.separatorBuilder!,
        shrinkWrap: widget.shrinkWrap,
      );
    } else {
      listView = ListView.builder(
        controller: scrollController,
        scrollDirection: widget.scrollDirection,
        itemCount: shouldRequireStatusRow ? data.length + 1 : data.length,
        itemBuilder: (BuildContext context, int index) =>
            itemBuilder(context, data, index),
        shrinkWrap: widget.shrinkWrap,
      );
    }
    return withRefreshIndicator(listView);
  }

  Widget _sliverListView(List<T> data) {
    Widget? listView;

    if (data.isEmpty) {
      return widget.emptyListBuilder?.call() ?? noItemsFound.sliverToBoxAdapter;
    }

    if (widget.separatorBuilder != null) {
      listView = SliverList.separated(
        itemCount: shouldRequireStatusRow ? data.length + 1 : data.length,
        itemBuilder: (BuildContext context, int index) =>
            itemBuilder(context, data, index),
        separatorBuilder: widget.separatorBuilder!,
      );
    } else {
      listView = SliverList.builder(
        itemCount: shouldRequireStatusRow ? data.length + 1 : data.length,
        itemBuilder: (BuildContext context, int index) =>
            itemBuilder(context, data, index),
      );
    }
    return withRefreshIndicator(listView);
  }
}
