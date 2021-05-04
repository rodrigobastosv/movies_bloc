import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:movies_bloc/exception/fetch_movie_exception.dart';
import 'package:movies_bloc/exception/no_internet_connection_exception.dart';
import 'package:movies_bloc/model/movie_model.dart';
import 'package:movies_bloc/repository/movies_repository.dart';

part 'movies_state.dart';

class MoviesCubit extends Cubit<MoviesState> {
  MoviesCubit(this._repository) : super(MoviesInitial());

  final MoviesRepository _repository;

  void fetchMoviesByTerm(String term) async {
    emit(MoviesLoading());

    try {
      final movies = await _repository.getMoviesByTerm(term);

      if (movies.isNotEmpty) {
        emit(MoviesFetchSuccess(movies));
      } else {
        emit(MoviesFetchSuccessNoMovieFound());
      }
    } on FetchMovieException catch (exception) {
      emit(MoviesFetchFail(exception.errorMessage));
    } on NoInternetConnectionException {
      emit(MoviesFetchFailDueToNoInternet());
    }
  }
}
