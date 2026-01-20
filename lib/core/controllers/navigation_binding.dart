import 'package:get/get.dart';
import 'package:lf_project/features/location/bindings/location_management_binding.dart';
import 'navigation_controller.dart';
import 'navigation_menu_controller.dart';
import 'user_controller.dart';
import '../../features/home/bindings/dashboard_binding.dart';
import '../../features/search/bindings/search_binding.dart';
import '../../features/reports/bindings/generate_report_binding.dart';
import '../../features/profile/bindings/profile_binding.dart';
import '../../features/Parts/bindings/parts_management_binding.dart';
import '../../features/user/bindings/user_management_binding.dart';
import '../../features/location/bindings/location_management_binding.dart';


class NavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<UserController>(UserController(), permanent: true);
    Get.lazyPut<NavigationController>(() => NavigationController());
    Get.lazyPut<NavigationMenuController>(() => NavigationMenuController());
    DashboardBinding().dependencies();
    SearchBinding().dependencies();
    GenerateReportBinding().dependencies();
    ProfileBinding().dependencies();
    PartsManagementBinding().dependencies();
    UserManagementBinding().dependencies();
    LocationManagementBinding().dependencies();
  }
}
