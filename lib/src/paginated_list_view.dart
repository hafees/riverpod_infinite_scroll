import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_infinite_scroll_pagination/riverpod_infinite_scroll_pagination.dart';
import 'package:riverpod_infinite_scroll_pagination/src/extensions/widget.dart';
import 'package:riverpod_infinite_scroll_pagination/src/mixins/paginated_list_mixin.dart';

class PaginatedListView<T> extends StatefulWidget {
  /// [ListView] or [SliverList] widget with automated pagination capabilities.
  ///
  /// Builds a ListView or SliverList widget with Infinite scroll pagination
  /// using Riverpod notifiers
  ///
  /// **Example**
  /// ```dart
  /// PaginatedListView(
  ///       state:  ref.watch(trendingMoviesListProvider),
  ///       itemBuilder: (data) => MovieItem(movie: data),
  ///       notifier: ref.read(trendingMoviesListProvider.notifier),
  ///     );
  /// ```
  ///
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
    this.useSliver = false,
    this.shrinkWrap = false,
    this.reverse = false,
    this.scrollController,
    this.scrollDelta,
  }) : assert(
          !(useSliver && scrollController == null),
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
  final Widget Function(BuildContext context)? emptyListBuilder;

  ///Required item builder similar to the `itemBuilder` in ListViews.
  ///The builder wil receive one data at a time
  final Widget Function(BuildContext context, T data) itemBuilder;

  ///Optional error builder.
  ///The builder will receive the error object and stack trace.
  ///If omitted a generic error widget with a retry button will be used
  final Widget Function(
    BuildContext context,
    Object error,
    StackTrace stackTrace,
  )? errorBuilder;

  ///Optional loading state builder. This widget will show inside the ListView.
  ///The builder will also receive the `Pagination` object and can be used to
  ///build more informative Widgets.
  ///By default a simple `CircularProgressIndicator.adaptive` is used.
  ///
  /// **Example**
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
  ///         'Loading page ${pagination.currentPage + 1} of '
  ///         '${pagination.lastPage}',
  ///       ),
  ///     ],
  ///   );
  /// },
  /// ```
  final Widget Function(BuildContext context, Pagination pagination)?
      loadingBuilder;

  ///The initial loading builder when there is no data. Defaults to an adaptive
  ///progress indicator. Also, you can use a skeleton loading animation using
  ///the `skeleton` field.
  final Widget Function(BuildContext context)? initialLoadingBuilder;

  ///Low level list view builder. Don't need to use in normal cases.
  ///Only useful, if you want to completely build the list yourself(May be
  ///using a custom widget)
  final Widget Function(
    BuildContext context,
    List<T> data,
  )? listViewBuilder;

  /// If supplied, a skeleton loading animation will be showed initially. You
  /// just need to pass the item widget with some dummy data. A skeleton will be
  /// created automatically using *skeletonizer* library
  final Widget? skeleton;

  ///How many skeletons to show int the initial loading. Ignored if skeleton is
  ///not provide.
  final int numSkeletons;

  /// Builder funtion to build sepearator between  items. Just like
  /// [ListView.separated]
  final Widget Function(BuildContext, int)? separatorBuilder;

  /// The scroll direction. Defaults to [Axis.vertical]
  final Axis scrollDirection;

  /// Whether pull to refresh functionality is required. Ignored for slivers.
  final bool pullToRefresh;

  /// If true, a SliverList is returned. Either [SliverList.builder] or
  /// [SliverList.separated]
  final bool useSliver;

  /// Automatically created for non sliver lists. But you can also provide one.
  /// Mandatory if [useSliver] is true.
  final ScrollController? scrollController;

  /// When to trigger the next page request. By default, next page request is
  /// triggered when there is only <=200 pixels to reach the end of scroll.
  final double? scrollDelta;

  /// Whether to enable [shrinkWrap] property on [ListView]. Defaults to false.
  final bool shrinkWrap;

  /// Whether to enable [reverse] property on [ListView]. Defaults to false.
  final bool reverse;

  @override
  State<PaginatedListView<T>> createState() => _PaginatedListViewState<T>();
}

class _PaginatedListViewState<T> extends State<PaginatedListView<T>>
    with PaginatedScrollController, PaginatedListMixin {
  @override
  void initState() {
    if (widget.scrollController != null) {
      scrollController = widget.scrollController!;
      scrollControllerAutoDispose = false;
    }
    PaginatedScrollController.scrollDelta = widget.scrollDelta ?? 200.0;
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
        return widget.errorBuilder?.call(context, error, stackTrace) ??
            genericError;
      },
      loading: () {
        if (widget.notifier.hasData()) {
          return _listBuilder(widget.notifier.getCurrentData());
        }
        if (widget.initialLoadingBuilder != null) {
          return widget.initialLoadingBuilder!.call(context);
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

    return widget.useSliver ? _sliverListView(data) : _listView(data);
  }

  Widget _listView(List<T> data) {
    Widget? listView;
    if (data.isEmpty) {
      return widget.emptyListBuilder?.call(context) ?? noItemsFound;
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
        reverse: widget.reverse,
      );
    } else {
      listView = ListView.builder(
        controller: scrollController,
        scrollDirection: widget.scrollDirection,
        itemCount: shouldRequireStatusRow ? data.length + 1 : data.length,
        itemBuilder: (BuildContext context, int index) =>
            itemBuilder(context, data, index),
        shrinkWrap: widget.shrinkWrap,
        reverse: widget.reverse,
      );
    }
    return withRefreshIndicator(listView);
  }

  Widget _sliverListView(List<T> data) {
    Widget? listView;

    if (data.isEmpty) {
      return widget.emptyListBuilder?.call(context) ??
          noItemsFound.sliverToBoxAdapter;
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
