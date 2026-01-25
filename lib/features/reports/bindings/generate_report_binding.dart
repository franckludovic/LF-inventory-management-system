import 'package:get/get.dart';
import '../controllers/generate_report_controller.dart';

class GenerateReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<GenerateReportController>(GenerateReportController());
  }
}
