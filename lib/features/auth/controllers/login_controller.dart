import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lf_project/core/constants/strings.dart';
import 'package:lf_project/core/controllers/user_controller.dart';


// class LoginController extends GetxController {
//   // -------------------- TEXT CONTROLLERS --------------------
//   final TextEditingController usernameController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   // -------------------- STATE --------------------
//   final RxBool isLoading = false.obs;
//   final RxString errorMessage = ''.obs;

//   // -------------------- LOGIN HANDLER --------------------
//   Future<void> handleLogin() async {
//     // Clear previous error
//     errorMessage.value = '';

//     final username = usernameController.text.trim();
//     final password = passwordController.text.trim();

//     // -------------------- VALIDATION --------------------
//     if (username.isEmpty || password.isEmpty) {
//       errorMessage.value = AppStrings.validationError;
//       return;
//     }

//     try {
//       isLoading.value = true;

//       //  Simulate API call ( renplcase apres)
//       await Future.delayed(const Duration(seconds: 2));

//       // -------------------- MOCK LOGIN LOGIC --------------------
//       if (username == 'test' && password == 'test') {
//         // ✅ SUCCESS → Navigate to home
//         Get.offAllNamed('/home');
//       } else {
//         errorMessage.value = 'Invalid username or password';
//       }
//     } catch (e) {
//       errorMessage.value = 'Something went wrong. Please try again.';
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // -------------------- CLEANUP --------------------
//   @override
//   void onClose() {
//     usernameController.dispose();
//     passwordController.dispose();
//     super.onClose();
//   }
// }

class LoginController extends GetxController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  Future<void> handleLogin() async {
    errorMessage.value = '';

    final username = usernameController.text.trim().toLowerCase();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      errorMessage.value = AppStrings.validationError;
      return;
    }

    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 1));

      final userController = Get.find<UserController>();

      if (username == 'admin' && password == 'admin') {
        userController.setUser('admin', 'admin');
        Get.offAllNamed('/');
      }
      else if (username == 'test' && password == 'test') {
        userController.setUser('test', 'technician');
        Get.offAllNamed('/');
      }
      else {
        errorMessage.value = 'Invalid username or password';
      }
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}

