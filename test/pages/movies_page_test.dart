import 'package:data_faker/data_faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:movies_bloc/cubit/movies_cubit.dart';
import 'package:movies_bloc/model/movie_model.dart';
import 'package:movies_bloc/pages/movies/components/movie_card.dart';
import 'package:movies_bloc/pages/movies/components/movies_grid.dart';
import 'package:movies_bloc/pages/movies/components/term_input_field.dart';
import 'package:movies_bloc/pages/movies/movies_widget.dart';

import '../mocks.dart';

class FakeMoviesState extends Fake implements MoviesState {}

void main() {
  late MockMoviesCubit mockMoviesCubit;

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

  Future<void> loadMoviesPage(WidgetTester tester) async {
    await mockNetworkImages(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<MoviesCubit>(
            create: (_) => mockMoviesCubit,
            child: MoviesWidget(),
          ),
        ),
      );
    });
  }

  String getImageAssetName() {
    final imageFinder = find.byType(Image);
    final widget = imageFinder.evaluate().single.widget as Image;
    final assetImage = widget.image as AssetImage;
    return assetImage.assetName;
  }

  void mockState(MoviesState state) =>
      when(() => mockMoviesCubit.state).thenReturn(state);

  setUpAll(() {
    registerFallbackValue<MoviesState>(FakeMoviesState());
  });

  setUp(() {
    mockMoviesCubit = MockMoviesCubit();
  });

  testWidgets('should show term input field', (tester) async {
    mockState(MoviesInitial());

    await loadMoviesPage(tester);

    expect(find.byType(TermInputField), findsOneWidget);
  });

  testWidgets('should show progress indicator when loading movies',
      (tester) async {
    mockState(MoviesLoading());

    await loadMoviesPage(tester);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should show error image when something goes wrong',
      (tester) async {
    mockState(MoviesFetchFail('error'));

    await loadMoviesPage(tester);

    expect(getImageAssetName(), 'assets/sorry.png');
  });

  testWidgets('should show no internet image when theres no connectivity',
      (tester) async {
    mockState(MoviesFetchFailDueToNoInternet());

    await loadMoviesPage(tester);

    expect(getImageAssetName(), 'assets/no_internet.png');
  });

  testWidgets('should show no movies found image when search finds nothing',
      (tester) async {
    mockState(MoviesFetchSuccessNoMovieFound());

    await loadMoviesPage(tester);

    expect(getImageAssetName(), 'assets/not_found.png');
  });

  testWidgets('should show MoviesGrid when it works', (tester) async {
    mockState(MoviesFetchSuccess([]));

    await loadMoviesPage(tester);

    expect(find.byType(MoviesGrid), findsOneWidget);
  });

  testWidgets('should show a card for each movie', (tester) async {
    mockState(MoviesFetchSuccess(moviesMockData));

    await loadMoviesPage(tester);
    await tester.pumpAndSettle();

    expect(find.byType(MovieCard), findsNWidgets(2));
  });

  testWidgets('should validate the form correctly if no term is entered',
      (tester) async {
    mockState(MoviesInitial());

    await loadMoviesPage(tester);

    final searchIcon = find.byIcon(Icons.search);
    await tester.tap(searchIcon);
    await tester.pumpAndSettle();
    expect(find.text('The term field is required'), findsOneWidget);
  });

  testWidgets('should call fetchMoviesByTerm with the correct term',
      (tester) async {
    mockState(MoviesInitial());

    await loadMoviesPage(tester);

    final textInput = find.byType(TextFormField);
    await tester.enterText(textInput, 'titanic');
    await tester.pumpAndSettle();

    final searchIcon = find.byIcon(Icons.search);
    await tester.tap(searchIcon);
    await tester.pumpAndSettle();

    verify(() => mockMoviesCubit.fetchMoviesByTerm('titanic')).called(1);
  });
}
