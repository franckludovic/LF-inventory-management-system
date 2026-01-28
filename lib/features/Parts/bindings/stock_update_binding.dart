import 'package:get/get.dart';
import '../controllers/stock_update_controller.dart';
import '../../../core/models/part_model.dart';

class StockUpdateBinding extends Bindings {
  @override
  void dependencies() {
    final part = Get.arguments as PartModel?;
    Get.lazyPut<StockUpdateController>(() => StockUpdateController(initialPart: part));
  }
}
