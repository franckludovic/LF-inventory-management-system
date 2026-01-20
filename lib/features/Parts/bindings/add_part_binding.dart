import 'package:get/get.dart';
import '../controllers/add_part_controller.dart';

class AddPartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddPartController>(() => AddPartController());
  }
}
