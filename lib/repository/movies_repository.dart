import 'package:movies_bloc/model/movie_model.dart';

abstract class MoviesRepository {
  Future<List<MovieModel>> getMoviesByTerm(String term);
}
