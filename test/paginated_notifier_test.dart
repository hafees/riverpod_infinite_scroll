import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_infinite_scroll/riverpod_infinite_scroll.dart';

import './dummy/dummy_data_provider.dart';
import 'container/container.dart';

class MockedDummyDataRepository extends Mock implements DummyDataRepository {
  @override
  Future<PaginatedResponse<DummyDataModel>> getPaginatedData({
    int page = 1,
    String? query,
  }) async {
    return PaginatedResponse(data: [], pagination: Pagination());
  }
}

void main() {
  late ProviderContainer container;
  late DummyData notifier;
  late MockedDummyDataRepository mockedDummyDataRepository;
  setUp(() {
    mockedDummyDataRepository = MockedDummyDataRepository();
    container = createContainer(
      overrides: [
        dummyDataRepositoryProvider
            .overrideWith((ref) => mockedDummyDataRepository),
      ],
    );
    notifier = container.read(dummyDataProvider.notifier);
  });

  group('Tests on Repository and Model', () {
    test('Check test classes exist', () async {
      final dummyData = DummyDataModel();

      expect(dummyData, isNotNull);
    });

    test('Check dummy data repository is a mocked repository', () async {
      final dummyDataRepository = container.read(dummyDataRepositoryProvider);
      expect(dummyDataRepository, isA<Mock>());
      expect(dummyDataRepository, isA<DummyDataRepository>());
      expect(dummyDataRepository.getPaginatedData(), isA<Function>);
    });
  });

  group('Tests on Notifier', () {
    test('check the dummy provider exists', () async {
      final result = container.read(dummyDataProvider);
      expect(result, isA<AsyncValue<List<DummyDataModel>>>());
      expect(notifier, isA<DummyData>());
    });

    test('Check pagination is correct', () async {
      final pagination = notifier.getPaginationData();

      expect(
        pagination,
        isA<Pagination>(),
      );

      expect(pagination.currentPage, 1);

      final data = notifier.getCurrentData();
      expect(data, isA<List<DummyDataModel>>());
    });
  });
}
