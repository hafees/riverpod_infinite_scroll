import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_infinite_scroll/riverpod_infinite_scroll.dart';
import 'package:riverpod_infinite_scroll/src/extensions/widget.dart';
import 'package:riverpod_infinite_scroll/src/mixins/paginated_list_mixin.dart';

///
///## ListView or SliverList widget with Infinite scroll pagination
///Builds a ListView or SliverList widget with Infinite scroll pagination
///using Riverpod notifiers
///
///**Example**
///```dart
/// PaginatedListView(
///       state: movies,
///       itemBuilder: (data) => MovieItem(movie: data),
///       notifier: ref.read(trendingMoviesListProvider.notifier),
///     );
///```
///
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
    this.initialLoadingBuilder,
    this.skeleton,
    this.numSkeletons = 4,
    this.scrollDirection = Axis.vertical,
    this.pullToRefresh = true,
    this.useSliverList = false,
    this.shrinkWrap = false,
    this.customScrollController,
    this.customScrollDelta,
  }) : assert(
          !(useSliverList && customScrollController == null),
          'customScrollController can not be null for sliver lists ',
        );

  ///The riverpod AsyncNotifier state
  ///Eg: `ref.watch(myProvider)`
  final AsyncValue<List<T>> state;

  ///The riverpod notifier.
  ///Eg: `ref.watch(myProvider.notifier)`
  final PaginatedNotifier<T> notifier;

  ///Optional builder to use when the data is empty even after querying
  ///If omitted, a default error widget will be shown.
  final Widget Function()? emptyListBuilder;

  ///Required item builder similar to the `itemBuilder` in ListViews.
  ///The builder wil receive one data at a time
  final Widget Function(T data) itemBuilder;

  ///Optional error builder.
  ///The builder will receive the error object and stack trace.
  ///If omitted a generic error widget with a retry button will be used
  final Widget Function(Object error, StackTrace stackTrace)? errorBuilder;

  ///Optional loading state builder. This widget will show inside the ListView.
  ///The builder will also receive the `Pagination` object and can be used to
  ///build more informative Widgets.
  ///By default a simple `CircularProgressIndicator.adaptive` is used.
  ///
  ///** Example **
  ///```dart
  ///loadingBuilder: (pagination) {
  ///   return Row(
  ///     mainAxisAlignment: MainAxisAlignment.center,
  ///     children: [
  ///       const CircularProgressIndicator.adaptive(),
  ///       const SizedBox(
  ///         width: 10,
  ///       ),
  ///       Text(
  ///         'Loading page ${pagination.currentPage + 1} of ${pagination.lastPage}',
  ///       ),
  ///     ],
  ///   );
  /// },
  /// ```
  final Widget Function(Pagination pagination)? loadingBuilder;

  ///The initial loading builder when there is no data. Defaults to an adaptive
  ///progress indicator. Also, you can use a skeleton loading animation using
  ///the `skeleton` field.
  final Widget Function()? initialLoadingBuilder;

  ///Low level list view builder. Don't need to use in normal cases.
  ///Only useful, if you want to completely build the list yourself(May be
  ///using a custom widget)
  final Widget Function(
    BuildContext context,
    List<T> data,
  )? listViewBuilder;

  ///If supplied, a skeleton loading animation will be showed initially. You
  ///just need to pass the item widget with some dummy data. A skeleton will be
  ///created automatically using
  final Widget? skeleton;
  final int numSkeletons;
  final Widget Function(BuildContext, int)? separatorBuilder;
  final Axis scrollDirection;
  final bool pullToRefresh;
  final bool useSliverList;
  final ScrollController? customScrollController;
  final double? customScrollDelta;
  final bool shrinkWrap;

  @override
  State<PaginatedListView<T>> createState() => _PaginatedListViewState<T>();
}

class _PaginatedListViewState<T> extends State<PaginatedListView<T>>
    with PaginatedScrollController, PaginatedListMixin {
  @override
  void initState() {
    if (widget.customScrollController != null) {
      scrollController = widget.customScrollController!;
      scrollControllerAutoDispose = false;
    }
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
