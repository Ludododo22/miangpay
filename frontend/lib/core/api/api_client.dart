import 'package:dio/dio.dart';

import 'api_config.dart';

class ApiClient {
  ApiClient({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: ApiConfig.baseUrl,
                connectTimeout: ApiConfig.timeout,
                receiveTimeout: ApiConfig.timeout,
                sendTimeout: ApiConfig.timeout,
                headers: const {
                  'Accept': 'application/json',
                  'Content-Type': 'application/json',
                },
              ),
            );

  final Dio _dio;

  void setBearerToken(String? token) {
    if (token == null || token.isEmpty) {
      _dio.options.headers.remove('Authorization');
      return;
    }
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  Future<Map<String, dynamic>> getJson(String path,
      {Map<String, dynamic>? queryParameters}) async {
    final response =
        await _dio.get<Object?>(path, queryParameters: queryParameters);
    return _asMap(response.data);
  }

  Future<Map<String, dynamic>> postJson(String path,
      {Map<String, dynamic>? data}) async {
    final response = await _dio.post<Object?>(path, data: data);
    return _asMap(response.data);
  }

  Future<Map<String, dynamic>> putJson(String path,
      {Map<String, dynamic>? data}) async {
    final response = await _dio.put<Object?>(path, data: data);
    return _asMap(response.data);
  }

  Future<Map<String, dynamic>> deleteJson(String path) async {
    final response = await _dio.delete<Object?>(path);
    return _asMap(response.data);
  }

  Map<String, dynamic> _asMap(Object? data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return {'data': data};
  }
}
