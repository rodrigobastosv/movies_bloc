import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:movies_bloc/cubit/movies_cubit.dart';
import 'package:movies_bloc/infra/http_adapter.dart';
import 'package:movies_bloc/pages/movies/movies_widget.dart';
import 'package:movies_bloc/repository/http_movies_repository.dart';

class MoviesPage extends StatelessWidget {
  const MoviesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MoviesCubit>(
      create: (_) => MoviesCubit(
        HttpMoviesRepository(
          HttpAdapter(
            client: Client(),
          ),
        ),
      ),
      child: MoviesWidget(),
    );
  }
}
