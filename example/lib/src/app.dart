import 'package:example/src/constants/colors.dart';
import 'package:example/src/features/movies/views/movie_list_sliver.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TMDB Demo App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: secondaryColor),
        useMaterial3: true,
      ),
      home: MovieListSliver(),
      debugShowCheckedModeBanner: false,
    );
  }
}
