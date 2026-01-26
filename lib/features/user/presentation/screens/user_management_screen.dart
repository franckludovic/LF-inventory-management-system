import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/search_bar.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/strings.dart';
import '../../controllers/user_management_controller.dart';
import '../widgets/technician_list_item.dart';

class UserManagementScreen extends GetView<UserManagementController> {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.userManagement,
        onProfileTap: () {}, //i have to implement the profile here
        showBackButton: false,
      ),
      body: RefreshIndicator(
        onRefresh: controller.loadTechnicians,
        child: Column(
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.all(16),
              child: CustomSearchBar(
                hintText: AppStrings.searchTechnicians,
                onChanged: controller.onSearchChanged,
              ),
            ),
            // Content
            Expanded(
              child: Obx(() {
                final activeTechs = controller.filteredTechnicians
                    .where((tech) => tech['status'] == 'active')
                    .toList();
                final blockedTechs = controller.filteredTechnicians
                    .where((tech) => tech['status'] == 'blocked')
                    .toList();

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Active Technicians Section
                      if (activeTechs.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text(
                            '${AppStrings.activeTechnicians} (${activeTechs.length})',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              letterSpacing: 1,
                            ).copyWith(fontSize: 12),
                          ),
                        ),
                        ...activeTechs.map((tech) => TechnicianListItem(technician: tech)),
                      ],
                      // Blocked Technicians Section
                      if (blockedTechs.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          child: Text(
                            '${AppStrings.blockedTechnicians} (${blockedTechs.length})',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              letterSpacing: 1,
                            ).copyWith(fontSize: 12),
                          ),
                        ),
                        ...blockedTechs.map((tech) => TechnicianListItem(technician: tech)),
                      ],
                      const SizedBox(height: 100), // Space for bottom button
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      // Fixed Bottom Button
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackgroundLight,
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
              width: 1,
            ),
          ),
        ),
        child: ElevatedButton.icon(
          onPressed: controller.onAddNewTechnician,
          icon: const Icon(Icons.person_add, size: 20),
          label: Text(AppStrings.addNewTechnician),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            shadowColor: AppColors.shadowPrimary,
          ),
        ),
      ),
    );
  }
}
