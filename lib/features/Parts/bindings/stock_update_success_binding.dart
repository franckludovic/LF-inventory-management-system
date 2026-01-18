import 'package:get/get.dart';
import '../controllers/stock_update_success_controller.dart';

class StockUpdateSuccessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StockUpdateSuccessController>(() => StockUpdateSuccessController());
  }
}
