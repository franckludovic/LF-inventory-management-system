import 'package:get/get.dart';

class LowStockAlertsController extends GetxController {
  var selectedFilter = Rx<String?>(null);
  var criticalAlerts = <Map<String, dynamic>>[].obs;
  var lowAlerts = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadAlerts();
  }

  void loadAlerts() {
    criticalAlerts.assignAll([
      {
        'title': 'Door Hanger Roller - Type A',
        'location': 'Van Bin 4, Main Locker',
        'currentStock': 3,
        'maxStock': 10,
        'isCritical': true,
      },
      {
        'title': 'Traction Steel Cable (50m)',
        'location': 'Storage Rack B',
        'currentStock': 1,
        'maxStock': 5,
        'isCritical': true,
      },
    ]);

    lowAlerts.assignAll([
      {
        'title': 'Limit Switch - X12',
        'location': 'Emergency Bag',
        'currentStock': 6,
        'maxStock': 8,
        'isCritical': false,
      },
    ]);
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
