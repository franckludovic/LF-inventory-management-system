import 'package:get/get.dart';
import 'navigation_controller.dart';
import '../../features/home/bindings/dashboard_binding.dart';
import '../../features/search/bindings/search_binding.dart';
import '../../features/reports/bindings/generate_report_binding.dart';
import '../../features/profile/bindings/profile_binding.dart';

class NavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavigationController>(() => NavigationController());
    DashboardBinding().dependencies();
    SearchBinding().dependencies();
    GenerateReportBinding().dependencies();
    ProfileBinding().dependencies();
  }
}
