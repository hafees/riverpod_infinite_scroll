import 'package:example/src/features/movies/models/tmdb_config/tmdb_config.dart';
import 'package:example/src/features/movies/providers/tmdb_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tmdb_config_provider.g.dart';

@riverpod
FutureOr<TmdbConfig> tmdbConfig(TmdbConfigRef ref) async {
  return ref.watch(tmdbRepositoryProvider).getTmdbConfig();
}
