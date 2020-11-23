import 'dart:async';

import 'package:gitlab/gitlab.dart';
import 'package:http/http.dart' as http;

/// An abstraction for `http` that allows us to mock it.
///
/// **Never use this class directly in the library.**
/// Use `GitLab.request()` instead.
/// An instance of this class is created in the `GitLab` class, and will be used
/// only by it.
class GitLabHttpClient {
  Future<http.Response> request(
    Uri uri,
    Map<String, String> headers,
    HttpMethod method,
  ) async {
    http.Response response;
    if (method == HttpMethod.get) {
      response = await http.get(uri, headers: headers);
    } else if (method == HttpMethod.put) {
      response = await http.put(uri, headers: headers);
    } else if (method == HttpMethod.post) {
      response = await http.post(uri, headers: headers);
    } else if (method == HttpMethod.delete) {
      response = await http.delete(uri, headers: headers);
    } else {
      throw new ArgumentError('Invalid http method: $method');
    }

    return response;
  }
}
