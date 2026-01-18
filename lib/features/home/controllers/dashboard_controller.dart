import 'package:get/get.dart';

class DashboardController extends GetxController {

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

  void onRestockPressed(String item) {
    // TODO: Implement restock functionality
    print('Restock: $item');
  }

  void onProfileTap() {
    // TODO: Navigate to profile
    Get.toNamed('/profile');
  }

  void navigateToLowStockAlerts() {
    Get.toNamed('/low-stock-alerts');
  }
}
