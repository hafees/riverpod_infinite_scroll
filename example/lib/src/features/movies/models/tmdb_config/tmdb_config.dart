import 'package:example/src/features/movies/models/tmdb_config/images.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tmdb_config.freezed.dart';
part 'tmdb_config.g.dart';

@freezed
class TmdbConfig with _$TmdbConfig {
  factory TmdbConfig({
    Images? images,
    @JsonKey(name: 'change_keys') List<String>? changeKeys,
  }) = _TmdbConfig;

  factory TmdbConfig.fromJson(Map<String, dynamic> json) =>
      _$TmdbConfigFromJson(json);
}
