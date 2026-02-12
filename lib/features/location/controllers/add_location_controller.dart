import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/strings.dart';
import '../../../core/models/location_model.dart';
import '../../../core/utils/error_handler.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../services/location_service.dart';

class AddLocationController extends GetxController {
  // Form controllers
  final nameController = TextEditingController();
  final maxQuantityController = TextEditingController();

  // Observable variables for form validation
  var isFormValid = false.obs;
  var isLoading = false.obs;

  // Form validation
  var nameError = ''.obs;
  var maxQuantityError = ''.obs;

  LocationModel? editingLocation;
  final LocationService _locationService = LocationService();

  @override
  void onInit() {
    super.onInit();
    // Check if editing
    final args = Get.arguments;
    if (args is LocationModel) {
      editingLocation = args;
      nameController.text = args.name;
      if (args.maxQuantity != null) {
        maxQuantityController.text = args.maxQuantity.toString();
      }
    }
    // Listen to form changes for validation
    nameController.addListener(_validateForm);
    maxQuantityController.addListener(_validateForm);
    _validateForm();
  }

  @override
  void onClose() {
    // Dispose controllers
    nameController.dispose();
    maxQuantityController.dispose();
    super.onClose();
  }

  void _validateForm() {
    // Validate name
    if (nameController.text.trim().isEmpty) {
      nameError.value = 'Non de la localisation est requis';
    } else if (nameController.text.trim().length < 2) {
      nameError.value = 'Le nom doit contenir au moins 2 caractères';
    } else {
      nameError.value = '';
    }

    // Validate max quantity (optional, but if provided, must be positive integer)
    if (maxQuantityController.text.isNotEmpty) {
      final qty = int.tryParse(maxQuantityController.text);
      if (qty == null || qty <= 0) {
        maxQuantityError.value = 'La quantité maximale doit être un entier positif';
      } else {
        maxQuantityError.value = '';
      }
    } else {
      maxQuantityError.value = '';
    }

    // Check if form is valid
    isFormValid.value = nameError.value.isEmpty && maxQuantityError.value.isEmpty && nameController.text.trim().isNotEmpty;
  }

  Future<void> onSaveLocation() async {
    if (!isFormValid.value) {
      SnackbarUtils.showError(
        'Erreur de validation',
        'Veuillez remplir tous les champs requis correctement',
      );
      return;
    }

    isLoading.value = true;

    try {
      final maxQty = maxQuantityController.text.isNotEmpty ? int.parse(maxQuantityController.text) : null;

      Map<String, dynamic> result;
      if (editingLocation != null) {
        // Validate that we have a location ID for update
        if (editingLocation!.id == null || editingLocation!.id!.isEmpty) {
          throw Exception('Location ID is missing. Cannot update location.');
        }
        // Update existing location
        result = await _locationService.updateLocation(
          locationId: editingLocation!.id!,
          name: nameController.text.trim(),
          maxQuantity: maxQty,
        );

      } else {
        // Create new location
        result = await _locationService.createLocation(
          name: nameController.text.trim(),
          maxQuantity: maxQty ?? 0,
        );
      }

      final location = LocationModel.fromMap(result);

      SnackbarUtils.showSuccess(
        'Succès',
        editingLocation != null ? 'Localisation mise à jour avec succès!' : 'Localisation ajoutée avec succès!',
      );

      // Navigate back with result after a short delay to allow snackbar to show
      Future.delayed(const Duration(milliseconds: 500), () {
        Get.back(result: location);
      });
    } catch (e) {
      SnackbarUtils.showError(
        'Error',
        ErrorHandler.getErrorMessage(e),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void onCancel() {
    Get.back();
  }
}
