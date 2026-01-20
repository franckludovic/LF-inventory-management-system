import 'package:get/get.dart';

class UserController extends GetxController {
  final RxString userRole = ''.obs;
  final RxString username = ''.obs;

  void setUser(String username, String role) {
    this.username.value = username;
    this.userRole.value = role;
  }

  bool get isAdmin => userRole.value == 'admin';
  bool get isTechnician => userRole.value == 'technician';

  void logout() {
    username.value = '';
    userRole.value = '';
  }
}
