import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/stock_update_controller.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/strings.dart';
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
              child: Obx(() {
                if (controller.selectedPart.value == null) {
                  return const Center(
                    child: Text('Pas de pièce sélectionnée'),
                  );
                }

                final part = controller.selectedPart.value!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Part Information Grid
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackgroundLight,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isDark ? AppColors.borderDark : AppColors.borderLight,
                        ),
                      ),
                      child: Column(
                        children: [
                          // Part Image
                          Center(
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackgroundLight,
                              ),
                              child: part.imageUrl != null && part.imageUrl.isNotEmpty && Uri.tryParse(part.imageUrl)?.hasScheme == true
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        part.imageUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Icon(
                                            Icons.inventory,
                                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                            size: 32,
                                          );
                                        },
                                      ),
                                    )
                                  : Icon(
                                      Icons.inventory,
                                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                      size: 32,
                                    ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // 2x2 Grid for Part Info
                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                            childAspectRatio: 3,
                            children: [
                              // Part Name
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Nom de la pièce',
                                    style: TextStyle(
                                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    part.designation,
                                    style: TextStyle(
                                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),

                              // Designation
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Designation',
                                    style: TextStyle(
                                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    part.reference ?? 'N/A',
                                    style: TextStyle(
                                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),

                              // Manufacturer
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Fabricant',
                                    style: TextStyle(
                                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(  
                                    part.fabriquant,
                                    style: TextStyle(
                                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),

                              // Total Stock
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppStrings.totalStock,
                                    style: TextStyle(
                                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    '${part.quantity} ${AppStrings.units}',
                                    style: TextStyle(
                                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Location Breakdown
                    Text(
                      AppStrings.locationBreakdown,
                      style: TextStyle(
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Location Grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        childAspectRatio: 1.5,
                      ),
                      itemCount: controller.partLocations.length,
                      itemBuilder: (context, index) {
                        final location = controller.partLocations[index];
                        final locationName = location.keys.first;
                        final quantity = location.values.first;

                        return Obx(() => GestureDetector(
                          onTap: () => controller.selectLocation(locationName),
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: controller.selectedLocation.value == locationName
                                  ? AppColors.primary.withOpacity(0.1)
                                  : (isDark ? AppColors.cardBackgroundDark : AppColors.cardBackgroundLight),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: controller.selectedLocation.value == locationName
                                    ? AppColors.primary
                                    : (isDark ? AppColors.borderDark : AppColors.borderLight),
                                width: controller.selectedLocation.value == locationName ? 1.5 : 0.8,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  locationName,
                                  style: TextStyle(
                                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Qty: $quantity',
                                  style: TextStyle(
                                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                    fontSize: 11,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Icon(
                                  controller.selectedLocation.value == locationName
                                      ? Icons.check_circle
                                      : Icons.radio_button_unchecked,
                                  size: 16,
                                  color: controller.selectedLocation.value == locationName
                                      ? AppColors.primary
                                      : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                                ),
                              ],
                            ),
                          ),
                        ));
                      },
                    ),
                    const SizedBox(height: 24),

                    // Quantity Field
                    QuantitySelector(
                      label: AppStrings.quantity,
                      quantity: controller.quantity.value,
                      onIncrement: controller.incrementQuantity,
                      onDecrement: controller.decrementQuantity,
                    ),
                    const SizedBox(height: 32),

                    // Action Toggle (Add / Remove)
                    ActionToggle(
                      isAddStock: controller.isAddStock.value,
                      onToggle: controller.toggleAction,
                    ),
                    const SizedBox(height: 24),

                    // Optional Note
                    CustomTextArea(
                      label: AppStrings.optionalNote,
                      hint: AppStrings.noteHint,
                      controller: controller.noteController,
                    ),
                    const SizedBox(height: 80), // Space for bottom buttons
                  ],
                );
              }),
            ),
          ),

          // Footer Buttons
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
            child: Column(
              children: [
                // Confirm Change Button
                ElevatedButton(
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
                        AppStrings.confirmChange,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Return to Management Button
                OutlinedButton(
                  onPressed: () => Get.back(),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.primary),
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    AppStrings.returnToManagement,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
