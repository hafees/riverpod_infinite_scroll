import 'package:flutter/widgets.dart';
import 'package:riverpod_infinite_scroll_pagination/riverpod_infinite_scroll_pagination.dart';
import 'package:riverpod_infinite_scroll_pagination/src/types/types.dart';

/// Holds the default settings for Infinite Scroll Pagination.
/// Include [InfiniteScrollPaginationConfig] widget as a parent in your widget
/// tree and all [PaginatedListView] and [PaginatedGridView] will use the
/// values as default.
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
class InfiniteScrollPaginationConfig extends InheritedWidget {
  const InfiniteScrollPaginationConfig({
    required super.child,
    this.loadingBuilder,
    this.initialLoadingBuilder,
    this.initialLoadingErrorBuilder,
    this.errorBuilder,
    this.emptyListBuilder,
    this.pullToRefresh = true,
    this.numSkeletons = 8,
    this.scrollDelta = 200,
    super.key,
  });

  ///Optional loading state builder. This widget will show inside the ListView.
  ///The builder will also receive the `Pagination` object and can be used to
  ///build more informative Widgets.
  ///By default a simple `CircularProgressIndicator.adaptive` is used.
  ///
  /// **Example**
  ///```dart
  ///loadingBuilder: (context, pagination) {
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
  final LoadingBuilder? loadingBuilder;

  ///The initial loading builder when there is no data.
  final InitialLoadingBuilder? initialLoadingBuilder;

  ///Optional error builder. Will be called when there is an error and has
  ///no existing data to show. The builder will receive the error object and
  /// stack trace. If omitted a generic error widget with a retry button
  ///  will be used
  final ErrorBuilder? initialLoadingErrorBuilder;

  /// Optional loading error builder. Will be called when there is an error
  /// but has existing data to show. The builder will receive the error object
  /// and stack trace. If omitted a generic error widget with a retry button
  ///  will be used
  ///
  final ErrorBuilder? errorBuilder;

  ///Optional builder to use when the data is empty even after querying
  ///If omitted, a default empty widget will be shown.
  final EmptyListBuilder? emptyListBuilder;

  /// Whether pull to refresh functionality is required. Ignored for slivers.
  final bool pullToRefresh;

  ///How many skeletons to show int the initial loading. Ignored if skeleton is
  ///not provide.
  final int numSkeletons;

  /// When to trigger the next page request. By default, next page request is
  /// triggered when there is only <=200 pixels to reach the end of scroll.
  final double scrollDelta;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static InfiniteScrollPaginationConfig? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InfiniteScrollPaginationConfig>();
  }
}
