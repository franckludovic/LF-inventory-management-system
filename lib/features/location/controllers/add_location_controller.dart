import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/strings.dart';
import '../../../core/models/location_model.dart';

class AddLocationController extends GetxController {
  // Form controllers
  final nameController = TextEditingController();
  final maxQuantityController = TextEditingController();

  // Observable variables for form validation
  var isFormValid = false.obs;

  // Form validation
  var nameError = ''.obs;
  var maxQuantityError = ''.obs;

  LocationModel? editingLocation;

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

  void onSaveLocation() {
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

    final maxQty = maxQuantityController.text.isNotEmpty ? int.parse(maxQuantityController.text) : null;

    final location = LocationModel(
      name: nameController.text.trim(),
      maxQuantity: maxQty,
      totalQuantity: editingLocation?.totalQuantity ?? 0,
    );

    // TODO: Call API to save location
    // For now, just show success message and navigate back
    Get.snackbar(
      'Success',
      editingLocation != null ? 'Location updated successfully!' : 'Location added successfully!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    // Navigate back with result
    Get.back(result: location);
  }

  void onCancel() {
    Get.back();
  }
}
