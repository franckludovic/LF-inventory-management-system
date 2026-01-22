import 'package:dio/dio.dart';
import 'package:lf_project/core/services/api_service.dart';

class PartsService {
  final ApiService _apiService = ApiService();

  /// Get all parts/components
  Future<List<dynamic>> getAllParts(String accessToken) async {
    final response = await _apiService.get(
      '/api/composants/all',
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ),
    );

    return response.data as List<dynamic>;
  }

  /// Search parts by name
  Future<List<dynamic>> searchPartsByName(
      String name,
      String accessToken,
  ) async {
    final response = await _apiService.get(
      '/api/composants/by-name',
      queryParameters: {'name': name},
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ),
    );

    return response.data as List<dynamic>;
  }

  /// Create a new part/component (ADMIN only)
  Future<Map<String, dynamic>> createPart(
    String accessToken, {
    required String name,
    required String reference,
    required String manufacturer,
    String? description,
    required int initialQuantity,
    required String location,
  }) async {
    final response = await _apiService.post(
      '/api/composants',
      data: {
        'nom': name,
        'reference': reference,
        'fabricant': manufacturer,
        'description': description ?? '',
        'quantiteInitiale': initialQuantity,
        'emplacement': location,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ),
    );

    return response.data;
  }

  /// Update part stock
  Future<Map<String, dynamic>> updateStock(
    String accessToken, {
    required String partId,
    required int quantity,
    required String operation,
    String? note,
  }) async {
    final endpoint = operation == 'add'
        ? '/api/composants/add-stock'
        : '/api/composants/remove-stock';

    final response = await _apiService.put(
      endpoint,
      data: {
        'partId': partId,
        'quantity': quantity,
        'note': note ?? '',
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ),
    );

    return response.data;
  }
}
