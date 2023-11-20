# Coding Examples
You can see various examples for getting started with the package. Also, you can check the example project in the repository. The code snippets are taken from that project.

## Model class and Repository
Here we need to show movie information from TMDB. So our model class is creatd using `freezed` package.

```dart
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

```

Our repository has a method to fetch the trending movies list.

 ```dart
 class TmdbRepository {
  const TmdbRepository({
    required this.dio,
  });
  final Dio dio;

  Future<PaginatedResponse<TmdbMovie>> getTrendingMovies({
    int page = 1,
    String? query,
  }) async {
    final results = await dio.get<Map<String, dynamic>>(
      'trending/movie/day?language=en-US&page=$page${query != null ? '&$query' : ''}',
    );
    return PaginatedResponse.fromJson(
      results.data!,
      dataMapper: TmdbMovie.fromJson,
      dataField: 'results',
      paginationParser: (data) => Pagination(
        totalNumber: data['total_results'] as int,
        currentPage: data['page'] as int,
        lastPage: data['total_pages'] as int,
      ),
    );
  }
}

```
**Key things to note:**
1. The repository method accepts two named parameters - `page` and an optional `query`. We use this parameters in our API request.
2. We are using a `PaginatedResponse` class. It is a simple class used to wrap the data and pagination information. 
3.  It has a `fromJson` method which accepts the json raw data, the `dataMapper` method for converting Json data to our [TmdbMovie] model, `dataField` to identify the data from Json data (TMDB API returns paginated data in the `results` field)

We have created a provider for getting the instance of this repository.

```dart
import 'package:dio/dio.dart';
import 'package:example/src/env/env.dart';
import 'package:example/src/features/movies/data/tmdb_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tmdb_repository_provider.g.dart';

@riverpod
TmdbRepository tmdbRepository(
  TmdbRepositoryRef ref,
) {
  return TmdbRepository(
    dio: Dio(
      BaseOptions(
        baseUrl: 'https://api.themoviedb.org/3/',
        headers: <String, dynamic>{
          'Accept': 'application/json',
          'Authorization': 'Bearer ${Env.tmdbApiKey}',
        },
      ),
    ),
  );
}
```
Here we initialise the `dio` instance with necessary headers. We're using the `envied` package to store API key safely.

## A simple provider
This is enough when you only require to show a list of items. You don't have to do any filtering logic.

In this example, we need to show a trending movie list from TMDB. 

