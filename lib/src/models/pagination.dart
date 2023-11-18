import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination.freezed.dart';
part 'pagination.g.dart';

@freezed

/// A simple class to store pagination data
/// Used in `PaginatedResponse` class
class Pagination with _$Pagination {
  factory Pagination({
    /// total number of records
    @JsonKey(name: 'total_number') @Default(0) int totalNumber,

    /// the currently requested page
    @JsonKey(name: 'current_page') @Default(1) int currentPage,

    /// number of total pages
    @JsonKey(name: 'last_page') @Default(1) int lastPage,
  }) = _Pagination;

  factory Pagination.fromJson(Map<String, dynamic> json) =>
      _$PaginationFromJson(json);
}
