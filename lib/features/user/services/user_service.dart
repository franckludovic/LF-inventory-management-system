import 'package:lf_project/core/services/api_service.dart';
import 'package:dio/dio.dart';

class UserService {
  final ApiService _apiService = ApiService();

  /// Get all users
  Future<List<dynamic>> getAllUsers() async {
    try {
      final response = await _apiService.get('/api/users');

      if (response.statusCode == 200) {
        return response.data as List<dynamic>;
      } else {
        throw Exception(response.data['Error'] ?? 'Failed to get users');
      }
    } catch (e) {
      throw Exception('Failed to get users: ${e.toString()}');
    }
  }

  /// Create a new user
  /// Backend expects: nom, email, motDePasse, Department, region, ville, role
  Future<Map<String, dynamic>> createUser({
    required String nom,
    required String email,
    required String motDePasse,
    required String department,
    required String region,
    required String ville,
    required String role,
  }) async {
    try {
      final data = {
        'nom': nom,
        'email': email,
        'motDePasse': motDePasse,
        'Department': department,
        'region': region,
        'ville': ville,
        'role': role,
      };

      final response = await _apiService.post('/api/users/auth/create-user', data: data);

      if (response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception(response.data['Error'] ?? 'Failed to create user');
      }
    } catch (e) {
      throw Exception('Failed to create user: ${e.toString()}');
    }
  }

  /// Promote user to admin role
  Future<Map<String, dynamic>> promoteToAdmin(String userId) async {
    try {
      final response = await _apiService.patch('/api/users/add-admin/$userId');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(response.data['Error'] ?? 'Failed to promote user');
      }
    } catch (e) {
      throw Exception('Failed to promote user: ${e.toString()}');
    }
  }

  /// Get user profile
  Future<Map<String, dynamic>> getUserProfile(String accessToken) async {
    try {
      final response = await _apiService.get('/api/users/profile',
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}));

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(response.data['Error'] ?? 'Failed to get user profile');
      }
    } catch (e) {
      throw Exception('Failed to get user profile: ${e.toString()}');
    }
  }

  /// Update user profile
  Future<Map<String, dynamic>> updateUserProfile(String accessToken, Map<String, dynamic> data) async {
    try {
      final response = await _apiService.patch('/api/users/update-data',
          data: data,
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}));

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(response.data['Error'] ?? 'Failed to update user profile');
      }
    } catch (e) {
      throw Exception('Failed to update user profile: ${e.toString()}');
    }
  }

  /// Change user password
  Future<Map<String, dynamic>> changePassword(String accessToken, String newPassword) async {
    try {
      final response = await _apiService.put('/api/users/change-password',
          data: {'motDePasse': newPassword},
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}));

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(response.data['Error'] ?? 'Failed to change password');
      }
    } catch (e) {
      throw Exception('Failed to change password: ${e.toString()}');
    }
  }
}
