import 'package:example/src/constants/colors.dart';
import 'package:example/src/features/movies/providers/trending_movies_list_provider.dart';
import 'package:example/src/features/movies/views/widgets/movie_item.dart';
import 'package:example/src/features/movies/views/widgets/movie_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_infinite_scroll/riverpod_infinite_scroll.dart';

class MovieSearchList extends ConsumerWidget {
  const MovieSearchList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movies = ref.watch(trendingMoviesListProvider);
    final trendingMovies = ref.watch(trendingMoviesListProvider);

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: const MovieSearchField(),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Builder(
          builder: (context) {
            // return PaginatedGridView(
            //   state: movies,
            //   itemBuilder: (data) => MovieItem(movie: data),
            //   notifier: ref.read(searchMoviesProvider.notifier),
            // );

            return PaginatedListView(
              state: trendingMovies,
              itemBuilder: (data) => MovieItem(movie: data),
              notifier: ref.read(trendingMoviesListProvider.notifier),
            );
          },
        ),
      ),
    );
  }
}
