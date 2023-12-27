import 'package:cached_network_image/cached_network_image.dart';
import 'package:example/src/extensions/context_utils.dart';
import 'package:example/src/features/movies/models/tmdb_movie/tmdb_movie.dart';
import 'package:flutter/material.dart';

class MovieGridItem extends StatelessWidget {
  const MovieGridItem({required this.movie, super.key});
  final TmdbMovie movie;

  static const imageBasePath = 'https://image.tmdb.org/t/p/w185';
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: '$imageBasePath/${movie.posterPath}',
              placeholder: (context, url) => const SizedBox(
                width: 66,
                height: 100,
              ),
              width: 66,
              height: 100,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => Container(
                width: 66,
                height: 100,
                color: Colors.grey,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              movie.originalTitle ?? '',
              maxLines: 1,
              style: context.headingTextStyle,
            ),
            Text(
              maxLines: 2,
              movie.overview ?? '',
              overflow: TextOverflow.ellipsis,
              style: context.summaryTextStyle,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 6,
                      width: 50,
                      child: LinearProgressIndicator(
                        value: movie.voteAverage ?? 0 / 10,
                        backgroundColor: Colors.black38,
                      ),
                    ),
                    Text(
                      '${(movie.voteAverage ?? 0 * 10).floor()}%',
                      style: context.infoTextStyle,
                    ),
                  ],
                ),
                Text(
                  '${movie.voteCount} Votes',
                  style: context.infoTextStyle,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
