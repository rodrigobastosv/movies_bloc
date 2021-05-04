import 'package:bloc_test/bloc_test.dart';
import 'package:data_faker/data_faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movies_bloc/cubit/movies_cubit.dart';
import 'package:movies_bloc/exception/fetch_movie_exception.dart';
import 'package:movies_bloc/exception/no_internet_connection_exception.dart';
import 'package:movies_bloc/model/movie_model.dart';

import '../mocks.dart';

void main() {
  late MoviesCubit moviesCubit;
  late MockMoviesRepository mockMoviesRepository;

  List<MovieModel> moviesMockData = [
    MovieModel(
      title: Faker.name,
      year: Faker.name,
      imdbID: Faker.name,
      type: Faker.name,
      poster: Faker.name,
    ),
    MovieModel(
      title: Faker.name,
      year: Faker.name,
      imdbID: Faker.name,
      type: Faker.name,
      poster: Faker.name,
    ),
  ];

  When mockCall(String term) =>
      when(() => mockMoviesRepository.getMoviesByTerm(term));

  void mockSuccess({
    required String term,
    List<MovieModel>? movies,
  }) =>
      mockCall(term).thenAnswer(
        (_) async => movies ?? moviesMockData,
      );

  void mockFail(Exception error) => mockCall('some term').thenThrow(error);

  setUp(() {
    mockMoviesRepository = MockMoviesRepository();
    moviesCubit = MoviesCubit(mockMoviesRepository);
  });

  test('should have MoviesInitial as initial state', () {
    expect(moviesCubit.state, isA<MoviesInitial>());
  });

  blocTest(
    '''
    when fetchMoviesByTerm is called
    should emit [MoviesLoading, MoviesFetchSuccess]
    when success
    ''',
    build: () {
      mockSuccess(term: 'some term');
      return moviesCubit;
    },
    act: (MoviesCubit cubit) {
      cubit.fetchMoviesByTerm('some term');
    },
    expect: () => [
      MoviesLoading(),
      MoviesFetchSuccess(moviesMockData),
    ],
    verify: (MoviesCubit cubit) =>
        verify(() => mockMoviesRepository.getMoviesByTerm('some term'))
            .called(1),
  );

  blocTest(
    '''
    when fetchMoviesByTerm is called
    should emit [MoviesLoading, MoviesFetchFailed]
    when something fails
    ''',
    build: () {
      mockFail(FetchMovieException());
      return moviesCubit;
    },
    act: (MoviesCubit cubit) {
      cubit.fetchMoviesByTerm('some term');
    },
    expect: () => [
      MoviesLoading(),
      MoviesFetchFail('Unexpected error happened!'),
    ],
    verify: (MoviesCubit cubit) =>
        verify(() => mockMoviesRepository.getMoviesByTerm('some term'))
            .called(1),
  );

  blocTest(
    '''
    when fetchMoviesByTerm is called
    should emit [MoviesLoading, MoviesFetchSuccessNoMovieFound]
    when no movie is found
    ''',
    build: () {
      mockSuccess(term: 'some term', movies: []);
      return moviesCubit;
    },
    act: (MoviesCubit cubit) {
      cubit.fetchMoviesByTerm('some term');
    },
    expect: () => [
      MoviesLoading(),
      MoviesFetchSuccessNoMovieFound(),
    ],
    verify: (MoviesCubit cubit) =>
        verify(() => mockMoviesRepository.getMoviesByTerm('some term'))
            .called(1),
  );

  blocTest(
    '''
    when fetchMoviesByTerm is called
    should emit [MoviesLoading, MoviesFetchFailDueToNoInternet]
    when there's no internet conncection
    ''',
    build: () {
      mockFail(NoInternetConnectionException());
      return moviesCubit;
    },
    act: (MoviesCubit cubit) {
      cubit.fetchMoviesByTerm('some term');
    },
    expect: () => [
      MoviesLoading(),
      MoviesFetchFailDueToNoInternet(),
    ],
    verify: (MoviesCubit cubit) =>
        verify(() => mockMoviesRepository.getMoviesByTerm('some term'))
            .called(1),
  );
}
