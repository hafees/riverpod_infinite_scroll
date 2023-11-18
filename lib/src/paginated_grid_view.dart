import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_infinite_scroll/riverpod_infinite_scroll.dart';
import 'package:riverpod_infinite_scroll/src/extensions/widget.dart';
import 'package:riverpod_infinite_scroll/src/mixins/paginated_grid_mixin.dart';

class PaginatedGridView<T> extends StatefulWidget {
  /// [GridView] or [SliverGrid] widget with automated pagination
  /// capabilities.
  ///
  /// Builds a [GridView] or [SliverGrid] widget with Infinite scroll pagination
  /// using Riverpod notifiers
  ///
  /// **Example**
  /// ```dart
  /// PaginatedGridView(
  ///   state: movies,
  ///   itemBuilder: (data) => MovieGridItem(movie: data),
  ///   notifier: ref.read(searchMoviesProvider.notifier),
  ///   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  ///     childAspectRatio: 1 / 1.22,
  ///     crossAxisCount: 2,
  ///     crossAxisSpacing: 10,
  ///     mainAxisSpacing: 10,
  ///   ),
  ///   useSliverGrid: true,
  ///   customScrollController: controller,
  /// );
  /// ```
  ///
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
    this.pullToRefresh = true,
    this.shrinkWrap = false,
    this.reverse = false,
    this.useSliver = false,
    this.scrollController,
    this.scrollDelta,
  }) : assert(
          !(useSliver && scrollController == null),
          'ScrollController required for Slivers. '
          'You should also assign this scrollController to your'
          ' CustomScrollView widget',
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

  ///Low level grid view builder. Don't need to use in normal cases.
  ///Only useful, if you want to completely build the list yourself(May be
  ///using a custom widget)
  final Widget Function(
    BuildContext context,
    List<T> data,
  )? gridListBuilder;

  /// Same as the SliverList gridDelegate
  final SliverGridDelegate gridDelegate;

  /// If supplied, a skeleton loading animation will be showed initially. You
  /// just need to pass the item widget with some dummy data. A skeleton will be
  /// created automatically using *skeletonizer* library
  final Widget? skeleton;

  ///How many skeletons to show int the initial loading. Ignored if skeleton is
  ///not provide.
  final int numSkeletons;

  /// The scroll direction. Defaults to [Axis.vertical]
  final Axis scrollDirection;

  /// Whether pull to refresh functionality is required. Ignored for slivers.
  final bool pullToRefresh;

  /// If true, a SliverGrid ([SliverGrid.builder]) is returned.
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
  State<PaginatedGridView<T>> createState() => _PaginatedGridViewState<T>();
}

class _PaginatedGridViewState<T> extends State<PaginatedGridView<T>>
    with PaginatedScrollController, PaginatedGridMixin {
  @override
  void initState() {
    if (widget.scrollController != null) {
      scrollController = widget.scrollController!;
      scrollControllerAutoDispose = false;
    }
    scrollController = widget.scrollController ?? scrollController;
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

    return widget.useSliver ? _sliverGridList(data) : _gridList(data);
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
      reverse: widget.reverse,
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
