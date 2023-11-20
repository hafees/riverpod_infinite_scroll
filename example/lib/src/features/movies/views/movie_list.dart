import 'package:example/src/features/movies/providers/trending_movies_list_provider.dart';
import 'package:example/src/features/movies/views/widgets/movie_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_infinite_scroll_pagination/riverpod_infinite_scroll_pagination.dart';

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
