import 'package:dio/dio.dart';


class ApiService {
  static const String baseUrl = 'https://lf-inv.onrender.com';

  final Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      'Content-Type': 'application/json',
    },
  ));

  ApiService() {
    _dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }

  // Generic GET request
  Future<Response> get(String endpoint, {Map<String, dynamic>? queryParameters, Options? options}) async {
    try {
      final response = await _dio.get(endpoint, queryParameters: queryParameters, options: options);
      return response;
    } catch (e) {
      throw Exception('GET request failed: $e');
    }
  }

  // Generic POST request
  Future<Response> post(String endpoint, {dynamic data, Options? options}) async {
    try {
      final response = await _dio.post(endpoint, data: data, options: options);
      return response;
    } catch (e) {
      throw Exception('POST request failed: $e');
    }
  }

  // Generic PUT request
  Future<Response> put(String endpoint, {dynamic data, Options? options}) async {
    try {
      final response = await _dio.put(endpoint, data: data, options: options);
      return response;
    } catch (e) {
      throw Exception('PUT request failed: $e');
    }
  }

  // Generic PATCH request
  Future<Response> patch(String endpoint, {dynamic data, Options? options}) async {
    try {
      final response = await _dio.patch(endpoint, data: data, options: options);
      return response;
    } catch (e) {
      throw Exception('PATCH request failed: $e');
    }
  }

  // Generic DELETE request
  Future<Response> delete(String endpoint) async {
    try {
      final response = await _dio.delete(endpoint);
      return response;
    } catch (e) {
      throw Exception('DELETE request failed: $e');
    }
  }

  // Multipart POST for file uploads
  Future<Response> postMultipart(String endpoint, FormData formData) async {
    try {
      final response = await _dio.post(endpoint, data: formData);
      return response;
    } catch (e) {
      throw Exception('Multipart POST request failed: $e');
    }
  }


}
