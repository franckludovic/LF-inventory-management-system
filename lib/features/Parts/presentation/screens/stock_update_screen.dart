import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/stock_update_controller.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/widgets/custom_search_field.dart';
import '../../../../core/widgets/custom_dropdown.dart';
import '../../../../core/widgets/quantity_selector.dart';
import '../../../../core/widgets/action_toggle.dart';
import '../../../../core/widgets/custom_text_area.dart';

class StockUpdateScreen extends GetView<StockUpdateController> {
  const StockUpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.cardBackgroundDark.withOpacity(0.95) : AppColors.cardBackgroundLight.withOpacity(0.95),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        ),
        title: Text(
          'Update Stock',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Main Form Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Select Part TextField
                  CustomSearchField(
                    label: 'SELECT PART',
                    hint: 'Search elevator part...',
                    currentStock: 'Current Stock: 14 units',
                    controller: controller.searchController,
                  ),
                  const SizedBox(height: 24),

                  // Select Bag Dropdown
                  Obx(() => CustomDropdown(
                    label: 'STORAGE BAG',
                    value: controller.selectedBag.value.isEmpty ? null : controller.selectedBag.value,
                    items: controller.bagOptions,
                    onChanged: controller.selectBag,
                  )),
                  const SizedBox(height: 16),

                  // Add Location Button
                  Obx(() => SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: controller.toggleAddLocation,
                      icon: Icon(
                        controller.showAddLocation.value ? Icons.remove : Icons.add,
                        color: AppColors.primary,
                      ),
                      label: Text(
                        'Add Location',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.primary),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  )),

                  // Additional Location Dropdown (shown when Add Location is clicked)
                  Obx(() => controller.showAddLocation.value ? Column(
                    children: [
                      const SizedBox(height: 16),
                      CustomDropdown(
                        label: 'ADDITIONAL LOCATION',
                        value: controller.selectedAdditionalLocation.value.isEmpty ? null : controller.selectedAdditionalLocation.value,
                        items: controller.availableLocations,
                        onChanged: controller.selectAdditionalLocation,
                      ),
                    ],
                  ) : const SizedBox()),
                  const SizedBox(height: 24),

                  // Quantity Field
                  Obx(() => QuantitySelector(
                    label: 'QUANTITY',
                    quantity: controller.quantity.value,
                    onIncrement: controller.incrementQuantity,
                    onDecrement: controller.decrementQuantity,
                  )),
                  const SizedBox(height: 32),

                  // Action Toggle (Add / Remove)
                  Obx(() => ActionToggle(
                    isAddStock: controller.isAddStock.value,
                    onToggle: controller.toggleAction,
                  )),
                  const SizedBox(height: 24),

                  // Optional Note
                  CustomTextArea(
                    label: 'OPTIONAL NOTE',
                    hint: 'E.g. Damaged unit return, site transfer...',
                    controller: controller.noteController,
                  ),
                  const SizedBox(height: 80), // Space for bottom button
                ],
              ),
            ),
          ),

          // Footer Button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.backgroundDark.withOpacity(0.8) : AppColors.backgroundLight.withOpacity(0.8),
              border: Border(
                top: BorderSide(
                  color: isDark ? AppColors.borderDark.withOpacity(0.3) : AppColors.borderLight.withOpacity(0.3),
                ),
              ),
            ),
            child: ElevatedButton(
              onPressed: controller.confirmChange,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    'Confirm Change',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
