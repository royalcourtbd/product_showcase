import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:initial_project/core/utility/logger_utility.dart';
import 'package:initial_project/core/utility/trial_utility.dart';

abstract class HttpClient {
  Future<Map<String, dynamic>> get(
    String url, {
    Map<String, String>? queryParameters,
  });
  Future<Map<String, dynamic>> post(String url, {Map<String, dynamic>? body});
}

class HttpClientImpl implements HttpClient {
  final http.Client _client;

  HttpClientImpl({http.Client? client}) : _client = client ?? http.Client();

  @override
  Future<Map<String, dynamic>> get(
    String url, {
    Map<String, String>? queryParameters,
  }) async {
    return await catchAndReturnFuture(() async {
          final Uri uri = Uri.parse(
            url,
          ).replace(queryParameters: queryParameters);
          logDebugStatic('GET Request: $uri', 'HttpClientImpl');

          final http.Response response = await _client.get(uri);
          return _handleResponse(response);
        }) ??
        {};
  }

  @override
  Future<Map<String, dynamic>> post(
    String url, {
    Map<String, dynamic>? body,
  }) async {
    return await catchAndReturnFuture(() async {
          final Uri uri = Uri.parse(url);
          logDebugStatic('POST Request: $uri, Body: $body', 'HttpClientImpl');

          final http.Response response = await _client.post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: body != null ? json.encode(body) : null,
          );
          return _handleResponse(response);
        }) ??
        {};
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return {};

      try {
        final dynamic decodedResponse = json.decode(response.body);

        if (decodedResponse is Map<String, dynamic>) {
          return decodedResponse;
        }

        if (decodedResponse is List) {
          return {'data': decodedResponse};
        }

        logErrorStatic(
          'Unexpected response format: ${response.body}',
          'HttpClientImpl',
        );
        return {'data': decodedResponse};
      } catch (e) {
        logErrorStatic(
          'Failed to parse response body: ${response.body}, Error: $e',
          'HttpClientImpl',
        );
        throw Exception('Invalid response format: $e');
      }
    } else {
      logErrorStatic(
        'HTTP Error: ${response.statusCode}, Body: ${response.body}',
        'HttpClientImpl',
      );
      throw Exception('HTTP Error ${response.statusCode}: ${response.body}');
    }
  }
}
