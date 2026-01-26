import 'package:get/get.dart';
import '../../Parts/services/parts_service.dart';
import '../../../core/models/part_model.dart';
import '../../../core/controllers/user_controller.dart';

class DashboardController extends GetxController {
  var lowStockParts = <PartModel>[].obs;
  var isLoading = false.obs;
  final PartsService _partsService = PartsService();

  @override
  void onInit() {
    super.onInit();
    loadLowStockAlerts();
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
      Get.snackbar('Error', 'Failed to load low stock alerts: $e');
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
}
