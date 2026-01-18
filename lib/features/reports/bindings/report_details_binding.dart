import 'package:get/get.dart';
import 'package:lf_project/features/reports/controllers/report_details_controller.dart';


class ReportDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportDetailsController>(() => ReportDetailsController());
  }
}
