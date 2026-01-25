import 'package:lf_project/core/services/api_service.dart';

class SearchService {
  final ApiService _apiService = ApiService();

  /// Search parts by name
  /// Backend: GET /composant/by-name, expects {nom: name} in body
  Future<List<dynamic>> searchPartsByName(String name) async {
    try {
      
      final response = await _apiService.get('/composant/by-name',  queryParameters: {'nom': name});

      if (response.statusCode == 200) {
        return response.data as List<dynamic>;
      } else {
        throw Exception(response.data['Error'] ?? 'Search failed');
      }
    } catch (e) {
      throw Exception('Search failed: ${e.toString()}');
    }
  }

  /// Advanced search with filters
  Future<List<dynamic>> advancedSearch({
    String? name,
    String? manufacturer,
    String? location,
    int? minQuantity,
    int? maxQuantity,
    String? category,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (name != null && name.isNotEmpty) queryParams['name'] = name;
      if (manufacturer != null && manufacturer.isNotEmpty) queryParams['manufacturer'] = manufacturer;
      if (location != null && location.isNotEmpty) queryParams['location'] = location;
      if (minQuantity != null) queryParams['minQuantity'] = minQuantity.toString();
      if (maxQuantity != null) queryParams['maxQuantity'] = maxQuantity.toString();
      if (category != null && category.isNotEmpty) queryParams['category'] = category;

      final response = await _apiService.get('/composant/advanced-search', queryParameters: queryParams);

      if (response.statusCode == 200) {
        return response.data as List<dynamic>;
      } else {
        throw Exception(response.data['Error'] ?? 'Advanced search failed');
      }
    } catch (e) {
      throw Exception('Advanced search failed: ${e.toString()}');
    }
  }

  /// Get search suggestions
  Future<List<String>> getSearchSuggestions(String query) async {
    try {
      final response = await _apiService.get('/composant/suggestions', queryParameters: {'q': query});

      if (response.statusCode == 200) {
        return List<String>.from(response.data);
      } else {
        throw Exception(response.data['Error'] ?? 'Failed to get suggestions');
      }
    } catch (e) {
      throw Exception('Failed to get suggestions: ${e.toString()}');
    }
  }

  /// Get recent searches for user
  Future<List<String>> getRecentSearches() async {
    try {
      final response = await _apiService.get('/search/recent');

      if (response.statusCode == 200) {
        return List<String>.from(response.data);
      } else {
        throw Exception(response.data['Error'] ?? 'Failed to get recent searches');
      }
    } catch (e) {
      throw Exception('Failed to get recent searches: ${e.toString()}');
    }
  }

  /// Save search query
  Future<Map<String, dynamic>> saveSearchQuery(String query) async {
    try {
      final response = await _apiService.post('/search/save', data: {'query': query});

      if (response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception(response.data['Error'] ?? 'Failed to save search');
      }
    } catch (e) {
      throw Exception('Failed to save search: ${e.toString()}');
    }
  }
}
