import 'package:example/src/extensions/context_utils.dart';
import 'package:example/src/features/movies/models/tmdb_movie/tmdb_movie.dart';
import 'package:example/src/features/movies/providers/search_movies_provider.dart';
import 'package:example/src/features/movies/views/widgets/movie_grid_item.dart';
import 'package:example/src/features/movies/views/widgets/movie_item.dart';
import 'package:example/src/features/movies/views/widgets/movie_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_infinite_scroll_pagination/riverpod_infinite_scroll_pagination.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MovieSearchSliverList extends ConsumerStatefulWidget {
  const MovieSearchSliverList({super.key});

  @override
  ConsumerState<MovieSearchSliverList> createState() => _MovieSearchListState();
}

class _MovieSearchListState extends ConsumerState<MovieSearchSliverList> {
  bool gridViewEnabled = false;
  final controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    final movies = ref.watch(searchMoviesProvider);
    final notifier = ref.read(searchMoviesProvider.notifier);
    return Scaffold(
      body: SafeArea(
        child: SkeletonizerConfig(
          data: const SkeletonizerConfigData(
            effect: PulseEffect(from: Colors.white10, to: Colors.white24),
          ),
          child: RefreshIndicator(
            onRefresh: ref.read(searchMoviesProvider.notifier).refresh,
            child: CustomScrollView(
              controller: controller,
              slivers: [
                const SliverAppBar(
                  title: MovieSearchField(),
                  floating: true,
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(10),
                  sliver: gridViewEnabled
                      ? PaginatedGridView(
                          state: movies,
                          itemBuilder: (_, data) => MovieGridItem(movie: data),
                          notifier: ref.read(searchMoviesProvider.notifier),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 1 / 1.22,
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          useSliver: true,
                          scrollController: controller,
                          skeleton: MovieGridItem(
                            movie: TmdbMovie(
                              originalTitle: 'Dummy Title',
                              overview: 'Long text summary',
                            ),
                          ),
                          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                        )
                      : PaginatedListView(
                          state: movies,
                          itemBuilder: (_, data) => MovieItem(movie: data),
                          notifier: ref.read(searchMoviesProvider.notifier),
                          useSliver: true,
                          scrollController: controller,
                          skeleton: MovieItem(
                            movie: TmdbMovie(
                              originalTitle: 'Dummy Title',
                              overview:
                                  'Long text summary \n Another line of text',
                            ),
                          ),
                          numSkeletons: 10,
                          loadingBuilder: (_, pagination) {
                            return Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const CircularProgressIndicator.adaptive(),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Loading page ${pagination.currentPage + 1}'
                                    ' of ${pagination.lastPage}',
                                    style: context.summaryTextStyle,
                                  ),
                                ],
                              ),
                            );
                          },
                          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                        ),
                ),
                if (movies.hasError && !movies.isLoading && notifier.hasData())
                  SliverToBoxAdapter(
                    child: Center(
                      child: Column(
                        children: [
                          const Text('Sorry, unable to load the data'),
                          IconButton.outlined(
                            onPressed: () {
                              ref
                                  .read(searchMoviesProvider.notifier)
                                  .getNextPage();
                            },
                            icon: const Icon(Icons.refresh_outlined),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
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
