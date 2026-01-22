import 'package:get/get.dart';
import '../../../core/models/part_model.dart';
import '../../../routes/app_routes.dart';
import 'package:flutter/material.dart';
import '../services/parts_service.dart';
import '../../../core/controllers/user_controller.dart';

class PartsManagementController extends GetxController {
  var parts = <PartModel>[].obs;
  var filteredParts = <PartModel>[].obs;
  var searchQuery = ''.obs;
  var selectedFilter = 'All Parts'.obs;
  var isLoading = false.obs;
  final TextEditingController searchController = TextEditingController();

  final filters = ['All Parts', 'Sensors', 'Cables', 'Boards'];
  final PartsService _partsService = PartsService();

  @override
  void onInit() {
    super.onInit();
    loadParts();
    _setupSearchAndFilter();
  }

  Future<void> loadParts() async {
    try {
      isLoading.value = true;
      final userController = Get.find<UserController>();
      final partsData = await _partsService.getAllParts(userController.accessToken.value);
      final partsList = partsData.map((part) => PartModel.fromMap(part)).toList();
      parts.assignAll(partsList);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load parts: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _setupSearchAndFilter() {
    everAll([searchQuery, selectedFilter], (_) {
      _filterParts();
    });
  }

  void _filterParts() {
    var filtered = parts.where((part) {
      final matchesSearch = searchQuery.isEmpty ||
          part.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          part.brand.toLowerCase().contains(searchQuery.toLowerCase()) ||
          (part.referenceNumber?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false);

      final matchesFilter = selectedFilter.value == 'All Parts' ||
          part.name.toLowerCase().contains(selectedFilter.value.toLowerCase());

      return matchesSearch && matchesFilter;
    }).toList();

    filteredParts.assignAll(filtered);
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
  }

  void onFilterSelected(String filter) {
    selectedFilter.value = filter;
  }

  void onEditPressed(PartModel part) {
    // Handle edit action
    Get.snackbar('Edit', 'Editing ${part.name}');
  }

  void onDeletePressed(PartModel part) {
    // Handle delete action
    Get.snackbar('Delete', 'Deleting ${part.name}');
  }

  void onAddPressed() {
    // Handle add new part action
    Get.toNamed(AppRoutes.addPart)?.then((result) {
      if (result != null && result is PartModel) {
        // Add the new part to the list
        parts.add(result);
        // The filteredParts will automatically update due to the reactive nature
      }
    });
  }
}
