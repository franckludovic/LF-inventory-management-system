import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/models/part_model.dart';
import '../services/parts_service.dart';
import '../../../core/controllers/user_controller.dart';
import '../../../features/location/services/location_service.dart';

class AddPartController extends GetxController {
  // Form controllers
  final partNameController = TextEditingController();
  final designationController = TextEditingController();
  final manufacturerController = TextEditingController();
  final descriptionController = TextEditingController();
  final quantityController = TextEditingController(text: '0');

  // Reactive variables
  var selectedLocation = ''.obs;
  var selectedSacName = ''.obs;
  var selectedImagePath = ''.obs;
  var isLoading = false.obs;
  var isLoadingLocations = false.obs;
  var availableLocations = <String>['Loading...'].obs;

  final LocationService _locationService = LocationService();
  final PartsService _partsService = PartsService();

  @override
  void onInit() {
    super.onInit();
    loadAvailableLocations();
  }

  @override
  void onClose() {
    partNameController.dispose();
    designationController.dispose();
    manufacturerController.dispose();
    descriptionController.dispose();
    quantityController.dispose();
    super.onClose();
  }

  void onLocationSelected(String? location) {
    if (location != null) {
      selectedLocation.value = location;
      // Extract sac name from display string (e.g., "sac 1 12/50" -> "Sac_1")
      final parts = location.split(' ');
      if (parts.length >= 2) {
        final firstPart = parts[0];
        
        // If already in correct format with underscore (e.g., "Sac_1"), use it directly
        if (firstPart.contains('_')) {
          selectedSacName.value = firstPart;
        } else {
          // Convert "sac 1" format to "Sac_1" format expected by backend
          final prefix = parts[0];
          final suffix = parts[1];
          // Capitalize first letter of prefix, uppercase the suffix (for letter cases like "a" -> "A")
          selectedSacName.value = '${prefix[0].toUpperCase()}${prefix.substring(1)}_${suffix.toUpperCase()}';
        }
      } else {
        selectedSacName.value = location;
      }
    }
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
        location: selectedSacName.value,
        imagePath: selectedImagePath.value.isNotEmpty ? selectedImagePath.value : null,
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

  Future<void> loadAvailableLocations() async {
    isLoadingLocations.value = true;
    try {
      final userController = Get.find<UserController>();

      // Check if user is logged in
      if (!userController.isLoggedIn) {
        Get.snackbar('Error', 'Please login first');
        return;
      }

      // Check if user has required role
      if (!userController.userRole.contains('ROLE_ADMIN') && !userController.userRole.contains('ROLE_TECHNICIAN')) {
        Get.snackbar('Error', 'You need to be logged in as Admin or Technician to access locations');
        return;
      }

      // Load all SACs
      final sacs = await _locationService.getAllLocations();

      // Load all parts to calculate usage
      final parts = await _partsService.getAllParts(userController.accessToken.value);

      // Calculate usage per SAC
      final usageMap = <String, int>{};
      for (var part in parts) {
        final sacId = part['sacId']?.toString();
        final quantity = (part['quantite'] ?? 0) as int;
        if (sacId != null) {
          usageMap[sacId] = (usageMap[sacId] ?? 0) + quantity;
        }
      }

      // Filter SACs that are not full and format display
      final available = <String>[];
      for (var sac in sacs) {
        final sacId = sac['id']?.toString();
        final name = sac['nom'] ?? 'Unknown';
        final maxCapacity = sac['capaciteMax'] ?? 0;
        final currentUsage = usageMap[sacId] ?? 0;
        final remaining = maxCapacity - currentUsage;

        if (remaining > 0) {
          available.add('$name $currentUsage/$maxCapacity');
        }
      }

      availableLocations.assignAll(available);
    } catch (e) {
      print('Error loading locations: $e');
      Get.snackbar('Error', 'Failed to load locations from database. Please check your connection and try again.');
      // Don't show dummy data, let it show "No locations available"
    } finally {
      isLoadingLocations.value = false;
    }
  }

  void onCancelPressed() {
    Get.back();
  }
}
