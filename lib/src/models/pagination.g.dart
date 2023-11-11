// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaginationImpl _$$PaginationImplFromJson(Map<String, dynamic> json) =>
    _$PaginationImpl(
      totalNumber: json['total_number'] as int? ?? 0,
      perPage: json['per_page'] as int? ?? 10,
      currentPage: json['current_page'] as int? ?? 1,
      lastPage: json['last_page'] as int? ?? 1,
    );

Map<String, dynamic> _$$PaginationImplToJson(_$PaginationImpl instance) =>
    <String, dynamic>{
      'total_number': instance.totalNumber,
      'per_page': instance.perPage,
      'current_page': instance.currentPage,
      'last_page': instance.lastPage,
    };
