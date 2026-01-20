import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../routes/app_routes.dart';

class UserManagementController extends GetxController {
  // Observable list of technicians
  var technicians = <Map<String, dynamic>>[].obs;

  // Search query
  var searchQuery = ''.obs;

  // Filtered technicians based on search
  var filteredTechnicians = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with sample data
    loadTechnicians();
    // Listen to search query changes
    ever(searchQuery, (_) => filterTechnicians());
  }

  void loadTechnicians() {
    technicians.assignAll([
      {
        'id': 1,
        'name': 'John Doe',
        'role': 'Senior Technician',
        'status': 'active',
        'avatar': 'https://lh3.googleusercontent.com/aida-public/AB6AXuDZrZ3jhuXPH1_m2DVKFCF2lO3a4oUA-B7VQfp_psxcLyFYJsP6nLy7EigzNvLjAQeVUOAjoD-OSKH6V-2p18oBanYqxpqY7pL5JKZjsYfFkUJAvPPwOEfOzE5CsukgGOSnr4UCVMWLtvn-X1fcL2p9IwhfYMYPaTsK_F-82YBUVXXy5LHc4jKbHO5SeeiZA5xJ7VbahOHSVIl-ztLgPfPuYVlGb2igrO_7IQyTqgR95_JId4ycVivGBrOy6Q2iBNSNu8KEq0KtlYb5',
      },
      {
        'id': 2,
        'name': 'Sarah Smith',
        'role': 'Technician',
        'status': 'active',
        'avatar': 'https://lh3.googleusercontent.com/aida-public/AB6AXuCF-3zZZq14AgCEVYA9viKDo0gr_sxQd4ImBSFfyPVrbZ8cAkUt6MvhGdSdfeK_Xy23v_8m-HVMu1dl_IaM0mNN6vxtU45aX92uP9eTiGYJiVis-w4MfdACxbCSE0FqW7GrHwpVeBxYrYnOndUlsBAxJG-I7KLE3rWJ2QuY8HOvR-zgzy_4luxUCH9ckWVmTLOhYuCU-s2B9nbBPnZnaTSgEl0BH1l-73II820si-n5H6AJdnf5uO1oHcoi_VtwH8Ng-pOtEIbd8UZJ',
      },
      {
        'id': 3,
        'name': 'Michael Chen',
        'role': 'Maintenance Specialist',
        'status': 'active',
        'avatar': 'https://lh3.googleusercontent.com/aida-public/AB6AXuAbeBeU65KcY6MxPUZHQCKygtPAuO5H68igOb2cTGS3C4oAKE2yY4CCGo7e9I7QH-a10GtuPVtcKxjWgYV6MyOeDFfQseBHSrQxF9WUG9fY_LpeTstpKhoYJtf2sjJek9ebNhgItFs6znPJvYAIeWwXV2Pko3p9x3qQ5im-zd4pLJWrAool2K9cU59VjYexh2ekouH_v-bLB_yvuMMdkjRNXrF11aXjSpP2mLbkbm2oCWNlPRsJ3cUoP4ZVUJqIS77bOCPPACAehfSV',
      },
      {
        'id': 4,
        'name': 'Robert Wilson',
        'role': 'Technician',
        'status': 'blocked',
        'avatar': 'https://lh3.googleusercontent.com/aida-public/AB6AXuCCoqM4VS32XdtBBpuo7UxjJ03_gSwi4PNANn1AdgK3iew826WvbwBczNgCfD9uxBWdXbYIgnL1cciuB5YF_4nQLKX4tv-boilJIAUg5YsHBgAKGCSBvZMixVk79BqLzSPdjFfeV4QlrKSI5DrCpCjtiCuDWTn59JBHw8z6IbTpGxJ_7pNW5IB-XBbovVvZEZkceZ305LPlGeu54amU9pPyGpg0PK2d1GZUP9hiMS86f2-9m-ZJOY2-u_lvPbSGKk95xy4lnLN7UGeS',
      },
    ]);
    filterTechnicians();
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
