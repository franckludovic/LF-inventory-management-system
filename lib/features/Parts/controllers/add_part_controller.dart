import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/models/part_model.dart';

class AddPartController extends GetxController {
  // Form controllers
  final partNameController = TextEditingController();
  final designationController = TextEditingController();
  final manufacturerController = TextEditingController();
  final descriptionController = TextEditingController();
  final quantityController = TextEditingController(text: '0');

  // Reactive variables
  var selectedLocation = ''.obs;
  var selectedImagePath = ''.obs;
  var isLoading = false.obs;

  final locations = [
    'Main Warehouse - A1',
    'Service Van - V04',
    'Regional Hub - West',
  ];

  @override
  void onClose() {
    partNameController.dispose();
    designationController.dispose();
    manufacturerController.dispose();
    descriptionController.dispose();
    quantityController.dispose();
    super.onClose();
  }

  void onLocationSelected(String location) {
    selectedLocation.value = location;
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        selectedImagePath.value = pickedFile.path;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e');
    }
  }

  void onUploadPressed() {
    pickImage(ImageSource.gallery);
  }

  void onCameraPressed() {
    pickImage(ImageSource.camera);
  }

  bool validateForm() {
    if (partNameController.text.trim().isEmpty) {
      Get.snackbar('Validation Error', 'Part name is required');
      return false;
    }

    if (designationController.text.trim().isEmpty) {
      Get.snackbar('Validation Error', 'Designation/Reference is required');
      return false;
    }

    if (manufacturerController.text.trim().isEmpty) {
      Get.snackbar('Validation Error', 'Manufacturer is required');
      return false;
    }

    if (selectedLocation.value.isEmpty) {
      Get.snackbar('Validation Error', 'Please select a location');
      return false;
    }

    return true;
  }

  Future<void> onSavePressed() async {
    if (!validateForm()) return;

    isLoading.value = true;

    try {
      // Create new part
      final newPart = PartModel(
        name: partNameController.text.trim(),
        brand: manufacturerController.text.trim(),
        quantity: quantityController.text,
        location: selectedLocation.value,
        imageUrl: selectedImagePath.value.isNotEmpty
            ? selectedImagePath.value
            : 'https://via.placeholder.com/400x300?text=No+Image',
        referenceNumber: designationController.text.trim(),
        description: descriptionController.text.trim().isNotEmpty
            ? descriptionController.text.trim()
            : null,
      );

      // Here you would typically save to your backend/database
      // For now, we'll just simulate saving
      await Future.delayed(const Duration(seconds: 1));

      // Navigate back to parts management
      Get.back(result: newPart);

      Get.snackbar('Success', 'Part added successfully');

    } catch (e) {
      Get.snackbar('Error', 'Failed to save part: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void onCancelPressed() {
    Get.back();
  }
}
