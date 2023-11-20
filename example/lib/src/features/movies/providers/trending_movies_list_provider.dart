import 'package:example/src/features/movies/models/tmdb_movie/tmdb_movie.dart';
import 'package:example/src/features/movies/providers/tmdb_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_infinite_scroll_pagination/riverpod_infinite_scroll_pagination.dart';

part 'trending_movies_list_provider.g.dart';

@riverpod
class TrendingMoviesList extends _$TrendingMoviesList
    with PaginatedDataMixin<TmdbMovie>
    implements PaginatedNotifier<TmdbMovie> {
  @override
  FutureOr<List<TmdbMovie>> build() async {
    return init(
      dataFetcher: PaginatedDataRepository(
        fetcher: ref.watch(tmdbRepositoryProvider).getTrendingMovies,
      ),
    );
  }
}
