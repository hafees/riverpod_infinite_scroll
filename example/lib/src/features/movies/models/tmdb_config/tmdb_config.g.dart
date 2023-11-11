// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tmdb_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TmdbConfigImpl _$$TmdbConfigImplFromJson(Map<String, dynamic> json) =>
    _$TmdbConfigImpl(
      images: json['images'] == null
          ? null
          : Images.fromJson(json['images'] as Map<String, dynamic>),
      changeKeys: (json['change_keys'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$TmdbConfigImplToJson(_$TmdbConfigImpl instance) =>
    <String, dynamic>{
      'images': instance.images,
      'change_keys': instance.changeKeys,
    };
