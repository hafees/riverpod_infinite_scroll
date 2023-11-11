import 'package:example/src/features/movies/models/tmdb_movie/tmdb_movie.dart';
import 'package:example/src/features/movies/providers/tmdb_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_infinite_scroll/riverpod_infinite_scroll.dart';

part 'search_movies_provider.g.dart';

@riverpod
class SearchMovies extends _$SearchMovies
    with PaginatedDataMixin<TmdbMovie>
    implements PaginatedNotifier<TmdbMovie> {
  @override
  FutureOr<List<TmdbMovie>> build() async {
    state = const AsyncLoading();
    paginatedDataFetcher = ref.watch(tmdbRepositoryProvider).searchMovies;
    return await getData();
  }

  @override
  Future<void> getNextPage() async {
    state = const AsyncLoading();
    state = AsyncData(await getData());
  }

  @override
  Future<void> refresh() async {
    resetPagination();
    ref.invalidateSelf();
    await future;
  }

  @override
  Future<void> setQueryFilter(String query) async {
    if (queryFilter != query) {
      queryFilter = query;
      state = const AsyncLoading();
      await refresh();
    }
  }
}
