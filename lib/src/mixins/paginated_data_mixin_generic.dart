/// Part of riverpod infinite scroll library
library riverpod_infinite_scroll;

import 'dart:async';

import 'package:riverpod_infinite_scroll/riverpod_infinite_scroll.dart';
import 'package:riverpod_infinite_scroll/src/types/types.dart';

mixin PaginatedDataMixinGeneric<T> implements PaginatedNotifier<T> {
  List<T> _data = [];
  int _currentPage = 0;
  int _totalPages = 0;
  int _totalRecords = 0;
  bool _isFetching = false;
  String? queryFilter;
  PaginatedDataFetcher<T>? paginatedDataFetcher;

  @override
  bool hasData() {
    return _data.isNotEmpty;
  }

  @override
  bool canFetch() {
    return (_currentPage == 0 || _currentPage < _totalPages) && !_isFetching;
  }

  Future<List<T>> getData() async {
    assert(
      paginatedDataFetcher != null,
      'The method for accessing data is not initialized. '
      'Initialize paginatedDataFetcher',
    );
    _isFetching = true;
    try {
      final response = await paginatedDataFetcher?.call(
        page: _currentPage + 1,
        query: queryFilter,
      );

      _totalPages = response?.pagination?.lastPage ?? 1;
      _currentPage = response?.pagination?.currentPage ?? 0;
      _totalRecords = response?.pagination?.totalNumber ?? 0;

      if (response?.data != null) {
        _data = _currentPage > 1
            ? [..._data, ...response!.data]
            : [...response!.data];
      }
    } catch (_) {
      rethrow;
    } finally {
      _isFetching = false;
    }
    return _data;
  }

  @override
  List<T> getCurrentData() {
    return _data;
  }

  void resetData() {
    _data = [];
  }

  @override
  Pagination getPaginationData() {
    return Pagination(
      totalNumber: _totalRecords,
      currentPage: _currentPage,
      lastPage: _totalPages,
    );
  }

  void resetPagination({int? startPage}) {
    if (startPage != null && startPage > 0) {
      _currentPage = startPage - 1;
    } else {
      _currentPage = 0;
    }
    _totalPages = 0;
  }

  @override
  Future<void> setQueryFilter(String query) async {
    if (queryFilter != query) {
      resetData();
      queryFilter = query;
      await refresh();
    }
  }
}
