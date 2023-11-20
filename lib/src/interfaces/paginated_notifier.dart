import 'package:riverpod_infinite_scroll_pagination/riverpod_infinite_scroll_pagination.dart';

///Abstract class for defining the the Notifier interface.
///Each provider should implement this class
abstract interface class PaginatedNotifier<T> {
  Future<void> getNextPage();
  bool canFetch();
  bool hasData();
  List<T> getCurrentData();
  Pagination getPaginationData();
  Future<void> refresh();
  Future<void> setQueryFilter(String query);
}
