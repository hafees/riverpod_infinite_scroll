// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_movies_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$searchMoviesHash() => r'7b65924147a2f2b865546563c0fc9549343350f5';

/// See also [SearchMovies].
@ProviderFor(SearchMovies)
final searchMoviesProvider =
    AutoDisposeAsyncNotifierProvider<SearchMovies, List<TmdbMovie>>.internal(
  SearchMovies.new,
  name: r'searchMoviesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$searchMoviesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SearchMovies = AutoDisposeAsyncNotifier<List<TmdbMovie>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
