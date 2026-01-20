import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/colors.dart';
import '../controllers/navigation_controller.dart';
import '../controllers/navigation_menu_controller.dart';
import '../controllers/user_controller.dart';

class NavigationMenu extends GetView<NavigationMenuController> {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigationController navController = Get.find<NavigationController>();
    final UserController userController = Get.find<UserController>();

    List<NavigationDestination> destinations = [
      const NavigationDestination(
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home),
        label: 'Home',
      ),
      if (userController.isAdmin)
        const NavigationDestination(
          icon: Icon(Icons.build_outlined),
          selectedIcon: Icon(Icons.build),
          label: 'Parts',
        )
      else
        const NavigationDestination(
          icon: Icon(Icons.search_outlined),
          selectedIcon: Icon(Icons.search),
          label: 'Search',
        ),
      const NavigationDestination(
        icon: Icon(Icons.history_outlined),
        selectedIcon: Icon(Icons.history),
        label: 'Reports',
      ),
      if (userController.isAdmin)
        const NavigationDestination(
          icon: Icon(Icons.people_outlined),
          selectedIcon: Icon(Icons.people),
          label: 'Users',
        )
      else
        const NavigationDestination(
          icon: Icon(Icons.account_circle_outlined),
          selectedIcon: Icon(Icons.account_circle),
          label: 'Profile',
        ),
      if (userController.isAdmin)
        const NavigationDestination(
          icon: Icon(Icons.location_on_outlined),
          selectedIcon: Icon(Icons.location_on),
          label: 'Location',
        ),
    ];

    return Scaffold(
      body: Obx(() => controller.getScreen(navController.selectedIndex.value)),
      bottomNavigationBar: Obx(
        () => NavigationBar(
          selectedIndex: navController.selectedIndex.value,
          onDestinationSelected: navController.changeTab,
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? AppColors.backgroundDark
              : AppColors.backgroundLight,
          indicatorColor: AppColors.primary.withOpacity(0.1),
          destinations: destinations,
        ),
      ),
    );
  }
}
