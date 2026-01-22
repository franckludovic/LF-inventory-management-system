import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../routes/app_routes.dart';
import '../services/user_service.dart';

class UserManagementController extends GetxController {
  // Observable list of technicians
  var technicians = <Map<String, dynamic>>[].obs;

  // Search query
  var searchQuery = ''.obs;

  // Filtered technicians based on search
  var filteredTechnicians = <Map<String, dynamic>>[].obs;

  // Loading state
  var isLoading = false.obs;

  final UserService _userService = UserService();

  @override
  void onInit() {
    super.onInit();
    // Load users from backend
    loadTechnicians();
    // Listen to search query changes
    ever(searchQuery, (_) => filterTechnicians());
  }

  Future<void> loadTechnicians() async {
    try {
      isLoading.value = true;
      final usersData = await _userService.getAllUsers();
      final techniciansList = usersData.map((user) => {
        'id': user['id'],
        'name': user['nom'] ?? '',
        'role': _getRoleDisplayName(user['role']),
        'status': 'active', // Default to active, could be derived from other fields
        'avatar': 'https://via.placeholder.com/150?text=${user['nom']?.substring(0, 1) ?? 'U'}',
      }).toList();
      technicians.assignAll(techniciansList);
      filterTechnicians();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load users: $e');
    } finally {
      isLoading.value = false;
    }
  }

  String _getRoleDisplayName(dynamic role) {
    if (role is List && role.isNotEmpty) {
      String roleStr = role[0].toString();
      if (roleStr.contains('ADMIN')) return 'Administrator';
      if (roleStr.contains('TECHNICIAN')) return 'Technician';
    }
    return 'User';
  }

  void filterTechnicians() {
    if (searchQuery.isEmpty) {
      filteredTechnicians.assignAll(technicians);
    } else {
      filteredTechnicians.assignAll(
        technicians.where((tech) =>
            tech['name'].toLowerCase().contains(searchQuery.value.toLowerCase()) ||
            tech['role'].toLowerCase().contains(searchQuery.value.toLowerCase())),
      );
    }
  }

  void toggleUserStatus(int id) {
    var index = technicians.indexWhere((tech) => tech['id'] == id);
    if (index != -1) {
      var tech = technicians[index];
      tech['status'] = tech['status'] == 'active' ? 'blocked' : 'active';
      technicians[index] = tech;
      filterTechnicians();
    }
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
  }

  void onAddNewTechnician() {
    Get.toNamed(AppRoutes.addUser)?.then((result) {
      if (result != null && result is Map<String, dynamic>) {
        // Add the new technician to the list
        technicians.add(result);
        filterTechnicians();
        Get.snackbar('Success', 'Technician added successfully!');
      }
    });
  }

  void onBackPressed() {
    Get.back();
  }
}
