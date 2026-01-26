import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData;
import '../controllers/user_controller.dart';


class ApiService {
  // static const String baseUrl = 'https://lf-inv.onrender.com';
  static const String baseUrl = 'http://172.22.154.21:3000';

  static ApiService? _instance;
  late final Dio _dio;

  ApiService._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    _dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (Get.isRegistered<UserController>()) {
          final userController = Get.find<UserController>();
          if (userController.accessToken.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer ${userController.accessToken.value}';
          }
        }
        handler.next(options);
      },
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401) {
          // Token expired, try to refresh
          if (Get.isRegistered<UserController>()) {
            final userController = Get.find<UserController>();
            if (userController.refreshToken.isNotEmpty) {
              try {
                final refreshResponse = await _dio.post('/api/utilisateur/auth/refresh-token', data: {
                  'refreshToken': userController.refreshToken.value,
                });
                if (refreshResponse.statusCode == 200) {
                  final newAccessToken = refreshResponse.data['accessToken'];
                  final newRefreshToken = refreshResponse.data['refreshToken'];
                  userController.setTokens(newAccessToken, newRefreshToken);
                  // Retry the original request
                  e.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
                  final retryResponse = await _dio.request(
                    e.requestOptions.path,
                    options: Options(
                      method: e.requestOptions.method,
                      headers: e.requestOptions.headers,
                    ),
                    data: e.requestOptions.data,
                    queryParameters: e.requestOptions.queryParameters,
                  );
                  return handler.resolve(retryResponse);
                }
              } catch (refreshError) {
                // Refresh failed, logout
                userController.logout();
                Get.offAllNamed('/login');
              }
            }
          }
        } else if (e.response?.statusCode == 400 && e.response?.data?['Error'] == 'Invalid Token') {
          // Invalid token, logout
          if (Get.isRegistered<UserController>()) {
            final userController = Get.find<UserController>();
            userController.logout();
            Get.offAllNamed('/login');
          }
        }
        handler.next(e);
      },
    ));
  }

  factory ApiService() {
    _instance ??= ApiService._internal();
    return _instance!;
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
