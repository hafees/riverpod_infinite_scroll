// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trending_movies_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$trendingMoviesListHash() =>
    r'2ed2663049826d81fd6f788ed422e5afecc1ebe1';

/// See also [TrendingMoviesList].
@ProviderFor(TrendingMoviesList)
final trendingMoviesListProvider = AutoDisposeAsyncNotifierProvider<
    TrendingMoviesList, List<TmdbMovie>>.internal(
  TrendingMoviesList.new,
  name: r'trendingMoviesListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$trendingMoviesListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TrendingMoviesList = AutoDisposeAsyncNotifier<List<TmdbMovie>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
