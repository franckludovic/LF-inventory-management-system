import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../features/home/presentation/screens/dashboard_screen.dart';
import '../../features/search/presentation/screens/search_screen.dart';
import '../../features/reports/presentation/screens/generate_report_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/Parts/presentation/screens/parts_management_screen.dart';
import '../../features/user/presentation/screens/user_management_screen.dart';
import '../../features/location/presentation/screens/location_management_screen.dart';
import 'user_controller.dart';

class NavigationMenuController extends GetxController {
  final Rx<Map<int, Widget>> _screens = Rx<Map<int, Widget>>({});

  Widget getScreen(int index) {
    if (Get.isRegistered<UserController>()) {
      final userController = Get.find<UserController>();
      final isAdmin = userController.isAdmin;

      if (!_screens.value.containsKey(index)) {
        _screens.value = Map.from(_screens.value);
        switch (index) {
          case 0:
            _screens.value[index] = const DashboardScreen();
            break;
          case 1:
            _screens.value[index] = isAdmin ? const PartsManagementScreen() : const SearchScreen();
            break;
          case 2:
            _screens.value[index] = const GenerateReportScreen();
            break;
          case 3:
            _screens.value[index] = isAdmin ? const UserManagementScreen() : const ProfileScreen();
            break;
          case 4:
            _screens.value[index] = isAdmin ? const LocationManagementScreen() : const SizedBox();
            break;
          default:
            _screens.value[index] = const SizedBox();
        }
        _screens.refresh();
      }
      return _screens.value[index]!;
    } else {
      // Fallback if UserController is not found
      if (!_screens.value.containsKey(index)) {
        _screens.value = Map.from(_screens.value);
        switch (index) {
          case 0:
            _screens.value[index] = const DashboardScreen();
            break;
          case 1:
            _screens.value[index] = const SearchScreen(); // Default to search
            break;
          case 2:
            _screens.value[index] = const GenerateReportScreen();
            break;
          case 3:
            _screens.value[index] = const ProfileScreen(); // Default to profile
            break;
          default:
            _screens.value[index] = const SizedBox();
        }
        _screens.refresh();
      }
      return _screens.value[index]!;
    }
  }
}
