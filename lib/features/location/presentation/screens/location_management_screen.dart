import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/widgets/search_bar.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/location_card_widget.dart';
import '../../controllers/location_management_controller.dart';

class LocationManagementScreen extends GetView<LocationManagementController> {
  const LocationManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: CustomAppBar(
        title: AppStrings.locationManagement,
        showBackButton: false,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: CustomSearchBar(
              controller: controller.searchController,
              hintText: AppStrings.searchLocations,
              onChanged: (value) => controller.onSearchChanged(value),
            ),
          ),

          // Locations List
          Expanded(
            child: Obx(() {
              if (controller.filteredLocations.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_off_outlined,
                        size: 64,
                        color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppStrings.noLocationsFound,
                        style: TextStyle(
                          fontSize: 18,
                          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.filteredLocations.length,
                itemBuilder: (context, index) {
                  final location = controller.filteredLocations[index];
                  return LocationCardWidget(
                    location: location,
                    onEditPressed: () => controller.onEditPressed(location),
                    onDeletePressed: () => controller.onDeletePressed(location),
                  );
                },
              );
            }),
          ),
        ],
      ),

      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: controller.onAddPressed,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 6,
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}
