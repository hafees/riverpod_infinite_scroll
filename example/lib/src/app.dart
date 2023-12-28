import 'package:example/src/features/movies/views/movie_search_sliver.dart';
import 'package:example/src/theme/color_schemes.g.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_infinite_scroll_pagination/riverpod_infinite_scroll_pagination.dart';

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return InfiniteScrollPaginationConfig(
      emptyListBuilder: (_) =>
          const Center(child: Text('Sorry, nothing found - ISPC')),
      initialLoadingErrorBuilder: (_, e, ___) =>
          Center(child: Text('$e - ISPC')),
      errorBuilder: (_, e, __) =>
          const Center(child: Text('Loading Error - ISPC')),
      numSkeletonsForLoading: 2,
      child: MaterialApp(
        title: 'TMDB Demo App',
        theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
        darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
        themeMode: ThemeMode.dark,
        //home: MovieListSimilar(movieId: 507089),
        //home: const MovieList(),
        //home: const MovieSearchList(),
        home: const MovieSearchSliverList(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
