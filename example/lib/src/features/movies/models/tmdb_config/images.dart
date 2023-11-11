import 'package:freezed_annotation/freezed_annotation.dart';

part 'images.freezed.dart';
part 'images.g.dart';

@freezed
class Images with _$Images {
  factory Images({
    @JsonKey(name: 'base_url') String? baseUrl,
    @JsonKey(name: 'secure_base_url') String? secureBaseUrl,
    @JsonKey(name: 'backdrop_sizes') List<String>? backdropSizes,
    @JsonKey(name: 'logo_sizes') List<String>? logoSizes,
    @JsonKey(name: 'poster_sizes') List<String>? posterSizes,
    @JsonKey(name: 'profile_sizes') List<String>? profileSizes,
    @JsonKey(name: 'still_sizes') List<String>? stillSizes,
  }) = _Images;

  factory Images.fromJson(Map<String, dynamic> json) => _$ImagesFromJson(json);
}
