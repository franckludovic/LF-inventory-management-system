import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lf_project/core/widgets/search_bar.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/part_card_widget.dart';
import '../../controllers/parts_management_controller.dart';
import '../../../../core/controllers/custom_search_controller.dart';

class PartsManagementScreen extends GetView<PartsManagementController> {
  const PartsManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final searchcontroller = Get.find<CustomSearchController>();

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: CustomAppBar(
        title: AppStrings.partsManagement,
        showBackButton: false,
      ),
      body: RefreshIndicator(
        onRefresh: controller.loadParts,
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: CustomSearchBar(
                controller: controller.searchController,
                hintText: AppStrings.searchByPartNameOrSku,
                onChanged: (value) => controller.onSearchChanged(value),
              ),
            ),

            // Filter Chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // Status Filter
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: SizedBox(
                        height: 48,
                        child: Obx(() => DropdownButtonFormField<String>(
                          value: searchcontroller.selectedStatus.value,
                          onChanged: (String? newValue) {
                            searchcontroller.selectedStatus.value = newValue!;
                            searchcontroller.filterParts();
                          },
                          items: searchcontroller.statusOptions.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, overflow: TextOverflow.ellipsis),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            labelText: 'Status',
                            border: OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            isDense: true,
                          ),
                          isExpanded: true,
                        )),
                      ),
                    ),
                  ),
                  // Company Filter
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: SizedBox(
                        height: 48,
                        child: Obx(() => DropdownButtonFormField<String>(
                          value: searchcontroller.selectedCompany.value,
                          onChanged: (String? newValue) {
                            searchcontroller.selectedCompany.value = newValue!;
                            searchcontroller.filterParts();
                          },
                          items: searchcontroller.companyOptions.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, overflow: TextOverflow.ellipsis),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            labelText: 'Company',
                            border: OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            isDense: true,
                          ),
                          isExpanded: true,
                        )),
                      ),
                    ),
                  ),
                  // Location Filter
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: SizedBox(
                        height: 48,
                        child: Obx(() => DropdownButtonFormField<String>(
                          value: searchcontroller.selectedLocation.value,
                          onChanged: (String? newValue) {
                            searchcontroller.selectedLocation.value = newValue!;
                            searchcontroller.filterParts();
                          },
                          items: searchcontroller.locationOptions.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, overflow: TextOverflow.ellipsis),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            labelText: 'Location',
                            border: OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            isDense: true,
                          ),
                          isExpanded: true,
                        )),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Parts List
            Expanded(
              child: Obx(() {
                if (controller.filteredParts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 64,
                          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No parts found',
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
                  itemCount: controller.filteredParts.length,
                  itemBuilder: (context, index) {
                    final part = controller.filteredParts[index];
                    return PartCardWidget(
                      part: part,
                      onEditPressed: () => controller.onEditPressed(part),
                      onDeletePressed: () => controller.onDeletePressed(part),
                    );
                  },
                );
              }),
            ),
          ],
        ),
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
