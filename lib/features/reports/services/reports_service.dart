import 'package:lf_project/core/services/api_service.dart';
import '../../../core/models/user_model.dart';
import '../../user/services/user_service.dart';

class ReportsService {
  final ApiService _apiService = ApiService();
  final UserService _userService = UserService();

  /// Get all logs for admin
  /// Backend: GET /api/logs/all-logs (admin only)
  Future<List<dynamic>> getAllLogsAdmin() async {
    try {
      final response = await _apiService.get('/api/logs/all-logs');

      if (response.statusCode == 200) {
        return response.data as List<dynamic>;
      } else {
        throw Exception(response.data['Error'] ?? 'Failed to get logs');
      }
    } catch (e) {
      throw Exception('Failed to get logs: ${e.toString()}');
    }
  }

  /// Get all logs for technician (own logs only)
  /// Backend: GET /api/logs/all-logs-technician (technician only)
  Future<List<dynamic>> getAllLogsTechnician() async {
    try {
      final response = await _apiService.get('/api/logs/all-logs-technician');

      if (response.statusCode == 200) {
        return response.data as List<dynamic>;
      } else {
        throw Exception(response.data['Error'] ?? 'Failed to get logs');
      }
    } catch (e) {
      throw Exception('Failed to get logs: ${e.toString()}');
    }
  }

  /// Get logs by date range for admin
  /// Backend: GET /api/logs/by-date, expects {startDate, endDate} in body (admin only)
  Future<List<dynamic>> getLogsByDateAdmin(DateTime startDate, DateTime endDate) async {
    try {
      final data = {
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      };

      final response = await _apiService.get('/api/logs/by-date', queryParameters: data);

      if (response.statusCode == 200) {
        return response.data as List<dynamic>;
      } else {
        throw Exception(response.data['Error'] ?? 'Failed to get logs by date');
      }
    } catch (e) {
      throw Exception('Failed to get logs by date: ${e.toString()}');
    }
  }

  /// Get logs by date range for technician (own logs only)
  /// Backend: GET /api/logs/all-logs-technician, then filter by date on frontend
  Future<List<dynamic>> getLogsByDateTechnician(DateTime startDate, DateTime endDate) async {
    try {
      // Get all technician logs
      final response = await _apiService.get('/api/logs/all-logs-technician');

      if (response.statusCode == 200) {
        final allLogs = response.data as List<dynamic>;

        // Filter by date range on frontend
        final filteredLogs = allLogs.where((log) {
          final logDate = DateTime.parse(log['created_at']);
          return logDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
                 logDate.isBefore(endDate.add(const Duration(days: 1)));
        }).toList();

        return filteredLogs;
      } else {
        throw Exception(response.data['Error'] ?? 'Failed to get logs');
      }
    } catch (e) {
      throw Exception('Failed to get logs by date: ${e.toString()}');
    }
  }

  /// Get all technicians (users with role ROLE_TECHNICIAN)
  Future<List<UserModel>> getTechnicians() async {
    try {
      final usersData = await _userService.getAllUsers();
      final technicians = usersData
          .where((user) => (user['role'] as List<dynamic>).contains('ROLE_TECHNICIAN'))
          .map((user) => UserModel.fromMap(user))
          .toList();
      return technicians;
    } catch (e) {
      throw Exception('Failed to get technicians: ${e.toString()}');
    }
  }

  /// Get all users (technicians and admins)
  Future<List<UserModel>> getAllUsers() async {
    try {
      final usersData = await _userService.getAllUsers();
      return usersData.map((user) => UserModel.fromMap(user)).toList();
    } catch (e) {
      throw Exception('Failed to get users: ${e.toString()}');
    }
  }
}
