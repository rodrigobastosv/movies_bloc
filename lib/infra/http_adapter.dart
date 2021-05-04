import 'dart:io';

import 'package:http/http.dart';
import 'package:movies_bloc/infra/http_codes.dart';
import 'package:movies_bloc/infra/http_error.dart';

import 'method.dart';

class HttpAdapter {
  HttpAdapter({
    required Client client,
  }) : _client = client;

  late final Client _client;

  Future<Response> request({
    required String url,
    required Method method,
  }) async {
    final uri = Uri.parse(url);
    Response response;
    try {
      if (method == Method.GET) {
        response = await _client.get(uri);
      } else {
        throw HttpError.methodNotSuported;
      }
      if (response.statusCode == HTTP_OK) {
        return response;
      } else if (response.statusCode == HTTP_UNAUTHORIZED) {
        throw HttpError.unauthorized;
      } else if (response.statusCode == HTTP_BAD_REQUEST) {
        throw HttpError.badRequest;
      } else {
        throw HttpError.badRequest;
      }
    } on HttpError {
      rethrow;
    } on SocketException {
      rethrow;
    }
  }
}
