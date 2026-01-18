import 'package:get/get.dart';

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  void changeTab(int index) {
    selectedIndex.value = index;

    switch (index) {
      case 0:
        Get.toNamed('/dashboard');
        break;
      case 1:
        Get.toNamed('/search');
        break;
      case 2:
        Get.toNamed('/generate-report');
        break;
      case 3:
        Get.toNamed('/profile');
        break;
    }
  }
}
