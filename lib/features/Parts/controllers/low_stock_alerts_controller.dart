import 'package:get/get.dart';
import '../../../core/models/part_model.dart';
import '../services/parts_service.dart';
import '../../../core/controllers/user_controller.dart';

class LowStockAlertsController extends GetxController {
  var selectedFilter = Rx<String?>(null);
  var criticalParts = <PartModel>[].obs;
  var lowParts = <PartModel>[].obs;
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

      final critical = <PartModel>[];
      final low = <PartModel>[];

      for (final part in parts) {
        if (part.isLowStock) {
          if (int.parse(part.quantity) <= 2) {
            critical.add(part);
          } else {
            low.add(part);
          }
        }
      }

      criticalParts.assignAll(critical);
      lowParts.assignAll(low);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load alerts: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void onFilterSelected(String? filter) {
    selectedFilter.value = filter ?? 'All Alerts';
  }

  void onOrderPressed(String title) {
    // Handle order action
    Get.snackbar('Order', 'Ordering $title');
  }

  void onRestockAllPressed() {
    // Handle restock all critical items
    Get.snackbar('Restock', 'Restocking all critical items');
  }

  List<PartModel> getFilteredCriticalParts() {
    if (selectedFilter.value == null || selectedFilter.value == 'All Alerts') {
      return criticalParts;
    } else if (selectedFilter.value == 'Critical Only') {
      return criticalParts;
    }
    return [];
  }

  List<PartModel> getFilteredLowParts() {
    if (selectedFilter.value == null || selectedFilter.value == 'All Alerts') {
      return lowParts;
    } else if (selectedFilter.value == 'Low Only') {
      return lowParts;
    }
    return [];
  }
}
