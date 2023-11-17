import 'package:dio/dio.dart';
import 'package:example/src/features/movies/models/tmdb_config/tmdb_config.dart';
import 'package:example/src/features/movies/models/tmdb_movie/tmdb_movie.dart';
import 'package:riverpod_infinite_scroll/riverpod_infinite_scroll.dart';

class TmdbRepository {
  const TmdbRepository({
    required this.dio,
  });
  final Dio dio;

  Future<PaginatedResponse<TmdbMovie>> getTrendingMovies({
    int page = 1,
    String? query,
  }) async {
    await Future<void>.delayed(const Duration(seconds: 12));
    final results = await dio.get<Map<String, dynamic>>(
      'trending/movie/day?language=en-US&page=$page${query != null ? '&$query' : ''}',
    );
    return PaginatedResponse.fromJson(
      results.data!,
      dataMapper: TmdbMovie.fromJson,
      dataField: 'results',
      paginationParser: (data) => Pagination(
        totalNumber: data['total_results'] as int,
        currentPage: data['page'] as int,
        lastPage: data['total_pages'] as int,
      ),
    );
  }

  Future<PaginatedResponse<TmdbMovie>> searchMovies({
    int page = 1,
    String? query = '',
  }) async {
    await Future<void>.delayed(const Duration(seconds: 12));
    final results = await dio.get<Map<String, dynamic>>(
      'search/movie?query=$query&include_adult=false&page=$page',
    );
    await Future.delayed(const Duration(seconds: 1), () {});
    return PaginatedResponse.fromJson(
      results.data!,
      dataMapper: TmdbMovie.fromJson,
      dataField: 'results',
      paginationParser: (data) => Pagination(
        totalNumber: data['total_results'] as int,
        currentPage: data['page'] as int,
        lastPage: data['total_pages'] as int,
      ),
    );
  }

  Future<TmdbConfig> getTmdbConfig() async {
    final results = await dio.get<Map<String, dynamic>>(
      'configuration',
    );
    return TmdbConfig.fromJson(results.data!);
  }
}
