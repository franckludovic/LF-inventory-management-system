import 'package:get/get.dart';
import '../../../core/controllers/custom_search_controller.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomSearchController>(() => CustomSearchController());
  }
}
