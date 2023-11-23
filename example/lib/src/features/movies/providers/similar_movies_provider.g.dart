// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'similar_movies_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$similarMoviesHash() => r'cdb557ffb9f951f12939ddfc25f0ca53427e5919';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$SimilarMovies
    extends BuildlessAutoDisposeAsyncNotifier<List<TmdbMovie>> {
  late final int movieId;

  FutureOr<List<TmdbMovie>> build(
    int movieId,
  );
}

/// See also [SimilarMovies].
@ProviderFor(SimilarMovies)
const similarMoviesProvider = SimilarMoviesFamily();

/// See also [SimilarMovies].
class SimilarMoviesFamily extends Family<AsyncValue<List<TmdbMovie>>> {
  /// See also [SimilarMovies].
  const SimilarMoviesFamily();

  /// See also [SimilarMovies].
  SimilarMoviesProvider call(
    int movieId,
  ) {
    return SimilarMoviesProvider(
      movieId,
    );
  }

  @override
  SimilarMoviesProvider getProviderOverride(
    covariant SimilarMoviesProvider provider,
  ) {
    return call(
      provider.movieId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'similarMoviesProvider';
}

/// See also [SimilarMovies].
class SimilarMoviesProvider extends AutoDisposeAsyncNotifierProviderImpl<
    SimilarMovies, List<TmdbMovie>> {
  /// See also [SimilarMovies].
  SimilarMoviesProvider(
    int movieId,
  ) : this._internal(
          () => SimilarMovies()..movieId = movieId,
          from: similarMoviesProvider,
          name: r'similarMoviesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$similarMoviesHash,
          dependencies: SimilarMoviesFamily._dependencies,
          allTransitiveDependencies:
              SimilarMoviesFamily._allTransitiveDependencies,
          movieId: movieId,
        );

  SimilarMoviesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.movieId,
  }) : super.internal();

  final int movieId;

  @override
  FutureOr<List<TmdbMovie>> runNotifierBuild(
    covariant SimilarMovies notifier,
  ) {
    return notifier.build(
      movieId,
    );
  }

  @override
  Override overrideWith(SimilarMovies Function() create) {
    return ProviderOverride(
      origin: this,
      override: SimilarMoviesProvider._internal(
        () => create()..movieId = movieId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        movieId: movieId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<SimilarMovies, List<TmdbMovie>>
      createElement() {
    return _SimilarMoviesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SimilarMoviesProvider && other.movieId == movieId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, movieId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SimilarMoviesRef on AutoDisposeAsyncNotifierProviderRef<List<TmdbMovie>> {
  /// The parameter `movieId` of this provider.
  int get movieId;
}

class _SimilarMoviesProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<SimilarMovies,
        List<TmdbMovie>> with SimilarMoviesRef {
  _SimilarMoviesProviderElement(super.provider);

  @override
  int get movieId => (origin as SimilarMoviesProvider).movieId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