```dart
part 'trending_movies_list_provider.g.dart';

@riverpod
class TrendingMoviesList extends _$TrendingMoviesList
    with PaginatedDataMixin<TmdbMovie>
    implements PaginatedNotifier<TmdbMovie> {
  @override
  FutureOr<List<TmdbMovie>> build() async {
    return init(
      dataFetcher: PaginatedDataRepository(
        fetcher: ref.watch(tmdbRepositoryProvider).getTrendingMovies,
      ),
    );
  }
}
```
**The key things to note here are,**
1. We have used the `PaginatedDataMixin` on the provider
2. We have implemented the class `PaginatedNotifier` (We use generics to specify what kind of data we're dealing with - in our case the `TmdbMovie` model)
3. Unlike a normal `build` method, we are calling `init` method. This is for initializing state and the data fetcher. We are passing the [PaginatedDataRepository] instance initialised with our repository fetching method.

## The UI (View)

We have created a simple ConsumerWidget withour `PaginatedListView` class.

```dart
class MovieList extends ConsumerWidget {
  const MovieList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movies = ref.watch(trendingMoviesListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Trending Movies')),
      body: PaginatedListView(
        state: movies,
        itemBuilder: (_, data) => MovieItem(movie: data),
        notifier: ref.read(trendingMoviesListProvider.notifier),
      ),
    );
  }
}

```

This will show a loading screen initially, and then will show the fetched data. Once you scroll to the end of the list, it will show a loading indicator and fetch the next set of data. You don't need to do anything.

## Another example with search query

Here the user can enter movie name and search for it. So, we're adding the below method to our repository.

```dart
Future<PaginatedResponse<TmdbMovie>> searchMovies({
    int page = 1,
    String? query = '',
  }) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    final results = await dio.get<Map<String, dynamic>>(
      'search/movie?query=$query&include_adult=false&page=$page',
    );
    
    return PaginatedResponse.fromJson(
      results.data!,
      dataMapper: TmdbMovie.fromJson,
      dataField: 'results',
      paginationParser: (data) => Pagination(
        totalNumber: data['total_results'] as int,
        currentPage: data['page'] as int,
        lastPage: data['total_pages'] as int,
      ),
    );
  }
```

Now our provider:

```dart
part 'search_movies_provider.g.dart';

@riverpod
class SearchMovies extends _$SearchMovies
    with PaginatedDataMixin<TmdbMovie>
    implements PaginatedNotifier<TmdbMovie> {
  @override
  FutureOr<List<TmdbMovie>> build() async {
    final dataFetcher = PaginatedDataRepository(
      fetcher:ref.watch(tmdbRepositoryProvider).searchMovies,
      queryFilter: queryFilter,
    );

    return init(
      dataFetcher: PaginatedDataRepository(
        fetcher: ref.watch(tmdbRepositoryProvider).searchMovies,
        queryFilter: queryFilter,
      ),
    );
  }
}
```
One difference here is the `queryFilter`. We need to initialise the [PaginatedDataRepository] with the queryFilter as well. 

Now to se the search query, we will call the `setQueryFilter` method of the notifier (These methods and variables are all added by the Mixin).

For example, our SearchField widget looks like this.

```dart
import 'package:example/src/constants/colors.dart';
import 'package:example/src/features/movies/providers/search_movies_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MovieSearchField extends ConsumerStatefulWidget {
  const MovieSearchField({super.key});

  @override
  ConsumerState<MovieSearchField> createState() => _MovieSearchFieldState();
}

class _MovieSearchFieldState extends ConsumerState<MovieSearchField> {
  String searchQuery = '';
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) => searchQuery = value,
      onSubmitted: (value) => _onSubmit(),
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Enter a movie name...',
        hintStyle: const TextStyle(color: Colors.white38),
        suffixIcon: IconButton(
          icon: const Icon(Icons.search),
          onPressed: _onSubmit,
        ),
      ),
      style: const TextStyle(color: tertiaryColor),
    );
  }

  void _onSubmit() {
    ref.read(searchMoviesProvider.notifier).setQueryFilter(searchQuery);
  }
}

```
The `_onSubmit()` method calls the setQueryFilter with the user entered movie name. The `setQueryFilter` method will automatically refreshes the provider with new query and our repositorh method will fetch new data.

## Example for Slivers
You just need to set `useSliver` to true and pass a [ScrollController]. Ofcourse, you need to initialise your [CustomScrollView] with the ScrollController instance.

See the code below.

```dart
class MovieListSliver extends ConsumerWidget {
  MovieListSliver({super.key});
  final scrollController = ScrollController(); //Create a scroll controller

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movies = ref.watch(trendingMoviesListProvider);

    return Scaffold(
      body: CustomScrollView(
        controller: scrollController, //Attach it to the CustomScrollView
        slivers: [
          PaginatedListView(
            state: movies,
            itemBuilder: (_, data) => MovieItem(movie: data),
            notifier: ref.read(trendingMoviesListProvider.notifier),
            useSliver: true,
            scrollController: scrollController, // Pass the scroll controller
          ),
        ],
      ),
    );
  }
}

```

## Skeleton loading
By passing a `skeleton` widget (just your widget with dummy data is required. The skeletonizer package will do the rest), you can show skeleton loading animation.

```dart
PaginatedListView(
  state: ref.watch(searchMoviesProvider),
  itemBuilder: (data) => MovieItem(movie: data),
  notifier: ref.read(searchMoviesProvider.notifier),
  skeleton: MovieItem(
    movie: TmdbMovie(
      originalTitle: 'Dummy Title',
      overview:'Long text summary \n Another line of text',
    ),
  ),
  numSkeletons: 8, // The number of skeletons to show
),
```

It uses the Skeletonizer dart package for building skeleton animation. If the default animations need to be customised you can include a [SkeletonizerConfig] widget in root level or as a parent widget.

*Example*
```dart
SkeletonizerConfig(
  data: const SkeletonizerConfigData(
    effect: PulseEffect(from: Colors.white10, to: Colors.white24),
  ),
  child: <Your child widget tree>
),
```