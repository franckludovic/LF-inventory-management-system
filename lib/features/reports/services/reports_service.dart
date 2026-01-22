import 'package:lf_project/core/services/api_service.dart';

class ReportsService {
  final ApiService _apiService = ApiService();

  /// Get all logs for admin
  /// Backend: GET /log/all-logs (admin only)
  Future<List<dynamic>> getAllLogsAdmin() async {
    try {
      final response = await _apiService.get('/log/all-logs');

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
  /// Backend: GET /log/all-logs-technician (technician only)
  Future<List<dynamic>> getAllLogsTechnician() async {
    try {
      final response = await _apiService.get('/log/all-logs-technician');

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
  /// Backend: GET /log/by-date, expects {startDate, endDate} in body (admin only)
  Future<List<dynamic>> getLogsByDateAdmin(DateTime startDate, DateTime endDate) async {
    try {
      final data = {
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      };

      final response = await _apiService.get('/log/by-date', queryParameters: data);

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
  /// Backend: GET /log/by-date-technician, expects {startDate, endDate} in body (technician only)
  Future<List<dynamic>> getLogsByDateTechnician(DateTime startDate, DateTime endDate) async {
    try {
      final data = {
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      };

      final response = await _apiService.get('/log/by-date-technician', queryParameters: data);

      if (response.statusCode == 200) {
        return response.data as List<dynamic>;
      } else {
        throw Exception(response.data['Error'] ?? 'Failed to get logs by date');
      }
    } catch (e) {
      throw Exception('Failed to get logs by date: ${e.toString()}');
    }
  }
}
