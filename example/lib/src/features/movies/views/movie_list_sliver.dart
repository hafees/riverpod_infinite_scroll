import 'package:example/src/features/movies/providers/trending_movies_list_provider.dart';
import 'package:example/src/features/movies/views/widgets/movie_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_infinite_scroll/riverpod_infinite_scroll.dart';

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
