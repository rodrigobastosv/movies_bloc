import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_bloc/cubit/movies_cubit.dart';

import 'components/movies_grid.dart';
import 'components/term_input_field.dart';

class MoviesWidget extends StatelessWidget {
  MoviesWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          TermInputField(),
          BlocBuilder<MoviesCubit, MoviesState>(
            builder: (_, state) {
              print(state);
              if (state is MoviesLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is MoviesFetchSuccess) {
                return Expanded(
                  child: MoviesGrid(state.movies),
                );
              } else if (state is MoviesFetchSuccessNoMovieFound) {
                return Image.asset('assets/not_found.png');
              } else if (state is MoviesFetchFail) {
                return Image.asset('assets/sorry.png');
              } else if (state is MoviesFetchFailDueToNoInternet) {
                print('here');
                return Image.asset('assets/no_internet.png');
              }
              return SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
