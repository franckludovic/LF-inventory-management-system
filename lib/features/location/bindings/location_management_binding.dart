import 'package:get/get.dart';
import '../controllers/location_management_controller.dart';

class LocationManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LocationManagementController>(() => LocationManagementController());
  }
}
