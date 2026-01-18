import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lf_project/core/constants/strings.dart';


class LoginController extends GetxController {
  // -------------------- TEXT CONTROLLERS --------------------
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // -------------------- STATE --------------------
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // -------------------- LOGIN HANDLER --------------------
  Future<void> handleLogin() async {
    // Clear previous error
    errorMessage.value = '';

    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    // -------------------- VALIDATION --------------------
    if (username.isEmpty || password.isEmpty) {
      errorMessage.value = AppStrings.validationError;
      return;
    }

    try {
      isLoading.value = true;

      //  Simulate API call ( renplcase apres)
      await Future.delayed(const Duration(seconds: 2));

      // -------------------- MOCK LOGIN LOGIC --------------------
      if (username == 'test' && password == 'test') {
        // ✅ SUCCESS → Navigate to home
        Get.offAllNamed('/home');
      } else {
        errorMessage.value = 'Invalid username or password';
      }
    } catch (e) {
      errorMessage.value = 'Something went wrong. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  // -------------------- CLEANUP --------------------
  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
