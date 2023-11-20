import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_infinite_scroll_pagination/riverpod_infinite_scroll_pagination.dart';

part 'dummy_data_provider.g.dart';

class DummyDataModel {
  DummyDataModel({this.title, this.content});

  final String? title;
  final String? content;
}

class DummyDataRepository {
  Future<PaginatedResponse<DummyDataModel>> getPaginatedData({
    int page = 1,
    String? query,
  }) async {
    return PaginatedResponse<DummyDataModel>(
      data: [],
      pagination: Pagination(currentPage: page, lastPage: 10),
    );
  }
}

@riverpod
DummyDataRepository dummyDataRepository(DummyDataRepositoryRef ref) {
  return DummyDataRepository();
}

@riverpod
class DummyData extends _$DummyData
    with PaginatedDataMixin<DummyDataModel>
    implements PaginatedNotifier<DummyDataModel> {
  @override
  FutureOr<List<DummyDataModel>> build() async {
    state = const AsyncLoading();
    return init(
      dataFetcher: PaginatedDataRepository(
        fetcher: ref.watch(dummyDataRepositoryProvider).getPaginatedData,
      ),
    );
  }
}
