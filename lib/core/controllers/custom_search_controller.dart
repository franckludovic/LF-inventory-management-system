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
    'Out of Stock',
  ];

  final List<String> companyOptions = const [
    'All',
    'Otis',
    'Schindler',
    'Kone',
    'Generic / OEM',
    'ThyssenKrupp',
  ];

  final List<String> locationOptions = const [
    'All',
    'Sac 3',
    'Sac 6',
    'Sac 1',
    'Bin 12A',
    'Service Truck A',
    'Sac 9',
    'HQ Depot',
    'External Warehouse',
  ];

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
    } catch (e) {
      Get.snackbar('Error', 'Failed to load parts: $e');
    } finally {
      isLoading.value = false;
    }
  }


  void filterParts() {
    _filterParts();
  }


  void _filterParts() {
    final query = searchController.text.trim().toLowerCase();

    final results = _allParts.where((part) {
      final matchesSearch =
          query.isEmpty ||
              part.name.toLowerCase().contains(query) ||
              (part.referenceNumber?.toLowerCase().contains(query) ?? false);

      final matchesStatus =
          selectedStatus.value == 'All' ||
              (selectedStatus.value == 'In Stock' && !part.isLowStock) ||
              (selectedStatus.value == 'Out of Stock' && part.isLowStock);

      final matchesCompany =
          selectedCompany.value == 'All' ||
              part.brand.toLowerCase() ==
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
