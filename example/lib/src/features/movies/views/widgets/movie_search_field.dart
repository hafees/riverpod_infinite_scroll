import 'package:example/src/features/movies/providers/search_movies_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MovieSearchField extends ConsumerStatefulWidget {
  const MovieSearchField({super.key});

  @override
  ConsumerState<MovieSearchField> createState() => _MovieSearchFieldState();
}

class _MovieSearchFieldState extends ConsumerState<MovieSearchField> {
  String searchQuery = '';
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) => searchQuery = value,
      onSubmitted: (value) => _onSubmit(),
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: const Icon(Icons.search),
          onPressed: _onSubmit,
        ),
      ),
    );
  }

  void _onSubmit() {
    ref.read(searchMoviesProvider.notifier).setQueryFilter(searchQuery);
  }
}
