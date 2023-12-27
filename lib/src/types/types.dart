import 'package:flutter/widgets.dart';
import 'package:riverpod_infinite_scroll_pagination/riverpod_infinite_scroll_pagination.dart';

///Defines the data fetcher method type
typedef PaginatedDataFetcher<T> = Future<PaginatedResponse<T>> Function({
  required int page,
  String? query,
});

typedef EmptyListBuilder = Widget Function(BuildContext context);
typedef ErrorBuilder = Widget Function(
  BuildContext context,
  Object error,
  StackTrace stackTrace,
);
typedef LoadingBuilder = Widget Function(
  BuildContext context,
  Pagination pagination,
);

typedef InitialLoadingBuilder = Widget Function(
  BuildContext context,
);
