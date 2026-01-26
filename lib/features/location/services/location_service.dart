import 'package:lf_project/core/services/api_service.dart';

class LocationService {
  final ApiService _apiService = ApiService();

  /// Get all locations/SAC
  Future<List<dynamic>> getAllLocations() async {
    try {
      final response = await _apiService.get('/api/sacs/');

      if (response.statusCode == 200) {
        return response.data as List<dynamic>;
      } else {
        throw Exception(response.data['Error'] ?? 'Failed to get locations');
      }
    } catch (e) {
      throw Exception('Failed to get locations: ${e.toString()}');
    }
  }

  /// Create a new location/SAC
  Future<Map<String, dynamic>> createLocation({
    required String name,
    required int maxQuantity,
  }) async {
    try {
      final data = {
        'nom': name,
        'capaciteMax': maxQuantity,
      };

      final response = await _apiService.post('/api/sacs/', data: data);

      if (response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception(response.data['Error'] ?? 'Failed to create location');
      }
    } catch (e) {
      throw Exception('Failed to create location: ${e.toString()}');
    }
  }

  /// Update location
  Future<Map<String, dynamic>> updateLocation({
    required String locationId,
    String? name,
    int? maxQuantity,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (name != null) data['nom'] = name;
      if (maxQuantity != null) data['capaciteMax'] = maxQuantity;

      final response = await _apiService.put('/api/sacs/$locationId', data: data);

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(response.data['Error'] ?? 'Failed to update location');
      }
    } catch (e) {
      throw Exception('Failed to update location: ${e.toString()}');
    }
  }

  /// Delete location
  Future<Map<String, dynamic>> deleteLocation(String locationId) async {
    try {
      final response = await _apiService.delete('/api/sacs/$locationId');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(response.data['Error'] ?? 'Failed to delete location');
      }
    } catch (e) {
      throw Exception('Failed to delete location: ${e.toString()}');
    }
  }
}
