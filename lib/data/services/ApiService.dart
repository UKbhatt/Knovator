import 'dart:async';
import 'package:dio/dio.dart';

class ApiClient {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  static const _ua =
      'Mozilla/5.0 (Linux; Android 13; Mobile) AppleWebKit/537.36 '
      '(KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36';

  final Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 15),
    sendTimeout: const Duration(seconds: 10),
    responseType: ResponseType.json,
    validateStatus: (code) => code != null && code >= 200 && code < 300,
    headers: {
      'Accept': 'application/json, text/plain, */*',
      'Accept-Language': 'en-US,en;q=0.9',
      'Cache-Control': 'no-cache',
      'Pragma': 'no-cache',
      'User-Agent': _ua,
      'Connection': 'keep-alive',
    },
  ));

  Future<Response> _getWithRetry(String path) async {
    int attempt = 0;
    Object? lastError;

    while (attempt < 3) {
      try {
        final res = await _dio.get(path,
            options: Options(
              headers: {'User-Agent': _ua},
            ));
        return res;
      } on DioException catch (e) {
        final status = e.response?.statusCode ?? 0;
        final isBlock = status == 403 || status == 429;
        lastError = e;
        if (!isBlock) rethrow;

        final delay = Duration(milliseconds: 200 + attempt * 400);
        await Future.delayed(delay);
        attempt++;

        final sep = path.contains('?') ? '&' : '?';
        path = '$path${sep}t=${DateTime.now().millisecondsSinceEpoch}';
        continue;
      } catch (e) {
        lastError = e;
        rethrow;
      }
    }
    throw lastError ?? Exception('Network retry failed');
  }

  Future<List<dynamic>> fetchPosts() async {
    final res = await _getWithRetry('/posts');
    if (res.data is! List) {
      throw Exception('Unexpected response (not JSON list).');
    }
    return res.data as List<dynamic>;
  }

  Future<Map<String, dynamic>> fetchPostDetail(int id) async {
    final res = await _getWithRetry('/posts/$id');
    if (res.data is! Map) {
      throw Exception('Unexpected response (not JSON object).');
    }
    return Map<String, dynamic>.from(res.data as Map);
  }
}
