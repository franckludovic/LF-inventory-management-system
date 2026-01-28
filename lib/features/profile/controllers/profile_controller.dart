import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lf_project/features/user/services/user_service.dart';
import 'package:lf_project/core/controllers/user_controller.dart';

class ProfileController extends GetxController {
  final UserService _userService = UserService();
  final UserController _userController = Get.find<UserController>();

  // Observable variables for profile data
  var userName = 'John Doe'.obs;
  var employeeId = 'TX-9942'.obs;
  var email = 'j.doe@elevator-tech.com'.obs;
  var department = 'Maintenance & Repairs'.obs;
  var region = 'North District'.obs;
  var joinedDate = 'January 12, 2023'.obs;

  // Observable for user role
  var userRole = ''.obs;

  // Observable for showing default credentials notification
  var showDefaultCredentialsWarning = false.obs;

  // Text controllers for editing
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController regionController = TextEditingController();

  // Password update controllers
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // Load profile data from API
    loadProfile();

    // Sync user role from UserController
    userRole.value = _userController.userRole.join(', ');

    // Check if using default credentials
    checkForDefaultCredentials();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    departmentController.dispose();
    regionController.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  // Method to load profile data from API
  void loadProfile() async {
    try {
      final profile = await _userService.getUserProfile(_userController.accessToken.value);
      userName.value = profile['nom'] ?? userName.value;
      employeeId.value = profile['id']?.toString() ?? employeeId.value;
      email.value = profile['email'] ?? email.value;
      department.value = profile['Department'] ?? department.value;
      region.value = profile['region'] ?? region.value;
      joinedDate.value = profile['createdAt'] != null
          ? DateTime.parse(profile['createdAt']).toString().split(' ')[0]
          : joinedDate.value;

      // Update text controllers
      nameController.text = userName.value;
      emailController.text = email.value;
      departmentController.text = department.value;
      regionController.text = region.value;

      // Update UserController profile
      _userController.setUserProfile(profile);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load profile: $e');
    }
  }

  // Method to handle logout
  void logout() {
    // Implement logout logic here, e.g., clear session, navigate to login
    Get.offAllNamed('/login'); // Assuming login route exists
  }

  // Method to navigate to preferences
  void navigateToPreferences() {
    // Implement navigation to preferences screen
    // For now, just a placeholder
    Get.snackbar('Preferences', 'Navigate to Preferences Screen');
  }

  // Method to navigate to security settings
  void navigateToSecurity() {
    // Implement navigation to security screen
    // For now, just a placeholder
    Get.snackbar('Security', 'Navigate to Security & Password Screen');
  }

  // Edit field methods
  void editName() async {
    showEditDialog(
      title: 'Edit Name',
      oldValue: userName.value,
      controller: nameController,
      onConfirm: () async {
        final newName = nameController.text.trim();
        try {
          await _userService.updateUserProfile(_userController.accessToken.value, {'nom': newName});
          userName.value = newName;
          Get.back();
          Get.snackbar('Success', 'Name updated successfully');
        } catch (e) {
          Get.snackbar('Error', 'Failed to update name: $e');
        }
      },
    );
  }

  void editEmail() async {
    showEditDialog(
      title: 'Edit Email',
      oldValue: email.value,
      controller: emailController,
      onConfirm: () async {
        final newEmail = emailController.text.trim();
        try {
          await _userService.updateUserProfile(_userController.accessToken.value, {'email': newEmail});
          email.value = newEmail;
          Get.back();
          Get.snackbar('Success', 'Email updated successfully');
        } catch (e) {
          Get.snackbar('Error', 'Failed to update email: $e');
        }
      },
    );
  }

  void editDepartment() async {
    showEditDialog(
      title: 'Edit Department',
      oldValue: department.value,
      controller: departmentController,
      onConfirm: () async {
        final newDepartment = departmentController.text.trim();
        try {
          await _userService.updateUserProfile(_userController.accessToken.value, {'Department': newDepartment});
          department.value = newDepartment;
          Get.back();
          Get.snackbar('Success', 'Department updated successfully');
        } catch (e) {
          Get.snackbar('Error', 'Failed to update department: $e');
        }
      },
    );
  }

  void editRegion() async {
    showEditDialog(
      title: 'Edit Region',
      oldValue: region.value,
      controller: regionController,
      onConfirm: () async {
        final newRegion = regionController.text.trim();
        try {
          await _userService.updateUserProfile(_userController.accessToken.value, {'region': newRegion});
          region.value = newRegion;
          Get.back();
          Get.snackbar('Success', 'Region updated successfully');
        } catch (e) {
          Get.snackbar('Error', 'Failed to update region: $e');
        }
      },
    );
  }

  void updatePassword() {
    showPasswordUpdateDialog();
  }

  // Method to check if using default credentials
  void checkForDefaultCredentials() {
    // TODO: Replace with actual user data from API/backend
    // For now, using hardcoded check for demo
    if (email.value == 'admin@gmail.com' && userName.value == 'admin') {
      showDefaultCredentialsWarning.value = true;
    }
  }

  // Method to show default credentials warning modal
  void showDefaultCredentialsWarningModal() {
    Get.dialog(
      AlertDialog(
        title: const Text('Security Alert'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'You are currently using the default admin credentials. For security reasons, please change your email and password immediately.',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 16),
            Text(
              'This helps protect your account and data from unauthorized access.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              navigateToSecurity();
            },
            child: const Text('Change Password'),
          ),
        ],
      ),
    );
  }

  void showEditDialog({
    required String title,
    required String oldValue,
    required TextEditingController controller,
    required VoidCallback onConfirm,
  }) {
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Current: $oldValue'),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'New Value',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: onConfirm,
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void showPasswordUpdateDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Update Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Current Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm New Password',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (newPasswordController.text != confirmPasswordController.text) {
                Get.snackbar('Error', 'Passwords do not match');
                return;
              }
              try {
                await _userService.changePassword(_userController.accessToken.value, newPasswordController.text);
                Get.back();
                Get.snackbar('Success', 'Password updated successfully');
                // Clear controllers
                oldPasswordController.clear();
                newPasswordController.clear();
                confirmPasswordController.clear();
              } catch (e) {
                Get.snackbar('Error', 'Failed to update password: $e');
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}
