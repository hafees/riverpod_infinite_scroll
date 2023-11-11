import 'package:riverpod_infinite_scroll/src/models/pagination.dart';

class PaginatedResponse<T> {
  const PaginatedResponse({
    this.data = const [],
    this.pagination,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json, {
    required T Function(Map<String, dynamic>) dataMapper,
    String dataField = 'data',
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
