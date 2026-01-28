import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/strings.dart';
import '../services/user_service.dart';

class AddUserController extends GetxController {
  // Form controllers
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final departmentController = TextEditingController();
  final regionController = TextEditingController();
  final villeController = TextEditingController();
  final passwordController = TextEditingController();

  // Role selection
  var selectedRole = 'Technician'.obs;

  // Editing mode
  var isEditing = false.obs;
  var userToEdit = <String, dynamic>{}.obs;
  var isUserBlocked = false.obs;

  // Observable variables for form validation
  var isPasswordVisible = false.obs;
  var isFormValid = false.obs;

  // Form validation
  var fullNameError = ''.obs;
  var emailError = ''.obs;
  var departmentError = ''.obs;
  var regionError = ''.obs;
  var villeError = ''.obs;
  var passwordError = ''.obs;

  final UserService _userService = UserService();

  @override
  void onInit() {
    super.onInit();
    // Listen to form changes for validation
    fullNameController.addListener(_validateForm);
    emailController.addListener(_validateForm);
    departmentController.addListener(_validateForm);
    regionController.addListener(_validateForm);
    villeController.addListener(_validateForm);
    passwordController.addListener(_validateForm);

    // Check if editing
    final args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      loadUserForEditing(args);
    }
  }

  @override
  void onClose() {
    // Dispose controllers
    fullNameController.dispose();
    emailController.dispose();
    departmentController.dispose();
    regionController.dispose();
    villeController.dispose();
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

    // Validate email
    if (emailController.text.trim().isEmpty) {
      emailError.value = 'Email is required';
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(emailController.text.trim())) {
      emailError.value = 'Enter a valid email address';
    } else {
      emailError.value = '';
    }

    // Validate department
    if (departmentController.text.trim().isEmpty) {
      departmentError.value = 'Department is required';
    } else {
      departmentError.value = '';
    }

    // Validate region
    if (regionController.text.trim().isEmpty) {
      regionError.value = 'Region is required';
    } else {
      regionError.value = '';
    }

    // Validate ville
    if (villeController.text.trim().isEmpty) {
      villeError.value = 'Ville is required';
    } else {
      villeError.value = '';
    }

    // Validate password
    if (!isEditing.value && passwordController.text.isEmpty) {
      passwordError.value = 'Password is required';
    } else if (passwordController.text.isNotEmpty && passwordController.text.length < 6) {
      passwordError.value = 'Password must be at least 6 characters';
    } else {
      passwordError.value = '';
    }

    // Check if form is valid
    isFormValid.value = fullNameError.value.isEmpty &&
                       emailError.value.isEmpty &&
                       departmentError.value.isEmpty &&
                       regionError.value.isEmpty &&
                       villeError.value.isEmpty &&
                       passwordError.value.isEmpty &&
                       fullNameController.text.trim().isNotEmpty &&
                       emailController.text.trim().isNotEmpty &&
                       departmentController.text.trim().isNotEmpty &&
                       regionController.text.trim().isNotEmpty &&
                       villeController.text.trim().isNotEmpty &&
                       (isEditing.value || passwordController.text.isNotEmpty);
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> onSaveTechnician() async {
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

    try {
      // Determine role based on selection
      List<String> role = selectedRole.value == 'Admin' ? ["ROLE_ADMIN"] : ["ROLE_TECHNICIAN"];

      // Call API to create user
      await _userService.createUser(
        nom: fullNameController.text.trim(),
        email: emailController.text.trim(),
        motDePasse: passwordController.text,
        department: departmentController.text.trim(),
        region: regionController.text.trim(),
        ville: villeController.text.trim(),
        role: role,
      );

      Get.snackbar(
        'Success',
        'User added successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Navigate back to user management
      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add user: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void loadUserForEditing(Map<String, dynamic> user) {
    isEditing.value = true;
    userToEdit.value = user;

    fullNameController.text = user['nom'] ?? '';
    emailController.text = user['email'] ?? '';
    departmentController.text = user['Department'] ?? '';
    regionController.text = user['region'] ?? '';
    villeController.text = user['ville'] ?? '';

    // Set role
    if (user['role'] is List && user['role'].isNotEmpty) {
      String roleStr = user['role'][0];
      selectedRole.value = roleStr.contains('ADMIN') ? 'Admin' : 'Technician';
    }

    // Set blocked status (assuming 'status' field exists, default to false if not)
    isUserBlocked.value = user['status'] == 'blocked';

    // Password is not pre-filled for security
    _validateForm();
  }

  Future<void> onSaveUser() async {
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

    try {
      if (isEditing.value) {
        // Update user
        await _userService.updateUser(
          userToEdit['id'],
          {
            'nom': fullNameController.text.trim(),
            'Department': departmentController.text.trim(),
            'region': regionController.text.trim(),
            'ville': villeController.text.trim(),
          },
        );

        // Note: Block/Unblock functionality not implemented in backend yet
        // The isUserBlocked toggle is for UI only

        Get.snackbar(
          'Success',
          'User updated successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Return updated user data to update the list
        final updatedUser = {
          ...userToEdit,
          'nom': fullNameController.text.trim(),
          'email': emailController.text.trim(),
          'Department': departmentController.text.trim(),
          'region': regionController.text.trim(),
          'ville': villeController.text.trim(),
          'role': selectedRole.value == 'Admin' ? ["ROLE_ADMIN"] : ["ROLE_TECHNICIAN"],
          'status': isUserBlocked.value ? 'blocked' : 'active',
        };
        Get.back(result: updatedUser);
      } else {
        // Create user
        List<String> role = selectedRole.value == 'Admin' ? ["ROLE_ADMIN"] : ["ROLE_TECHNICIAN"];

        await _userService.createUser(
          nom: fullNameController.text.trim(),
          email: emailController.text.trim(),
          motDePasse: passwordController.text,
          department: departmentController.text.trim(),
          region: regionController.text.trim(),
          ville: villeController.text.trim(),
          role: role,
        );

        Get.snackbar(
          'Success',
          'User added successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Return new user data to add to the list
        final newUser = {
          'id': DateTime.now().millisecondsSinceEpoch, // Temporary ID
          'nom': fullNameController.text.trim(),
          'email': emailController.text.trim(),
          'Department': departmentController.text.trim(),
          'region': regionController.text.trim(),
          'ville': villeController.text.trim(),
          'role': role,
          'status': 'active',
        };
        Get.back(result: newUser);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to ${isEditing.value ? 'update' : 'add'} user: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void onCancel() {
    Get.back();
  }
}
