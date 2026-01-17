import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../features/home/presentation/screens/dashboard_screen.dart';
import '../../features/search/presentation/screens/search_screen.dart';

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final List<Widget> screens = [
    const DashboardScreen(), // Home
    const SearchScreen(), // Search
    const Center(child: Text('Reports Screen')),
    const Center(child: Text('Profile Screen')),
  ];

  void changeTab(int index) {
    selectedIndex.value = index;
  }
}
