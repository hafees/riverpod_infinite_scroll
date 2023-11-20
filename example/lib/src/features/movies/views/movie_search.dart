import 'package:example/src/constants/colors.dart';
import 'package:example/src/features/movies/providers/search_movies_provider.dart';
import 'package:example/src/features/movies/views/widgets/movie_grid_item.dart';
import 'package:example/src/features/movies/views/widgets/movie_item.dart';
import 'package:example/src/features/movies/views/widgets/movie_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_infinite_scroll_pagination/riverpod_infinite_scroll_pagination.dart';

class MovieSearchList extends ConsumerStatefulWidget {
  const MovieSearchList({super.key});

  @override
  ConsumerState<MovieSearchList> createState() => _MovieSearchListState();
}

class _MovieSearchListState extends ConsumerState<MovieSearchList> {
  bool gridViewEnabled = false;
  @override
  Widget build(BuildContext context) {
    final movies = ref.watch(searchMoviesProvider);

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: const MovieSearchField(),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: gridViewEnabled
            ? PaginatedGridView(
                state: movies,
                itemBuilder: (_, data) => MovieGridItem(movie: data),
                notifier: ref.read(searchMoviesProvider.notifier),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 1 / 1.22,
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
              )
            : PaginatedListView(
                state: movies,
                itemBuilder: (_, data) => MovieItem(movie: data),
                notifier: ref.read(searchMoviesProvider.notifier),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            gridViewEnabled = !gridViewEnabled;
          });
        },
        child: Icon(gridViewEnabled ? Icons.view_list : Icons.grid_view),
      ),
    );
  }
}
