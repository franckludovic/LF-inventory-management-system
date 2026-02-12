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
        throw Exception(response.data['Error'] ?? 'Échec de la récupération des utilisateurs');
      }
    } catch (e) {
      throw Exception('Échec de la récupération des utilisateurs: ${e.toString()}');

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
    required List<String> role,
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
        throw Exception(response.data['Error'] ?? 'Échec de la création de l\'utilisateur');
      }
    } catch (e) {
      throw Exception('Échec de la création de l\'utilisateur: ${e.toString()}');

    }
  }

  /// Promote user to admin role
  Future<Map<String, dynamic>> promoteToAdmin(String userId) async {
    try {
      final response = await _apiService.patch('/api/users/add-admin/$userId');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(response.data['Error'] ?? 'Échec de la promotion de l\'utilisateur');
      }
    } catch (e) {
      throw Exception('Échec de la promotion de l\'utilisateur: ${e.toString()}');

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
        throw Exception(response.data['Error'] ?? 'Échec de la récupération du profil utilisateur');
      }
    } catch (e) {
      throw Exception('Échec de la récupération du profil utilisateur: ${e.toString()}');

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
        throw Exception(response.data['Error'] ?? 'Échec de la mise à jour du profil utilisateur');
      }
    } catch (e) {
      throw Exception('Échec de la mise à jour du profil utilisateur: ${e.toString()}');

    }
  }

  /// Update user data
  Future<Map<String, dynamic>> updateUser(String userId, Map<String, dynamic> data) async {
    try {
      final response = await _apiService.patch('/api/users/update-other-data/$userId', data: data);

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(response.data['Error'] ?? 'Échec de la mise à jour de l\'utilisateur');
      }
    } catch (e) {
      throw Exception('Échec de la mise à jour de l\'utilisateur: ${e.toString()}');

    }
  }

  /// Change user password
  Future<Map<String, dynamic>> changePassword(String accessToken, String newPassword) async {
    try {
      final response = await _apiService.patch('/api/users/change-password',
          data: {'motDePasse': newPassword},
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}));

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(response.data['Error'] ?? 'Échec du changement de mot de passe');
      }
    } catch (e) {
      throw Exception('Échec du changement de mot de passe: ${e.toString()}');
    }
  }

  /// Change another user's password (admin only)
  Future<Map<String, dynamic>> changeUserPassword(String userId, String newPassword) async {
    try {
      final response = await _apiService.patch(
        '/api/users/change-password/$userId',
        data: {'motDePasse': newPassword},
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(response.data['Error'] ?? 'Échec du changement de mot de passe');
      }
    } catch (e) {
      throw Exception('Échec du changement de mot de passe: ${e.toString()}');
    }
  }

}
