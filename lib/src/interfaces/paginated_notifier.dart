/// Part of riverpod infinite scroll library
library riverpod_infinite_scroll;

abstract interface class PaginatedNotifier<T> {
  Future<void> getNextPage();
  bool canFetch();
  bool hasData();
  List<T> getCurrentData();
  Future<void> refresh();
  Future<void> setQueryFilter(String query);
}
