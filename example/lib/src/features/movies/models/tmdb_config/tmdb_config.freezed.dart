// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tmdb_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

TmdbConfig _$TmdbConfigFromJson(Map<String, dynamic> json) {
  return _TmdbConfig.fromJson(json);
}

/// @nodoc
mixin _$TmdbConfig {
  Images? get images => throw _privateConstructorUsedError;
  @JsonKey(name: 'change_keys')
  List<String>? get changeKeys => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TmdbConfigCopyWith<TmdbConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TmdbConfigCopyWith<$Res> {
  factory $TmdbConfigCopyWith(
          TmdbConfig value, $Res Function(TmdbConfig) then) =
      _$TmdbConfigCopyWithImpl<$Res, TmdbConfig>;
  @useResult
  $Res call(
      {Images? images, @JsonKey(name: 'change_keys') List<String>? changeKeys});

  $ImagesCopyWith<$Res>? get images;
}

/// @nodoc
class _$TmdbConfigCopyWithImpl<$Res, $Val extends TmdbConfig>
    implements $TmdbConfigCopyWith<$Res> {
  _$TmdbConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? images = freezed,
    Object? changeKeys = freezed,
  }) {
    return _then(_value.copyWith(
      images: freezed == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as Images?,
      changeKeys: freezed == changeKeys
          ? _value.changeKeys
          : changeKeys // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ImagesCopyWith<$Res>? get images {
    if (_value.images == null) {
      return null;
    }

    return $ImagesCopyWith<$Res>(_value.images!, (value) {
      return _then(_value.copyWith(images: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TmdbConfigImplCopyWith<$Res>
    implements $TmdbConfigCopyWith<$Res> {
  factory _$$TmdbConfigImplCopyWith(
          _$TmdbConfigImpl value, $Res Function(_$TmdbConfigImpl) then) =
      __$$TmdbConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Images? images, @JsonKey(name: 'change_keys') List<String>? changeKeys});

  @override
  $ImagesCopyWith<$Res>? get images;
}

/// @nodoc
class __$$TmdbConfigImplCopyWithImpl<$Res>
    extends _$TmdbConfigCopyWithImpl<$Res, _$TmdbConfigImpl>
    implements _$$TmdbConfigImplCopyWith<$Res> {
  __$$TmdbConfigImplCopyWithImpl(
      _$TmdbConfigImpl _value, $Res Function(_$TmdbConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? images = freezed,
    Object? changeKeys = freezed,
  }) {
    return _then(_$TmdbConfigImpl(
      images: freezed == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as Images?,
      changeKeys: freezed == changeKeys
          ? _value._changeKeys
          : changeKeys // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TmdbConfigImpl implements _TmdbConfig {
  _$TmdbConfigImpl(
      {this.images,
      @JsonKey(name: 'change_keys') final List<String>? changeKeys})
      : _changeKeys = changeKeys;

  factory _$TmdbConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$TmdbConfigImplFromJson(json);

  @override
  final Images? images;
  final List<String>? _changeKeys;
  @override
  @JsonKey(name: 'change_keys')
  List<String>? get changeKeys {
    final value = _changeKeys;
    if (value == null) return null;
    if (_changeKeys is EqualUnmodifiableListView) return _changeKeys;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'TmdbConfig(images: $images, changeKeys: $changeKeys)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TmdbConfigImpl &&
            (identical(other.images, images) || other.images == images) &&
            const DeepCollectionEquality()
                .equals(other._changeKeys, _changeKeys));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, images, const DeepCollectionEquality().hash(_changeKeys));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TmdbConfigImplCopyWith<_$TmdbConfigImpl> get copyWith =>
      __$$TmdbConfigImplCopyWithImpl<_$TmdbConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TmdbConfigImplToJson(
      this,
    );
  }
}

abstract class _TmdbConfig implements TmdbConfig {
  factory _TmdbConfig(
          {final Images? images,
          @JsonKey(name: 'change_keys') final List<String>? changeKeys}) =
      _$TmdbConfigImpl;

  factory _TmdbConfig.fromJson(Map<String, dynamic> json) =
      _$TmdbConfigImpl.fromJson;

  @override
  Images? get images;
  @override
  @JsonKey(name: 'change_keys')
  List<String>? get changeKeys;
  @override
  @JsonKey(ignore: true)
  _$$TmdbConfigImplCopyWith<_$TmdbConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
