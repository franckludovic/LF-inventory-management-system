import 'package:get/get.dart';
import '../controllers/low_stock_alerts_controller.dart';

class LowStockAlertsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LowStockAlertsController>(() => LowStockAlertsController());
  }
}
