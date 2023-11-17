// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dummy_data_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dummyDataRepositoryHash() =>
    r'c717a6e34de7dd608685313846ef1645a61c3317';

/// See also [dummyDataRepository].
@ProviderFor(dummyDataRepository)
final dummyDataRepositoryProvider =
    AutoDisposeProvider<DummyDataRepository>.internal(
  dummyDataRepository,
  name: r'dummyDataRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dummyDataRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef DummyDataRepositoryRef = AutoDisposeProviderRef<DummyDataRepository>;
String _$dummyDataHash() => r'2abec4b0536b28742ce0dfe6685b453488234eba';

/// See also [DummyData].
@ProviderFor(DummyData)
final dummyDataProvider =
    AutoDisposeAsyncNotifierProvider<DummyData, List<DummyDataModel>>.internal(
  DummyData.new,
  name: r'dummyDataProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$dummyDataHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DummyData = AutoDisposeAsyncNotifier<List<DummyDataModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
