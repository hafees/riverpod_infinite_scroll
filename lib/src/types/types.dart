import 'package:riverpod_infinite_scroll_pagination/riverpod_infinite_scroll_pagination.dart';

///Defines the data fetcher method type
typedef PaginatedDataFetcher<T> = Future<PaginatedResponse<T>> Function({
  required int page,
  String? query,
});
