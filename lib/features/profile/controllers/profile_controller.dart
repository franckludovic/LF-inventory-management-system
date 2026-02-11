import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lf_project/features/user/services/user_service.dart';
import 'package:lf_project/core/controllers/user_controller.dart';

class ProfileController extends GetxController {
  final UserService _userService = UserService();
  final UserController _userController = Get.find<UserController>();

  // Observable variables for profile data
  var userName = 'Utilisateur'.obs;
  var employeeId = 'TX-9942'.obs;
  var email = 'utilisateur@example.com'.obs;
  var department = 'Maintenance et Réparations'.obs;
  var region = 'District Nord'.obs;
  var joinedDate = '12 Janvier 2023'.obs;


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
      Get.snackbar('Erreur', 'Échec du chargement du profil: $e');
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
    Get.snackbar('Préférences', 'Naviguer vers l\'écran des préférences');
  }

  // Method to navigate to security settings
  void navigateToSecurity() {
    // Implement navigation to security screen
    // For now, just a placeholder
    Get.snackbar('Sécurité', 'Naviguer vers l\'écran de sécurité et mot de passe');
  }


  // Edit field methods
  void editName() async {
    showEditDialog(
      title: 'Modifier le nom',
      oldValue: userName.value,
      controller: nameController,
      onConfirm: () async {
        final newName = nameController.text.trim();
        try {
          await _userService.updateUserProfile(_userController.accessToken.value, {'nom': newName});
          userName.value = newName;
          Get.back();
          Get.snackbar('Succès', 'Nom mis à jour avec succès');
        } catch (e) {
          Get.snackbar('Erreur', 'Échec de la mise à jour du nom: $e');
        }
      },
    );
  }


  void editEmail() async {
    // L'email ne peut pas être modifié - fonctionnalité non supportée par le backend
    Get.snackbar(
      'Information',
      'L\'adresse email ne peut pas être modifiée',
      snackPosition: SnackPosition.BOTTOM,
    );
  }


  void editDepartment() async {
    showEditDialog(
      title: 'Modifier le département',
      oldValue: department.value,
      controller: departmentController,
      onConfirm: () async {
        final newDepartment = departmentController.text.trim();
        try {
          await _userService.updateUserProfile(_userController.accessToken.value, {'Department': newDepartment});
          department.value = newDepartment;
          Get.back();
          Get.snackbar('Succès', 'Département mis à jour avec succès');
        } catch (e) {
          Get.snackbar('Erreur', 'Échec de la mise à jour du département: $e');
        }
      },
    );
  }


  void editRegion() async {
    showEditDialog(
      title: 'Modifier la région',
      oldValue: region.value,
      controller: regionController,
      onConfirm: () async {
        final newRegion = regionController.text.trim();
        try {
          await _userService.updateUserProfile(_userController.accessToken.value, {'region': newRegion});
          region.value = newRegion;
          Get.back();
          Get.snackbar('Succès', 'Région mise à jour avec succès');
        } catch (e) {
          Get.snackbar('Erreur', 'Échec de la mise à jour de la région: $e');
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
        title: const Text('Alerte de sécurité'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Vous utilisez actuellement les identifiants administrateur par défaut. Pour des raisons de sécurité, veuillez changer votre email et mot de passe immédiatement.',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 16),
            Text(
              'Cela aide à protéger votre compte et vos données contre les accès non autorisés.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              navigateToSecurity();
            },
            child: const Text('Changer le mot de passe'),
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
            Text('Actuel: $oldValue'),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Nouvelle valeur',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: onConfirm,
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );
  }


  void showPasswordUpdateDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Mettre à jour le mot de passe'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Mot de passe actuel',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Nouveau mot de passe',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirmer le nouveau mot de passe',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (newPasswordController.text != confirmPasswordController.text) {
                Get.snackbar('Erreur', 'Les mots de passe ne correspondent pas');
                return;
              }
              try {
                await _userService.changePassword(_userController.accessToken.value, newPasswordController.text);
                Get.back();
                Get.snackbar('Succès', 'Mot de passe mis à jour avec succès');
                // Clear controllers
                oldPasswordController.clear();
                newPasswordController.clear();
                confirmPasswordController.clear();
              } catch (e) {
                Get.snackbar('Erreur', 'Échec de la mise à jour du mot de passe: $e');
              }
            },
            child: const Text('Mettre à jour'),
          ),
        ],
      ),
    );
  }

}
