import 'package:dio/dio.dart';
import 'package:example/src/env/env.dart';
import 'package:example/src/features/movies/data/tmdb_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tmdb_repository_provider.g.dart';

@Riverpod(keepAlive: true)
TmdbRepository tmdbRepository(
  TmdbRepositoryRef ref,
) {
  return TmdbRepository(
    dio: Dio(
      BaseOptions(
        baseUrl: 'https://api.themoviedb.org/3/',
        headers: <String, dynamic>{
          'Accept': 'application/json',
          'Authorization': 'Bearer ${Env.tmdbApiKey}',
        },
      ),
    ),
  );
}
