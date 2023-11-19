<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

The easiest infinite scrolling pagination using Riverpod. Just initialise your AsyncNotifier builds with your data fetching repository method - no need to write any other logic.

## Features

- Easiest implementation of infinite scrolling pagination ever
- Supports ListView, ListView.separator, SliverList, SliverList.se and GridView and SliverGrids
- Default Widgets for initial loading, inline loading and error
- Custom builders allows you customise all behaviours of the package
- A data fetcher class that you may use independently to store paginated data
- Well documented and provided an example

## Getting started

You will need Riverpod to use this package. If you're not using it, is an excellent state management library. See Riverpod documentation. Also start using, Riverpod generators.

You can use this package on a Riverpod generated AsyncNotifier. Also, there are two widgets - PaginatedListView and PaginatedGridView which can be used in your widget tree 

## Usage

### In your provider:

You will need to use the [PaginatedDataMixin] mixin and should implement the [PaginatedNotifier] class.

Example:

```dart

//A normal riverpod notifier.
@riverpod
class TrendingMoviesList extends _$TrendingMoviesList
    with PaginatedDataMixin<TmdbMovie> // The mixin you shoul use
    implements PaginatedNotifier<TmdbMovie> {

  //As usual, you should override the build method
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

You may have noticed that, there is an `init` method in the build() function. This is where we initialise our pagination and data fetching. The [PaginatedDataRepository] class is used for storing paginated data. You should initialise it with a fetcher method. This can be your repository method for retrieving paginated data. Otherwise, you can define the fetching function here (Recommended as you can avoid creating repositories for simple data fetching).

The `fetcher` method will receive two parameters. The `page` to fetch and `query`.

For notifiers with keepAlive:true, you will need to use 

### Your repository

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
Your repository method should accept a `page` and `query` params. You can use these params in your data fetching logic. 

The `dataMapper` function is a fromJson method which can be used to convert json data to models. If you use freezed package for generating models, this is created automatically. 

The `dataField` is to identify the data part from the json data. The TMDB api returns the paginated movie data in 'results' field and hence we're using `dataFied:'results'`.

The `paginationParser` field is a callback function which will recieve the whole json data and you can parse data and return a the [Pagination] object. The above code is suitable for TMDB API. 

If you're using Laravel framework, then json structure may look like the following.

```json
{
   "total": 50,
   "per_page": 15,
   "current_page": 1,
   "last_page": 4,
   "first_page_url": "http://laravel.app?page=1",
   "last_page_url": "http://laravel.app?page=4",
   "next_page_url": "http://laravel.app?page=2",
   "prev_page_url": null,
   "path": "http://laravel.app",
   "from": 1,
   "to": 15,
   "data":[
        {
            // Record...
        },
        {
            // Record...
        }
   ]
}
```

So, the above code might need to be changed like below. 

```dart
return PaginatedResponse.fromJson(
      results.data!,
      dataMapper: TmdbMovie.fromJson,
      dataField: 'data', //Since this is the default dataField, you can omit this
      paginationParser: (data) => Pagination(
        totalNumber: data['total'] as int,
        currentPage: data['current_page'] as int,
        lastPage: data['last_page'] as int,
      ),
    );
```

### Your widget tree

There are two widgets. `PaginatedListView` and `PaginatedGridView`. 

**PaginatedListView**
Builds a list using the Flutter [ListView] widget.

*Example*
```dart
PaginatedListView(
  state: ref.watch(searchMoviesProvider.notifier),
  itemBuilder: (data) => MovieItem(movie: data),
  notifier: ref.read(searchMoviesProvider.notifier),
),
```

**PaginatedGridView**
Builds a list using the Flutter [GridView] widget.

*Example*
```dart
PaginatedGridView(
      state: ref.watch(searchMoviesProvider),,
      itemBuilder: (data) => MovieGridItem(movie: data),
      notifier: ref.read(searchMoviesProvider.notifier),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 1 / 1.22,
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
```

## Customisation

You can pass a `skeleton` to create skeleton loading animation. 

*Example*
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

You can also use builder methods for customising the output. The following builders are available.

`initialLoadingBuilder`: To customise the initial loading. 
`loadingBuilder`: To customise the loading animation when next page is fetched.
`emptyListBuilder`: What to show when the fetched data is empty
`errorBuilder`: When there is an error

### Using Slivers

You just need to set the `useSliver` parameter to `true` to get sliver widgets. 
Note: When `useSliver` is true, you will need to create a [ScrollController] and attach it to the [CustomScrollView] and then pass the `scrollController`.

**Example**

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
            itemBuilder: (data) => MovieItem(movie: data),
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





## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.
