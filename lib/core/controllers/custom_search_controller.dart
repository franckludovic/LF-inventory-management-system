import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lf_project/core/models/part_model.dart';
import 'package:lf_project/core/constants/strings.dart';
import 'package:lf_project/features/Parts/services/parts_service.dart';
import 'package:lf_project/core/controllers/user_controller.dart';

class CustomSearchController extends GetxController {

  final TextEditingController searchController = TextEditingController();


  final RxString selectedStatus = 'All'.obs;
  final RxString selectedCompany = 'All'.obs;
  final RxString selectedLocation = 'All'.obs;


  final RxList<PartModel> filteredParts = <PartModel>[].obs;
  final RxList<PartModel> _allParts = <PartModel>[].obs;
  final RxBool isLoading = false.obs;


  final List<String> statusOptions = const [
    'All',
    'In Stock',
    'Low Stock',
    'Critical Stock',
    'Out of Stock',
  ];

  final RxList<String> companyOptions = <String>['All'].obs;

  final RxList<String> locationOptions = <String>['All'].obs;

  final PartsService _partsService = PartsService();


  @override
  void onInit() {
    super.onInit();
    loadParts();

    // Search listener
    searchController.addListener(_filterParts);

    // React to filter changes
    everAll(
      [selectedStatus, selectedCompany, selectedLocation],
          (_) => _filterParts(),
    );
  }

  Future<void> loadParts() async {
    try {
      isLoading.value = true;
      final userController = Get.find<UserController>();
      final partsData = await _partsService.getAllParts(userController.accessToken.value);
      final partsList = partsData.map((part) => PartModel.fromMap(part)).toList();
      _allParts.assignAll(partsList);
      filteredParts.assignAll(_allParts);

      // Populate dynamic filter options from data
      _populateFilterOptions();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load parts: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _populateFilterOptions() {
    // Get unique companies
    final companies = _allParts.map((part) => part.fabriquant).toSet().toList();
    companyOptions.assignAll(['All', ...companies]);

    // Get unique locations from sacComposants
    final locations = <String>{};
    for (final part in _allParts) {
      if (part.locations != null) {
        for (final location in part.locations!) {
          locations.add(location.keys.first);
        }
      }
    }
    locationOptions.assignAll(['All', ...locations.toList()]);
  }


  void filterParts() {
    _filterParts();
  }


  void _filterParts() {
    final query = searchController.text.trim().toLowerCase();

    final results = _allParts.where((part) {
      final matchesSearch =
          query.isEmpty ||
              part.designation.toLowerCase().contains(query) ||
              (part.reference?.toLowerCase().contains(query) ?? false);

      final quantity = int.parse(part.quantity);
      final matchesStatus =
          selectedStatus.value == 'All' ||
              (selectedStatus.value == 'In Stock' && quantity > 2) ||
              (selectedStatus.value == 'Low Stock' && quantity > 2 && quantity < 5) ||
              (selectedStatus.value == 'Critical Stock' && quantity <= 2 && quantity > 0) ||
              (selectedStatus.value == 'Out of Stock' && quantity == 0);

      final matchesCompany =
          selectedCompany.value == 'All' ||
              part.fabriquant.toLowerCase() ==
                  selectedCompany.value.toLowerCase();

      final matchesLocation =
          selectedLocation.value == 'All' ||
              part.location.contains(selectedLocation.value);

      return matchesSearch &&
          matchesStatus &&
          matchesCompany &&
          matchesLocation;
    }).toList();

    filteredParts.assignAll(results);
  }

  void navigateToPartDetails(PartModel part) {
    Get.toNamed('/part-details', arguments: part);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

}
