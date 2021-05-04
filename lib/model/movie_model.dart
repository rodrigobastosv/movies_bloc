import 'package:equatable/equatable.dart';

class MovieModel extends Equatable {
  MovieModel({
    required this.title,
    required this.year,
    required this.imdbID,
    required this.type,
    required this.poster,
  });

  late final String title;
  late final String year;
  late final String imdbID;
  late final String type;
  late final String poster;

  MovieModel.fromJson(Map<String, dynamic> json) {
    title = json['Title'];
    year = json['Year'];
    imdbID = json['imdbID'];
    type = json['Type'];
    poster = json['Poster'];
  }

  @override
  List<Object> get props => [
        title,
        year,
        imdbID,
        type,
        poster,
      ];
}
