part of 'movies_cubit.dart';

@immutable
abstract class MoviesState extends Equatable {
  @override
  List<Object> get props => [];
}

class MoviesInitial extends MoviesState {}

class MoviesFetchSuccess extends MoviesState {
  MoviesFetchSuccess(this.movies);

  final List<MovieModel> movies;

  @override
  List<Object> get props => [
        movies,
      ];
}

class MoviesFetchSuccessNoMovieFound extends MoviesState {}

class MoviesFetchFail extends MoviesState {
  MoviesFetchFail(this.errorMsg);

  final String errorMsg;

  @override
  List<Object> get props => [
        errorMsg,
      ];
}

class MoviesFetchFailDueToNoInternet extends MoviesState {}

class MoviesLoading extends MoviesState {}