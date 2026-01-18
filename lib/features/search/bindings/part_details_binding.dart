import 'package:get/get.dart';
import '../controllers/part_details_controller.dart';
import '../../../core/models/part_model.dart';

class PartDetailsBinding extends Bindings {
  @override
  void dependencies() {
    final part = Get.arguments as PartModel;
    Get.put<PartDetailsController>(PartDetailsController(part));
  }
}
