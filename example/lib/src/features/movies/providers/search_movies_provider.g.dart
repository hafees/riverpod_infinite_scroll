// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_movies_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$searchMoviesHash() => r'cf2fd2b5f2005009e0cf26eed6fa90e1e7ef23fe';

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
