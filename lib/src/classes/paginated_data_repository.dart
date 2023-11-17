import 'package:riverpod_infinite_scroll/riverpod_infinite_scroll.dart';
import 'package:riverpod_infinite_scroll/src/types/types.dart';

/// # Queries and stores paginated data
/// Can store data successively and returns full set of data when required.
/// Automatically manages pagination of requests.
///
/// **Example**
/// ```dart
/// PaginatedDataRepository(
///   fetcher: ref.watch(tmdbRepositoryProvider).getTrendingMovies,
/// )
///
/// ```
/// **Example without a separate repository**
/// ```dart
/// PaginatedDataRepository(
///   fetcher: ({int page = 1, String? query}) async {
///     final results = await dio.get<Map<String, dynamic>>(
///       'search/movie?query=$query&include_adult=false&page=$page',
///     );
///     return PaginatedResponse.fromJson(
///       results.data!,
///       dataMapper: TmdbMovie.fromJson,
///       dataField: 'results',
///       paginationParser: (data) => Pagination(
///         totalNumber: data['total_results'] as int,
///         currentPage: data['page'] as int,
///         lastPage: data['total_pages'] as int,
///       ),
///     );
///   },
/// );
///
/// ```
class PaginatedDataRepository<T> {
  PaginatedDataRepository({
    required this.fetcher,
    this.queryFilter,
    this.startPage = 1,
  }) : assert(startPage >= 1, 'Start page should be >= 1');

  ///The fetching function. You can initialize it with your repository method.
  ///or define a function directly. This way you don't need to create
  ///data repositories.
  /// **Example**
  /// ```dart
  /// PaginatedDataRepository(
  ///   fetcher: ({int page = 1, String? query}) async {
  ///     final results = await dio.get<Map<String, dynamic>>(
  ///       'search/movie?query=$query&include_adult=false&page=$page',
  ///     );
  ///     return PaginatedResponse.fromJson(
  ///       results.data!,
  ///       dataMapper: TmdbMovie.fromJson,
  ///       dataField: 'results',
  ///       paginationParser: (data) => Pagination(
  ///         totalNumber: data['total_results'] as int,
  ///         currentPage: data['page'] as int,
  ///         lastPage: data['total_pages'] as int,
  ///       ),
  ///     );
  ///   },
  /// );
  ///
  /// ```
  final PaginatedDataFetcher<T> fetcher;

  ///Optional query filter. This will be provided to the `fetcher` function
  ///and you can use it to build your URL
  final String? queryFilter;

  /// If you want to query data by skipping a few pages.
  /// Defaults to 1 and **should be > 0**. This will be provided to the
  /// the `fetcher` function as `page` parameter
  final int startPage;

  List<T> _data = [];
  late int _currentPage =
      startPage - 1; //_currentPage is incremented before fetching
  int _totalRecords = 0;
  int _totalPages = 0;
  bool _isFetching = false;

  /// Gets the stored data
  List<T> get data {
    return _data;
  }

  /// Checks whether is already fetching
  bool get isFetching {
    return _isFetching;
  }

  /// Checks whether next page can be requested.
  /// Returns `true` if not fetching and is not already on the last page.
  bool canFetch() {
    return (_currentPage == 0 || _currentPage < _totalPages) && !_isFetching;
  }

  ///Fetches new data and returns the whole data using the supplied
  ///`fetcher` method.
  /// `page` and `query` is passed to the `fetcher` method
  /// If the last page is already fetched, no requests will be made and
  /// the existing data will be returned
  Future<List<T>> fetchData() async {
    if (canFetch()) {
      _isFetching = true;
      try {
        final response = await fetcher.call(
          page: _currentPage + 1,
          query: queryFilter,
        );

        _totalPages = response.pagination?.lastPage ?? 1;
        _currentPage = response.pagination?.currentPage ?? 0;
        _totalRecords = response.pagination?.totalNumber ?? 0;

        _data = _currentPage > 1
            ? [..._data, ...response.data]
            : [...response.data];
      } catch (_) {
        rethrow;
      } finally {
        _isFetching = false;
      }
    }

    return _data;
  }

  /// Resets pagination to defaults so that you can refetch the data
  /// Already stored data is not destroyed until new data is received
  void resetPagination({int? startPage}) {
    if (startPage != null && startPage > 0) {
      _currentPage = startPage - 1;
    } else {
      _currentPage = 0;
    }
    _totalPages = 0;
  }

  /// Returns the current [Pagination] data
  Pagination getPaginationData() {
    return Pagination(
      totalNumber: _totalRecords,
      currentPage: _currentPage,
      lastPage: _totalPages,
    );
  }
}
