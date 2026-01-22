import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/models/location_model.dart';
import '../../../routes/app_routes.dart';
import '../services/location_service.dart';

class LocationManagementController extends GetxController {
  var locations = <LocationModel>[].obs;
  var filteredLocations = <LocationModel>[].obs;
  var searchQuery = ''.obs;
  var isLoading = false.obs;
  final TextEditingController searchController = TextEditingController();

  final LocationService _locationService = LocationService();

  @override
  void onInit() {
    super.onInit();
    loadLocations();
    _setupSearch();
  }

  Future<void> loadLocations() async {
    try {
      isLoading.value = true;
      final locationsData = await _locationService.getAllLocations();
      final locationsList = locationsData.map((location) => LocationModel.fromMap(location)).toList();
      locations.assignAll(locationsList);
      filteredLocations.assignAll(locations);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load locations: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _setupSearch() {
    ever(searchQuery, (_) => _filterLocations());
  }

  void _filterLocations() {
    if (searchQuery.isEmpty) {
      filteredLocations.assignAll(locations);
    } else {
      filteredLocations.assignAll(
        locations.where((location) =>
          location.name.toLowerCase().contains(searchQuery.toLowerCase())
        ).toList()
      );
    }
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
  }

  void onEditPressed(LocationModel location) {
    // Navigate to add location screen with edit mode
    Get.toNamed(AppRoutes.addLocation, arguments: location);
  }

  void onDeletePressed(LocationModel location) {
    Get.defaultDialog(
      title: 'Delete Location',
      middleText: 'Are you sure you want to delete ${location.name}?',
      textConfirm: 'Delete',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      onConfirm: () {
        locations.remove(location);
        Get.back();
        Get.snackbar('Success', 'Location deleted successfully');
      },
    );
  }

  void onAddPressed() {
    Get.toNamed(AppRoutes.addLocation)?.then((result) {
      if (result != null && result is LocationModel) {
        locations.add(result);
      }
    });
  }

  void updateLocation(LocationModel oldLocation, LocationModel newLocation) {
    int index = locations.indexOf(oldLocation);
    if (index != -1) {
      locations[index] = newLocation;
    }
  }
}
