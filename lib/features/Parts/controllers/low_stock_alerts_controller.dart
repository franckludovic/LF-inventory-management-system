import 'package:get/get.dart';
import '../../../core/models/part_model.dart';
import '../services/parts_service.dart';
import '../../../core/controllers/user_controller.dart';

class LowStockAlertsController extends GetxController {
  var selectedFilter = Rx<String?>(null);
  var criticalAlerts = <Map<String, dynamic>>[].obs;
  var lowAlerts = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  final PartsService _partsService = PartsService();

  @override
  void onInit() {
    super.onInit();
    loadAlerts();
  }

  Future<void> loadAlerts() async {
    try {
      isLoading.value = true;
      final userController = Get.find<UserController>();
      final partsData = await _partsService.getAllParts(userController.accessToken.value);
      final parts = partsData.map((part) => PartModel.fromMap(part)).toList();

      final critical = <Map<String, dynamic>>[];
      final low = <Map<String, dynamic>>[];

      for (final part in parts) {
        if (part.isLowStock) {
          final alert = {
            'title': part.name,
            'location': part.location,
            'currentStock': part.quantity,
            'maxStock': 10,
            'isCritical': int.parse(part.quantity) <= 2, // Critical if 2 or less
          };

          if (int.parse(part.quantity) <= 2) {
            critical.add(alert);
          } else {
            low.add(alert);
          }
        }
      }

      criticalAlerts.assignAll(critical);
      lowAlerts.assignAll(low);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load alerts: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void onFilterSelected(String? filter) {
    selectedFilter.value = filter;
  }

  void onOrderPressed(String title) {
    // Handle order action
    Get.snackbar('Order', 'Ordering $title');
  }

  void onRestockAllPressed() {
    // Handle restock all critical items
    Get.snackbar('Restock', 'Restocking all critical items');
  }

  List<Map<String, dynamic>> getFilteredCriticalAlerts() {
    if (selectedFilter.value == null || selectedFilter.value == 'All Alerts') {
      return criticalAlerts;
    } else if (selectedFilter.value == 'Critical Only') {
      return criticalAlerts;
    }
    return [];
  }

  List<Map<String, dynamic>> getFilteredLowAlerts() {
    if (selectedFilter.value == null || selectedFilter.value == 'All Alerts') {
      return lowAlerts;
    }
    return [];
  }
}
