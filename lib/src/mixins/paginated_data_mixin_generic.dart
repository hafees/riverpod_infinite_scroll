/// Part of riverpod infinite scroll library
library riverpod_infinite_scroll_pagination;

import 'dart:async';

import 'package:riverpod_infinite_scroll_pagination/riverpod_infinite_scroll_pagination.dart';

/// Mixin for default AsyncNotifiers that needs to accept params in build method
/// You will need to change state manually
mixin PaginatedDataMixinGeneric<T> implements PaginatedNotifier<T> {
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

  /// Reloads the data. Resets the pagination and fetches the data again.
  /// You can then get the data by calling `getCurrentData()`
  Future<List<T>> reloadData() async {
    _dataFetcher?.resetPagination();
    return _dataFetcher!.fetchData();
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

  Future<void> setQueryFilter(String query) async {
    if (queryFilter != query) {
      queryFilter = query;
    }
  }

  ///Initiates data fetching.
  ///
  ///The fetched data need to be assigned to your state manually.
  ///
  ///Example: `state = AsyncData(await fetchData());`
  Future<List<T>> fetchData() async {
    await _dataFetcher!.fetchData();
    return _dataFetcher!.data;
  }
}
