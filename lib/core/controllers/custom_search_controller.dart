import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lf_project/core/models/part_model.dart';
import 'package:lf_project/core/constants/strings.dart';

class CustomSearchController extends GetxController {
  // ==============================
  // SEARCH INPUT
  // ==============================
  final TextEditingController searchController = TextEditingController();

  // ==============================
  // FILTER STATE
  // ==============================
  final RxString selectedStatus = 'All'.obs;
  final RxString selectedCompany = 'All'.obs;
  final RxString selectedLocation = 'All'.obs;

  // ==============================
  // DATA
  // ==============================
  final RxList<PartModel> filteredParts = <PartModel>[].obs;
  late final List<PartModel> _allParts;

  // ==============================
  // FILTER OPTIONS
  // ==============================
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

  // ==============================
  // LIFECYCLE
  // ==============================
  @override
  void onInit() {
    super.onInit();

    _allParts = _buildMockParts();

    // Initial state
    filteredParts.assignAll(_allParts);

    // Search listener
    searchController.addListener(_filterParts);

    // React to filter changes
    everAll(
      [selectedStatus, selectedCompany, selectedLocation],
          (_) => _filterParts(),
    );
  }

  // ==============================
  // PUBLIC API (UI CALLS THIS)
  // ==============================
  void filterParts() {
    _filterParts();
  }

  // ==============================
  // PRIVATE FILTER LOGIC
  // ==============================
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

  // ==============================
  // NAVIGATION
  // ==============================
  void navigateToPartDetails(PartModel part) {
    Get.toNamed('/part-details', arguments: part);
  }

  // ==============================
  // CLEANUP
  // ==============================
  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // ==============================
  // MOCK DATA (MATCHES MODEL)
  // ==============================
  List<PartModel> _buildMockParts() {
    return [
      PartModel(
        name: AppStrings.overspeedGovernor,
        brand: AppStrings.otis,
        quantity: 'Qty: 03',
        location: 'Sac 3, Sac 6',
        imageUrl: 'https://via.placeholder.com/150',
        referenceNumber: 'REF-001-OG',
        isLowStock: false,
      ),
      PartModel(
        name: AppStrings.doorRollerAssembly,
        brand: AppStrings.schindler,
        quantity: 'Qty: 00',
        location: 'Sac 1, Bin 12A',
        imageUrl: 'https://via.placeholder.com/150',
        referenceNumber: 'REF-002-DRA',
        isLowStock: true,
      ),
      PartModel(
        name: AppStrings.emergencyLightBattery,
        brand: AppStrings.kone,
        quantity: 'Qty: 01',
        location: 'Service Truck A',
        imageUrl: 'https://via.placeholder.com/150',
        referenceNumber: 'REF-003-ELB',
        isLowStock: false,
      ),
    ];
  }
}
