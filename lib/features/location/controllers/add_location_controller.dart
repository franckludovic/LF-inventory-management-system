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
      nameError.value = 'Location name is required';
    } else if (nameController.text.trim().length < 2) {
      nameError.value = 'Location name must be at least 2 characters';
    } else {
      nameError.value = '';
    }

    // Validate max quantity (optional, but if provided, must be positive integer)
    if (maxQuantityController.text.isNotEmpty) {
      final qty = int.tryParse(maxQuantityController.text);
      if (qty == null || qty <= 0) {
        maxQuantityError.value = 'Max quantity must be a positive number';
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
        'Validation Error',
        'Please fill in all required fields correctly',
      );
      return;
    }

    isLoading.value = true;

    try {
      final maxQty = maxQuantityController.text.isNotEmpty ? int.parse(maxQuantityController.text) : null;

      Map<String, dynamic> result;
      if (editingLocation != null) {
        // Update existing location
        result = await _locationService.updateLocation(
          locationId: editingLocation!.id ?? '', // Assuming LocationModel has id field
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
        'Success',
        editingLocation != null ? 'Location updated successfully!' : 'Location added successfully!',
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
