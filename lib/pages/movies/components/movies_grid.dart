import 'package:flutter/material.dart';
import 'package:movies_bloc/model/movie_model.dart';
import 'package:movies_bloc/pages/movies/components/movie_card.dart';

class MoviesGrid extends StatelessWidget {
  const MoviesGrid(this.movies, {Key? key}) : super(key: key);

  final List<MovieModel> movies;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 400,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemBuilder: (_, i) => MovieCard(
          i,
          movies[i],
        ),
        itemCount: movies.length,
      ),
    );
  }
}
