import 'package:example/src/features/movies/providers/similar_movies_provider.dart';
import 'package:example/src/features/movies/views/widgets/movie_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_infinite_scroll_pagination/riverpod_infinite_scroll_pagination.dart';

class MovieListSimilar extends ConsumerWidget {
  MovieListSimilar({required this.movieId, super.key});
  final int movieId;
  final scrollController = ScrollController(); //Create a scroll controller

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movies = ref.watch(similarMoviesProvider(movieId));

    return Scaffold(
      body: PaginatedListView(
        state: movies,
        itemBuilder: (_, data) => MovieItem(movie: data),
        notifier: ref.read(similarMoviesProvider(movieId).notifier),
      ),
    );
  }
}
