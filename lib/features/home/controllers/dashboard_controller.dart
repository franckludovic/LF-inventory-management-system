import 'package:get/get.dart';
import '../../Parts/services/parts_service.dart';
import '../../../core/models/part_model.dart';
import '../../../core/controllers/user_controller.dart';
import '../../../core/constants/strings.dart';
import '../../../core/services/api_service.dart';

class DashboardController extends GetxController {
  var lowStockParts = <PartModel>[].obs;
  var isLoading = false.obs;
  
  // Admin Statistics
  var totalParts = 0.obs;
  var totalLocations = 0.obs;
  var totalUsers = 0.obs;
  var recentLogs = <Map<String, dynamic>>[].obs;
  var isAdminStatsLoading = false.obs;
  
  final PartsService _partsService = PartsService();
  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    loadLowStockAlerts();
    loadAdminStatistics();
  }


  Future<void> loadLowStockAlerts() async {
    try {
      isLoading.value = true;
      final userController = Get.find<UserController>();
      final allParts = await _partsService.getAllParts(userController.accessToken.value);
      final partsList = allParts.map((part) => PartModel.fromMap(part)).toList();

      // Filter parts with low stock (quantity <= 5)
      lowStockParts.assignAll(partsList.where((part) => int.parse(part.quantity) <= 5).toList());
    } catch (e) {
      Get.snackbar(AppStrings.error, AppStrings.failedToLoadLowStockAlerts);
    } finally {
      isLoading.value = false;
    }
  }

  void onActionButtonPressed(String action) {
    switch (action) {
      case 'stock':
        // TODO: Navigate to stock update screen
        Get.toNamed('/stock-update');
        break;
      case 'capture':
        // TODO: Navigate to capture screen
        print('Navigate to capture screen');
        break;
      default:
        print('Unknown action: $action');
    }
  }

  void onRestockPressed(PartModel part) {
    // TODO: Implement restock functionality
    Get.snackbar('Restock', 'Restock functionality for ${part.designation} coming soon');
  }

  void onProfileTap() {
    // TODO: Navigate to profile
    Get.toNamed('/profile');
  }

  void navigateToLowStockAlerts() {
    Get.toNamed('/low-stock-alerts');
  }

  // Admin & Technician Statistics Methods
  Future<void> loadAdminStatistics() async {
    try {
      isAdminStatsLoading.value = true;
      final userController = Get.find<UserController>();
      
      if (userController.isAdmin) {
        await Future.wait([
          _loadTotalParts(),
          _loadTotalLocations(),
          _loadTotalUsers(),
          _loadRecentLogs(),
        ]);
      } else {
        // Technician - load limited statistics
        await Future.wait([
          _loadTotalParts(),
          _loadTotalLocations(),
          _loadTechnicianLogs(),
        ]);
      }
    } catch (e) {
      print('Error loading statistics: $e');
    } finally {
      isAdminStatsLoading.value = false;
    }
  }


  Future<void> _loadTotalParts() async {
    try {
      final response = await _apiService.get('/api/composants/all');


      if (response.statusCode == 200) {
        final parts = response.data as List;
        totalParts.value = parts.length;
      }
    } catch (e) {
      print('Error loading total parts: $e');
    }
  }

  Future<void> _loadTotalLocations() async {
    try {
      final response = await _apiService.get('/api/sacs');


      if (response.statusCode == 200) {
        final locations = response.data as List;
        totalLocations.value = locations.length;
      }
    } catch (e) {
      print('Error loading total locations: $e');
    }
  }

  Future<void> _loadTotalUsers() async {
    try {
      final response = await _apiService.get('/api/users');



      if (response.statusCode == 200) {
        final users = response.data as List;
        totalUsers.value = users.length;
      }
    } catch (e) {
      print('Error loading total users: $e');
    }
  }

  Future<void> _loadRecentLogs() async {
    try {
      final response = await _apiService.get('/api/logs/all-logs');


      if (response.statusCode == 200) {
        final logs = response.data as List;
        // Take only the 5 most recent logs
        recentLogs.assignAll(logs.take(5).map((log) => log as Map<String, dynamic>).toList());
      }
    } catch (e) {
      print('Error loading recent logs: $e');
    }
  }

  Future<void> _loadTechnicianLogs() async {
    try {
      final response = await _apiService.get('/api/logs/all-logs-technician');


      if (response.statusCode == 200) {
        final logs = response.data as List;
        // Take only the 5 most recent logs for technician
        recentLogs.assignAll(logs.take(5).map((log) => log as Map<String, dynamic>).toList());
      }
    } catch (e) {
      print('Error loading technician logs: $e');
    }
  }
}
