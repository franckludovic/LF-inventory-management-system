import 'package:get/get.dart';
import '../../../core/models/part_model.dart';
import '../../../routes/app_routes.dart';
import 'package:flutter/material.dart';
import '../../../core/controllers/custom_search_controller.dart';

class PartsManagementController extends GetxController {
  final CustomSearchController searchController = Get.find<CustomSearchController>();

  @override
  void onInit() {
    super.onInit();
    // CustomSearchController handles loading parts
  }

  void onEditPressed(PartModel part) {
    // Handle edit action
    Get.snackbar('Edit', 'Editing ${part.designation}');
  }

  void onDeletePressed(PartModel part) {
    // Handle delete action
    Get.snackbar('Delete', 'Deleting ${part.designation}');
  }

  void onAddPressed() {
    // Handle add new part action
    Get.toNamed(AppRoutes.addPart)?.then((result) {
      if (result != null && result is PartModel) {
        // Reload parts after adding
        searchController.loadParts();
      }
    });
  }
}
