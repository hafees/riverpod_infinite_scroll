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

The easiest infinite scrolling pagination (contents loaded automatically upon the scroll) using Riverpod. Just initialise your AsyncNotifier builds with your data fetching repository method - no need to write any other logic.

## Features

- Easiest implementation of infinite scrolling pagination ever
- Supports ListView, ListView.separator, SliverList, SliverList.se and GridView and SliverGrids
- Default Widgets for initial loading, inline loading and error
- Custom builders allows you customise all behaviours of the package
- A data fetcher class that you may use independently to store paginated data
- Well documented and provided an example

## Getting started

You will need Riverpod to use this package. If you're not using it, is an excellent state management library. See Riverpod documentation. Also start using, Riverpod generators.

You can use this package on a Riverpod generated AsyncNotifier. Also, there are two widgets - PaginatedListView and PaginatedGridView which can be used in your widget tree.

## In your provider:

You will need to use the [PaginatedDataMixin] mixin and should implement the [PaginatedNotifier] class.

Example:

```dart

//A normal riverpod notifier.
@riverpod
class TrendingMoviesList extends _$TrendingMoviesList
    with PaginatedDataMixin<TmdbMovie>
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

## In your

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder.

```dart
const like = 'sample';
```

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.
