import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination.freezed.dart';
part 'pagination.g.dart';

@freezed
class Pagination with _$Pagination {
  factory Pagination({
    @JsonKey(name: 'total_number') @Default(0) int totalNumber,
    @JsonKey(name: 'per_page') @Default(10) int perPage,
    @JsonKey(name: 'current_page') @Default(1) int currentPage,
    @JsonKey(name: 'last_page') @Default(1) int lastPage,
  }) = _Pagination;

  factory Pagination.fromJson(Map<String, dynamic> json) =>
      _$PaginationFromJson(json);
}
