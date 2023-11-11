import 'package:freezed_annotation/freezed_annotation.dart';

part 'tmdb_movie.freezed.dart';
part 'tmdb_movie.g.dart';

@freezed
class TmdbMovie with _$TmdbMovie {
  factory TmdbMovie({
    bool? adult,
    @JsonKey(name: 'backdrop_path') String? backdropPath,
    int? id,
    @JsonKey(name: 'original_language') String? originalLanguage,
    @JsonKey(name: 'original_title') String? originalTitle,
    String? overview,
    double? popularity,
    @JsonKey(name: 'poster_path') String? posterPath,
    @JsonKey(name: 'release_date') String? releaseDate,
    String? title,
    bool? video,
    @JsonKey(name: 'vote_average') double? voteAverage,
    @JsonKey(name: 'vote_count') int? voteCount,
  }) = _TmdbMovie;

  factory TmdbMovie.fromJson(Map<String, dynamic> json) =>
      _$TmdbMovieFromJson(json);
}
