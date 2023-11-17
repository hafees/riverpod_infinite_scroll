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
    final dataFetcher = PaginatedDataRepository(
      fetcher: (queryFilter == null || queryFilter!.isEmpty)
          ? ref.watch(tmdbRepositoryProvider).getTrendingMovies
          : ref.watch(tmdbRepositoryProvider).searchMovies,
      queryFilter: queryFilter,
    );

    return init(
      dataFetcher: dataFetcher,
    );
  }
}
