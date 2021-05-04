import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movies_bloc/cubit/movies_cubit.dart';
import 'package:movies_bloc/repository/movies_repository.dart';

class MockMoviesRepository extends Mock implements MoviesRepository {}

class MockMoviesCubit extends MockCubit<MoviesState> implements MoviesCubit {}