import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/strings.dart';

class AddUserController extends GetxController {
  // Form controllers
  final fullNameController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // Observable variables for form validation
  var isPasswordVisible = false.obs;
  var isFormValid = false.obs;

  // Form validation
  var fullNameError = ''.obs;
  var usernameError = ''.obs;
  var passwordError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Listen to form changes for validation
    fullNameController.addListener(_validateForm);
    usernameController.addListener(_validateForm);
    passwordController.addListener(_validateForm);
  }

  @override
  void onClose() {
    // Dispose controllers
    fullNameController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void _validateForm() {
    // Validate full name
    if (fullNameController.text.trim().isEmpty) {
      fullNameError.value = 'Full name is required';
    } else if (fullNameController.text.trim().length < 2) {
      fullNameError.value = 'Full name must be at least 2 characters';
    } else {
      fullNameError.value = '';
    }

    // Validate username
    if (usernameController.text.trim().isEmpty) {
      usernameError.value = 'Username is required';
    } else if (usernameController.text.trim().length < 3) {
      usernameError.value = 'Username must be at least 3 characters';
    } else if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(usernameController.text.trim())) {
      usernameError.value = 'Username can only contain letters, numbers, and underscores';
    } else {
      usernameError.value = '';
    }

    // Validate password
    if (passwordController.text.isEmpty) {
      passwordError.value = 'Password is required';
    } else if (passwordController.text.length < 6) {
      passwordError.value = 'Password must be at least 6 characters';
    } else {
      passwordError.value = '';
    }

    // Check if form is valid
    isFormValid.value = fullNameError.value.isEmpty &&
                       usernameError.value.isEmpty &&
                       passwordError.value.isEmpty &&
                       fullNameController.text.trim().isNotEmpty &&
                       usernameController.text.trim().isNotEmpty &&
                       passwordController.text.isNotEmpty;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void onSaveTechnician() {
    if (!isFormValid.value) {
      Get.snackbar(
        'Validation Error',
        'Please fill in all required fields correctly',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Create technician data
    final technicianData = {
      'name': fullNameController.text.trim(),
      'username': usernameController.text.trim(),
      'password': passwordController.text,
      'role': AppStrings.technicianRole,
      'status': 'active',
      'avatar': 'https://via.placeholder.com/150', // Default avatar
    };

    // TODO: Call API to save technician
    // For now, just show success message and navigate back
    Get.snackbar(
      'Success',
      'Technician added successfully!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    // Navigate back to user management
    Get.back(result: technicianData);
  }

  void onCancel() {
    Get.back();
  }
}
