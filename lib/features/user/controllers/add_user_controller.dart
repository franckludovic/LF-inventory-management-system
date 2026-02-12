import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/strings.dart';
import '../../../core/utils/snackbar_utils.dart';
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
  var isLoading = false.obs;

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
      fullNameError.value = 'Le nom complet est requis';
    } else if (fullNameController.text.trim().length < 2) {
      fullNameError.value = 'Le nom complet doit contenir au moins 2 caractères';
    } else {
      fullNameError.value = '';
    }

    // Validate email
    if (emailController.text.trim().isEmpty) {
      emailError.value = 'L\'email est requis';
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(emailController.text.trim())) {
      emailError.value = 'Entrez une adresse email valide';
    } else {
      emailError.value = '';
    }

    // Validate department
    if (departmentController.text.trim().isEmpty) {
      departmentError.value = 'Le département est requis';
    } else {
      departmentError.value = '';
    }

    // Validate region
    if (regionController.text.trim().isEmpty) {
      regionError.value = 'La région est requise';
    } else {
      regionError.value = '';
    }

    // Validate ville
    if (villeController.text.trim().isEmpty) {
      villeError.value = 'La ville est requise';
    } else {
      villeError.value = '';
    }

    // Validate password
    if (!isEditing.value && passwordController.text.isEmpty) {
      passwordError.value = 'Le mot de passe est requis';
    } else if (passwordController.text.isNotEmpty && passwordController.text.length < 6) {
      passwordError.value = 'Le mot de passe doit contenir au moins 6 caractères';
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
      SnackbarUtils.showError(
        'Erreur de validation',
        'Veuillez remplir tous les champs requis correctement',
      );
      return;
    }

    isLoading.value = true;

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

      SnackbarUtils.showSuccess(
        'Succès',
        'Utilisateur ajouté avec succès!',
      );

      // Navigate back to user management
      Get.back();
    } catch (e) {
      SnackbarUtils.showError(
        'Erreur',
        'Échec de l\'ajout de l\'utilisateur: $e',
      );
    } finally {
      isLoading.value = false;
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
      SnackbarUtils.showError(
        'Erreur de validation',
        'Veuillez remplir tous les champs requis correctement',
      );
      return;
    }

    isLoading.value = true;

    try {
      if (isEditing.value) {
        // Update user data
        await _userService.updateUser(
          userToEdit['id'],
          {
            'nom': fullNameController.text.trim(),
            'Department': departmentController.text.trim(),
            'region': regionController.text.trim(),
            'ville': villeController.text.trim(),
          },
        );

        // If password was entered, update it too (admin password reset feature)
        if (passwordController.text.isNotEmpty) {
          await _userService.changeUserPassword(
            userToEdit['id'],
            passwordController.text,
          );
        }

        SnackbarUtils.showSuccess(
          'Succès',
          'Utilisateur mis à jour avec succès!',
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

        SnackbarUtils.showSuccess(
          'Succès',
          'Utilisateur ajouté avec succès!',
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
      SnackbarUtils.showError(
        'Erreur',
        'Échec de ${isEditing.value ? 'la mise à jour' : 'l\'ajout'} de l\'utilisateur: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }


  void onCancel() {
    Get.back();
  }
}
