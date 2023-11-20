/// Part of riverpod infinite scroll library
library riverpod_infinite_scroll_pagination;

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_infinite_scroll_pagination/riverpod_infinite_scroll_pagination.dart';

///Mixin for default AsyncNotifiers (`AutoDisposeAsyncNotifier`)
///(Providers created with `@riverpod`)
mixin PaginatedDataMixin<T> on AutoDisposeAsyncNotifier<List<T>>
    implements PaginatedNotifier<T> {
  String? queryFilter;
  late PaginatedDataRepository<T>? _dataFetcher;

  ///This method should be called inside the `build` method of your provider
  ///to initialize the pagination, state and
  ///data fetching.
  ///
  ///**Example**
  /// ```dart
  /// @override
  /// FutureOr<List<TmdbMovie>> build() async {
  ///   return init(
  ///     dataFetcher: PaginatedDataRepository(
  ///       fetcher: ref.watch(tmdbRepositoryProvider).getTrendingMovies,
  ///     ),
  ///   );
  /// }
  /// ```
  Future<List<T>> init({
    required PaginatedDataRepository<T> dataFetcher,
  }) async {
    _dataFetcher = dataFetcher;
    state = const AsyncLoading();
    return _dataFetcher!.fetchData();
  }

  @override

  /// checks whether data exists.
  /// Overrides form `PaginatedNotifier` Interface
  ///
  /// You may override this in your notifiers
  bool hasData() {
    return _dataFetcher!.data.isNotEmpty;
  }

  @override

  /// checks whether new data can be fetched.
  /// Overrides form `PaginatedNotifier` interface
  ///
  /// You may override this in your notifiers
  bool canFetch() {
    return _dataFetcher!.canFetch();
  }

  @override

  ///Gets already available data.
  /// Overrides form `PaginatedNotifier` interface
  ///
  /// You may override this in your notifiers
  List<T> getCurrentData() {
    return _dataFetcher!.data;
  }

  @override

  ///Gets the pagination data.
  /// Overrides form `PaginatedNotifier` interface
  ///
  /// You may override this in your notifiers
  Pagination getPaginationData() {
    return _dataFetcher!.getPaginationData();
  }

  @override

  ///Gets the next page of data by querying repository
  ///and sets the state
  ///
  /// Overrides form `PaginatedNotifier` interface
  ///
  /// You may override this in your notifiers
  Future<void> getNextPage() async {
    state = const AsyncLoading();
    state = AsyncData(await _dataFetcher!.fetchData());
  }

  @override

  /// Refreshes notifier without emptying data. Useful for implementing
  /// pull to refresh functionality
  /// Automatically invoked  if `pullToRefresh` is true
  ///
  ///You can also call it manually using `notifier`
  ///Example
  ///```
  ///ref.read(searchMoviesProvider.notifier).refresh();
  ///```
  /// You may override this in your notifiers
  Future<void> refresh() async {
    _dataFetcher?.resetPagination();
    state = AsyncData(await _dataFetcher!.fetchData());
  }

  @override

  ///Use this to set any query params. The set value will be passed to the
  ///`fetcher`.
  /// Waits for the future.
  ///
  ///You can also call it manually using `notifier`
  ///Example
  ///```
  ///ref.read(searchMoviesProvider.notifier).setQueryFilter('search=Matrix');
  ///```
  /// You may override this in your notifiers
  Future<void> setQueryFilter(String query) async {
    if (queryFilter != query) {
      queryFilter = query;
      state = const AsyncLoading();
      ref.invalidateSelf();
      await future;
    }
  }
}
