import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/models/part_model.dart';
import '../services/parts_service.dart';
import '../../../core/controllers/user_controller.dart';

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
    'Sac_A',
    'Sac_1',
    'Sac_2',
    'Sac_3',
    'Sac_4',
    'Sac_5',
    'Sac_6',
    'Sac_7',
    'Sac_8',
    'Sac_9',
  ];

  final PartsService _partsService = PartsService();

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
      // Create new part via API
      final userController = Get.find<UserController>();
      final result = await _partsService.createPart(
        userController.accessToken.value,
        name: partNameController.text.trim(),
        reference: designationController.text.trim(),
        manufacturer: manufacturerController.text.trim(),
        description: descriptionController.text.trim().isNotEmpty
            ? descriptionController.text.trim()
            : null,
        initialQuantity: int.parse(quantityController.text),
        location: selectedLocation.value,
      );

      // Navigate back to parts management
      Get.back(result: result);

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
