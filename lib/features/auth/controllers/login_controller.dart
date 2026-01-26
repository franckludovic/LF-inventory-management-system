import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lf_project/core/constants/strings.dart';
import 'package:lf_project/core/controllers/user_controller.dart';
import 'package:lf_project/core/utils/error_handler.dart';
import 'package:lf_project/features/auth/services/auth_service.dart';


class LoginController extends GetxController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  Future<void> handleLogin() async {
    errorMessage.value = '';

    final email = usernameController.text.trim().toLowerCase();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      errorMessage.value = AppStrings.validationError;
      return;
    }

    try {
      isLoading.value = true;

      final authService = AuthService();
      final data = await authService.login(email, password);

      final userController = Get.find<UserController>();

      // Store user data and tokens
      userController.setUser(data['nom'] ?? data['email'] ?? 'User', List<String>.from(data['role'] ?? []));
      userController.setTokens(data['accessToken'] ?? '', data['refreshToken'] ?? '');

      // Store tokens in secure storage for persistence
      // TODO: Implement secure storage for tokens

      Get.offAllNamed('/');
    } catch (e) {
      errorMessage.value = ErrorHandler.getErrorMessage(e);
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

