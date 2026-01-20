import 'package:get/get.dart';
import '../controllers/parts_management_controller.dart';

class PartsManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PartsManagementController>(() => PartsManagementController());
  }
}
