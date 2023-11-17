import 'package:riverpod_infinite_scroll/riverpod_infinite_scroll.dart';

///Defines the data fetcher method type
typedef PaginatedDataFetcher<T> = Future<PaginatedResponse<T>> Function({
  required int page,
  String? query,
});
