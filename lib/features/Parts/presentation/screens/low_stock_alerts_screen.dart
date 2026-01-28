import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/part_card_widget.dart';
import '../widgets/stock_filter_chips.dart';
import '../widgets/low_stock_alert_item.dart';
import '../../controllers/low_stock_alerts_controller.dart';

class LowStockAlertsScreen extends GetView<LowStockAlertsController> {
  const LowStockAlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: CustomAppBar(
        title: AppStrings.lowStockAlerts,
        showBackButton: true,
      ),
      body: Column(
        children: [
          // Filter Chips
          StockFilterChips(onFilterSelected: controller.onFilterSelected),

          // Main Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Critical Priority Section
                  Obx(() {
                    final filteredCritical = controller.getFilteredCriticalParts();
                    if (filteredCritical.isEmpty) return const SizedBox.shrink();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Critical Priority (${filteredCritical.length})',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            letterSpacing: 1.2,
                          ),
                        ), const SizedBox(height: 8),
                        ...filteredCritical.map((part) => PartCardWidget(
                          part: part,
                          onTap: () => Get.toNamed('/part-details', arguments: part),
                          onEditPressed: () {},
                          onDeletePressed: () {},
                        )),
                      ],
                    );
                  }),

                  // Low Priority Section
                  Obx(() {
                    final filteredLow = controller.getFilteredLowParts();
                    if (filteredLow.isEmpty) return const SizedBox.shrink();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        Text(
                          'Low Priority (${filteredLow.length})',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...filteredLow.map((part) => PartCardWidget(
                          part: part,
                          onTap: () => Get.toNamed('/part-details', arguments: part),
                          onEditPressed: () {},
                          onDeletePressed: () {},
                        )),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),

          // Bottom Action Button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  (isDark ? AppColors.backgroundDark : AppColors.backgroundLight).withOpacity(0),
                  isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
                ],
              ),
            ),
            child: ElevatedButton.icon(
              onPressed: controller.onRestockAllPressed,
              icon: const Icon(Icons.shopping_cart_checkout, size: 24),
              label: const Text(
                'Restock All Critical Items',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? AppColors.primary : AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
