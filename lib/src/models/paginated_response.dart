import 'package:riverpod_infinite_scroll/src/models/pagination.dart';

/// ## A generic Class to store with data and pagination
/// Binds data and pagination
/// Data repositories should use this class for returning data from requests
class PaginatedResponse<T> {
  const PaginatedResponse({
    this.data = const [],
    this.pagination,
  });

  /// A parser for converting data to models from json data
  /// Supports a `dataMapper` and `paginationParser` to correctly
  /// parse the data
  ///
  /// **Example**
  /// ```
  /// PaginatedResponse.fromJson(
  ///  results.data!,
  ///  dataMapper: TmdbMovie.fromJson,
  ///  dataField: 'results',
  ///  paginationParser: (data) => Pagination(
  ///    totalNumber: data['total_results'] as int,
  ///    currentPage: data['page'] as int,
  ///    lastPage: data['total_pages'] as int,
  ///  ),
  /// ```
  ///);
  factory PaginatedResponse.fromJson(
    /// The actual json data received
    Map<String, dynamic> json, {
    ///Data mapper for converting the data.
    ///
    ///If you are using freezed classed, the `fromJson` method can be used
    required T Function(Map<String, dynamic>) dataMapper,

    ///In the json data, identify the field of data.
    ///Defaults to *'data'*.
    ///For example, dataField is 'records' then the parser will try to get data
    ///from `json['records`]`
    String dataField = 'data',

    ///To extract the pagination data from the json data.
    ///
    ///**Example **
    ///
    Pagination Function(Map<String, dynamic> data)? paginationParser,
  }) {
    final jsonData = json[dataField] as List<dynamic>;
    final data =
        jsonData.map((e) => dataMapper(e as Map<String, dynamic>)).toList();

    return PaginatedResponse<T>(
      data: data,
      pagination: paginationParser?.call(json) ??
          Pagination.fromJson(json['pagination'] as Map<String, dynamic>),
    );
  }

  final List<T> data;
  final Pagination? pagination;
}
