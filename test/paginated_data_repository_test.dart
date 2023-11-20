import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_infinite_scroll_pagination/riverpod_infinite_scroll_pagination.dart';

import './dummy/dummy_data_provider.dart';

final dummyData = [
  DummyDataModel(title: 'Title 1', content: 'Content 1'),
  DummyDataModel(title: 'Title 2', content: 'Content 2'),
  DummyDataModel(title: 'Title 3', content: 'Content 3'),
  DummyDataModel(title: 'Title 4', content: 'Content 4'),
  DummyDataModel(title: 'Title 5', content: 'Content 5'),
  DummyDataModel(title: 'Title 6', content: 'Content 6'),
  DummyDataModel(title: 'Another Title 7', content: 'Content 7'),
  DummyDataModel(title: 'Another Title 8', content: 'Content 8'),
  DummyDataModel(title: 'Another Title 9', content: 'Content 9'),
  DummyDataModel(title: 'Another Title 10', content: 'Content 10'),
  DummyDataModel(title: 'Another Title 11', content: 'Content 11'),
  DummyDataModel(title: 'Another Title 12', content: 'Content 12'),
];

void main() {
  late PaginatedDataRepository<DummyDataModel> sut;
  late PaginatedDataRepository<DummyDataModel> sutWithQuery;

  setUp(() {
    sut = PaginatedDataRepository(
      fetcher: dataFetcher,
    );

    sutWithQuery = PaginatedDataRepository(
      fetcher: dataFetcher,
      queryFilter: 'Another Title',
    );
  });

  group('Tests on Paginated data repository', () {
    test('Check initialisation', () {
      expect(sut, isNotNull);
    });
    test('Check initially data is empty', () {
      expect(sut.data, isEmpty);
    });
    test(
        'When fetching there should be a loading state, and then'
        ' there should be data', () async {
      final future = sut.fetchData();
      expect(sut.isFetching, isTrue);
      await future;
      expect(sut.isFetching, isFalse);
      expect(sut.data, isNotEmpty);
    });
    test('After 1st fetch, there should be 5 data and canfetch should be true',
        () async {
      await sut.fetchData();
      expect(sut.data.length, equals(5));
      expect(sut.data[0], equals(dummyData[0]));
      expect(sut.data.last, equals(dummyData[4]));
      expect(sut.canFetch(), isTrue);
    });

    test(
        'After 1st fetch, pagination currentPage should be 1 and totalPages'
        ' should be 3', () async {
      await sut.fetchData();
      expect(sut.getPaginationData().currentPage, equals(1));
      expect(sut.getPaginationData().lastPage, equals(3));
      expect(sut.getPaginationData().totalNumber, equals(12));
    });

    test(
        'After 3 fetches there should be equal data as dummyData '
        'and [canFetch] should become false', () async {
      await sut.fetchData();
      await sut.fetchData();
      await sut.fetchData();
      expect(sut.getPaginationData().currentPage, equals(3));
      expect(sut.data.length, equals(dummyData.length));
      expect(sut.canFetch(), isFalse);
    });

    test('checking queryfilter', () async {
      await sutWithQuery.fetchData();
      expect(sutWithQuery.getPaginationData().currentPage, equals(1));
      expect(sutWithQuery.getPaginationData().lastPage, equals(2));
      expect(sutWithQuery.canFetch(), isTrue);
      await sutWithQuery.fetchData();
      expect(sutWithQuery.getPaginationData().totalNumber, equals(6));
      expect(sutWithQuery.canFetch(), isFalse);
    });
  });
}

Future<PaginatedResponse<DummyDataModel>> dataFetcher({
  int page = 1,
  String? query,
}) async {
  final filteredList = (query?.isNotEmpty ?? false)
      ? dummyData
          .where((element) => element.title?.contains(query!) ?? false)
          .toList()
      : dummyData;
  return PaginatedResponse(
    data: filteredList.sublist(
      (page - 1) * 5,
      min(page * 5, filteredList.length),
    ),
    pagination: Pagination(
      currentPage: page,
      lastPage: (filteredList.length / 5).ceil(),
      totalNumber: filteredList.length,
    ),
  );
}
