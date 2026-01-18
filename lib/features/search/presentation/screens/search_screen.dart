import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/widgets/search_bar.dart';
import '../widgets/search_part_card.dart';
import '../../controllers/custom_search_controller.dart';


class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GetBuilder<CustomSearchController>(
      init: CustomSearchController(),
      builder: (controller) => Scaffold(
        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        body: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 8),
              decoration: BoxDecoration(
                color: isDark ? AppColors.backgroundDark.withOpacity(0.95) : AppColors.backgroundLight.withOpacity(0.95),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () => Get.back(),
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                  Expanded(
                    child: Text(
                      AppStrings.searchSpareParts,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.tune,
                      color: AppColors.primary,
                    ),
                    onPressed: () {
                      // TODO: Implement filter functionality
                    },
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: CustomSearchBar(
                controller: controller.searchController,
                hintText: AppStrings.searchByPartNameOrSku,
                onChanged: (value) => controller.filterParts(),
              ),
            ),

            // Filter Dropdowns
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // Status Filter
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Obx(() => DropdownButtonFormField<String>(
                        value: controller.selectedStatus.value,
                        onChanged: (String? newValue) {
                          controller.selectedStatus.value = newValue!;
                          controller.filterParts();
                        },
                        items: controller.statusOptions.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: 'Status',
                          border: OutlineInputBorder(),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      )),
                    ),
                  ),
                  // Company Filter
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Obx(() => DropdownButtonFormField<String>(
                        value: controller.selectedCompany.value,
                        onChanged: (String? newValue) {
                          controller.selectedCompany.value = newValue!;
                          controller.filterParts();
                        },
                        items: controller.companyOptions.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: 'Company',
                          border: OutlineInputBorder(),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      )),
                    ),
                  ),
                  // Location Filter
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Obx(() => DropdownButtonFormField<String>(
                        value: controller.selectedLocation.value,
                        onChanged: (String? newValue) {
                          controller.selectedLocation.value = newValue!;
                          controller.filterParts();
                        },
                        items: controller.locationOptions.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: 'Location',
                          border: OutlineInputBorder(),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      )),
                    ),
                  ),
                ],
              ),
            ),

            // Result Count Bar
            Obx(() => Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardBackgroundDark.withOpacity(0.5) : AppColors.cardBackgroundLight.withOpacity(0.5),
                border: Border.symmetric(
                  horizontal: BorderSide(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    width: 1,
                  ),
                ),
              ),
              child: Text(
                'Showing ${controller.filteredParts.length} Results',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  letterSpacing: 1.2,
                ).copyWith(
                  textBaseline: TextBaseline.alphabetic,
                ),
              ),
            )),

            // Parts List
            Expanded(
              child: Obx(() => ListView.builder(
                itemCount: controller.filteredParts.length,
                itemBuilder: (context, index) {
                  final part = controller.filteredParts[index];
                  return SearchPartCard(
                    part: part,
                    onTap: () => controller.navigateToPartDetails(part),
                  );
                },
              )),
            ),
          ],
        ),
      ),
    );
  }
}
