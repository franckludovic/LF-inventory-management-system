import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/colors.dart';
import '../controllers/navigation_controller.dart';
import '../../features/home/presentation/screens/dashboard_screen.dart';
import '../../features/search/presentation/screens/search_screen.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigationController navController = Get.put(NavigationController());

    return Scaffold(
      body: Obx(() {
        switch (navController.selectedIndex.value) {
          case 0:
            return const DashboardScreen();
          case 1:
            return const SearchScreen();
          default:
            return const SizedBox();
        }
      }),
      bottomNavigationBar: Obx(
        () => NavigationBar(
          selectedIndex: navController.selectedIndex.value,
          onDestinationSelected: navController.changeTab,
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? AppColors.backgroundDark
              : AppColors.backgroundLight,
          indicatorColor: AppColors.primary.withOpacity(0.1),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.search_outlined),
              selectedIcon: Icon(Icons.search),
              label: 'Search',
            ),
            NavigationDestination(
              icon: Icon(Icons.history_outlined),
              selectedIcon: Icon(Icons.history),
              label: 'Reports',
            ),
            NavigationDestination(
              icon: Icon(Icons.account_circle_outlined),
              selectedIcon: Icon(Icons.account_circle),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
