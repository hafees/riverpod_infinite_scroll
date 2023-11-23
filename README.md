The easiest infinite scrolling pagination using Riverpod. Just initialize your AsyncNotifier build method with your data-fetching repository method - no need to write any other logic.

![riverpod_inifinite_scroll](https://github.com/hafees/riverpod_infinite_scroll/assets/925404/08cc0bbc-ba35-45ea-95ab-5701d74400d0)

Checkout video: https://github.com/hafees/riverpod_infinite_scroll/assets/925404/128aadef-c14e-408b-a042-a3d42b67cc85

```dart
PaginatedListView(
  state: ref.watch(searchMoviesProvider.notifier),
  itemBuilder: (data) => MovieItem(movie: data),
  notifier: ref.read(searchMoviesProvider.notifier),
),
```

Simple code like this can produce, infinite scroll pagination (The user scrolls to the end of the list and the next set of data is loaded automatically).

## Features

- Easiest implementation of infinite scrolling pagination ever
- Supports ListView, ListView.separator, SliverList, SliverList.se and GridView and SliverGrids
- Skeleton loading animation support
- Default Widgets for initial loading, inline loading, and error
- Custom builders allow you to customize all behaviors of the package
- A data fetcher class that you may use independently to store paginated data
- Well documented and an example app is provided for reference

## Getting started

You will need Riverpod to use this package. If you're not using it, is an excellent state management library. See Riverpod documentation. Also start using, Riverpod generators.

You can use this package on a Riverpod-generated AsyncNotifier. Also, there are two widgets - PaginatedListView for ListView builds and PaginatedGridView for GridView builds.

## Usage

As usual in the normal Riverpod state management application, there is a provider (for managing state), repository(for fetching data), and widgets (for UI interface). If you're not familiar with the Riverpod package, then see the documentation: https://riverpod.dev/docs/introduction/why_riverpod.

### In your provider:

You will need to use the [PaginatedDataMixin] mixin and should implement the [PaginatedNotifier] class.

Example:

```dart

//A normal riverpod notifier.
@riverpod
class TrendingMoviesList extends _$TrendingMoviesList
    with PaginatedDataMixin<TmdbMovie> // The mixin you should use
    implements PaginatedNotifier<TmdbMovie> {

  //As usual, you should override the build method
  @override
  FutureOr<List<TmdbMovie>> build() async {
    return init(
      dataFetcher: PaginatedDataRepository(
        fetcher: ref.watch(tmdbRepositoryProvider).getTrendingMovies,
      ), //Initialise with your data fetching method
    );
  }
}

```

You may have noticed that there is an `init` method in the build() function. This is where we initialize our pagination and data fetching. The [PaginatedDataRepository] class is used for storing paginated data. You should initialize it with a fetcher method. This can be your repository method for retrieving paginated data. Otherwise, you can define the fetching function directly (Recommended as you can avoid creating repositories for simple data fetching).

The `fetcher` method will receive two parameters. The `page` to fetch and `query` that you can use to filter the data. You only need to provide data according to these parameters. The pagination logic, scroll handlers, state changes etc are automatically handled by the package.

Note: For notifiers with `keepAlive:true`, you will need to use the [KeepAlivePaginatedDataMixin]. Hopefully, this limitation can be removed in future versions.

### Your repository

This is a sample code for the repository.

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

Your repository method should accept a `page` and `query` params. You can use these parameters in your data-fetching logic.

- The `dataMapper` function is a fromJson method that can be used to convert JSON data to models. If you use `freezed` package for generating models, this is created automatically.

- The `dataField` is to identify the data part from the JSON data. The TMDB API returns the paginated movie data in 'results' field and hence we're using `dataFied:'results'`.

- The `paginationParser` field is a callback function that will receive the whole JSON data and you can parse data and return a [Pagination] object. The above code is suitable for TMDB API.

If you're using the Laravel framework, then the JSON structure may look like the following.

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
  "data": [
    {
      // Record...
    },
    {
      // Record...
    }
  ]
}
```

So, to parse data and pagination we need something like,

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

_Example_

```dart
PaginatedListView(
  state: ref.watch(searchMoviesProvider.notifier),
  itemBuilder: (data) => MovieItem(movie: data),
  notifier: ref.read(searchMoviesProvider.notifier),
),
```

**PaginatedGridView**
Builds a list using the Flutter [GridView] widget.

_Example_

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

_Example_

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

_Example_

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

You can check out the package and check the example folder for a movie listing app that fetches data using TMDB API. I have provided examples for ListView, SliverLists, GridView, query parameters, implementing pull-to-refresh functionality with CustomScrollView, etc.

## Limitations

I have tested the package with Riverpod AsyncNotifiers - both keepAlive and autodisposed. However, if you need to accept parameters in your build method, you should do some workarounds. Hopefully, this can be fixed in future versions (Might need to get some information from the Riverpod author).

For the time being, you can either alter your logic to use the query filter instead of accepting parameters in `build()`or you can use another mixin - **[PaginatedDataMixinGeneric]** in your provider and override the following methods. (Just and copy and paste this methods and it should work fine)

```dart
  @override
  Future<void> getNextPage() async {
    state = const AsyncLoading();
    state = AsyncData(await fetchData());
  }

  @override
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = AsyncData(await reloadData());
  }
```

## More Examples

Checkout more code samples:
https://pub.dev/packages/riverpod_infinite_scroll_pagination/example

Also you can checkout the example project.
