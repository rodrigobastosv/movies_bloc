import 'dart:convert';

import 'package:movies_bloc/exception/fetch_movie_exception.dart';
import 'package:movies_bloc/exception/no_internet_connection_exception.dart';
import 'package:movies_bloc/infra/http_adapter.dart';
import 'package:movies_bloc/infra/method.dart';
import 'package:movies_bloc/model/movie_model.dart';
import 'package:movies_bloc/repository/movies_repository.dart';

class HttpMoviesRepository implements MoviesRepository {
  HttpMoviesRepository(this._http);

  final HttpAdapter _http;

  @override
  Future<List<MovieModel>> getMoviesByTerm(String term) async {
    try {
      final response = await _http.request(
        url: 'https://www.omdbapi.com/?apikey=98c5f6f6&s=$term',
        method: Method.GET,
      );
      final json = jsonDecode(response.body);
      if (json['Error'] != null) {
        return [];
      }
      final searchResult = json['Search'] as List;
      return List.generate(
        searchResult.length,
        (i) => MovieModel.fromJson(searchResult[i]),
      );
    } on Exception catch (e) {
      if (e is FetchMovieException) {
        throw FetchMovieException();
      } else {
        throw NoInternetConnectionException();
      }
    }
  }
}
