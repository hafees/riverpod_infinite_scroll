import 'package:example/src/features/movies/models/tmdb_movie/tmdb_movie.dart';
import 'package:example/src/features/movies/providers/tmdb_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_infinite_scroll_pagination/riverpod_infinite_scroll_pagination.dart';

part 'similar_movies_provider.g.dart';

@riverpod
class SimilarMovies extends _$SimilarMovies
    with PaginatedDataMixinGeneric<TmdbMovie>
    implements PaginatedNotifier<TmdbMovie> {
  @override
  FutureOr<List<TmdbMovie>> build(int movieId) async {
    state = const AsyncValue.loading();
    return await init(
      dataFetcher: PaginatedDataRepository(
        fetcher: ({int page = 1, String? query}) async {
          return ref
              .watch(tmdbRepositoryProvider)
              .getSimilarMovies(movieId: movieId, page: page, query: query);
        },
        queryFilter: movieId.toString(),
      ),
    );
  }

  @override
  Future<void> getNextPage() async {
    state = const AsyncLoading();
    state = AsyncData(await fetchData());
  }

  @override
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = AsyncData(await reloadData());
  }
}
