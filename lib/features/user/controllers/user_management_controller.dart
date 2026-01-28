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
      final techniciansList = usersData.map((user) {
        final userMap = user as Map<String, dynamic>;
        return {
          ...userMap, // Keep all original user data
          'name': userMap['nom'] ?? '',
          'roleDisplay': _getRoleDisplayName(userMap['role']),
          'status': 'active', // Default to active, could be derived from other fields
          'avatar': 'https://via.placeholder.com/150?text=${userMap['nom']?.substring(0, 1) ?? 'U'}',
        };
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
            tech['roleDisplay'].toLowerCase().contains(searchQuery.value.toLowerCase())),
      );
    }
  }

  void toggleUserStatus(String id) {
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

  void updateUser(Map<String, dynamic> updatedUser) {
    var index = technicians.indexWhere((t) => t['id'] == updatedUser['id']);
    if (index != -1) {
      technicians[index] = updatedUser;
      filterTechnicians();
    }
  }

  void onUserTap(Map<String, dynamic> user) {
    Get.toNamed(AppRoutes.addUser, arguments: user)?.then((result) {
      if (result != null && result is Map<String, dynamic>) {
        updateUser(result);
      } else {
        loadTechnicians();
      }
    });
  }

  void onAddNewTechnician() {
    Get.toNamed(AppRoutes.addUser)?.then((result) {
      if (result != null && result is Map<String, dynamic>) {
        updateUser(result);
      } else {
        loadTechnicians();
      }
    });
  }

  void onBackPressed() {
    Get.back();
  }
}
