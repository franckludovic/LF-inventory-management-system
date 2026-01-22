import 'package:lf_project/core/services/api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  /// Login user with email and password
  /// Backend: POST /api/users/auth/login, expects {email, motDePasse}
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _apiService.post('/api/users/auth/login', data: {
        'email': email,
        'motDePasse': password,
      });

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(response.data['Error'] ?? 'Login failed');
      }
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  /// Get user profile
  /// Backend: GET /api/users/profile (requires auth)
  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final response = await _apiService.get('/api/users/profile');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(response.data['Error'] ?? 'Failed to get profile');
      }
    } catch (e) {
      throw Exception('Failed to get profile: ${e.toString()}');
    }
  }

  /// Refresh access token
  /// Backend: POST /utilisateur/auth/refresh-token
  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    try {
      final response = await _apiService.post('/api/users/auth/refresh-token', data: {
        'refreshToken': refreshToken,
      });

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(response.data['Error'] ?? 'Token refresh failed');
      }
    } catch (e) {
      throw Exception('Token refresh failed: ${e.toString()}');
    }
  }
}
