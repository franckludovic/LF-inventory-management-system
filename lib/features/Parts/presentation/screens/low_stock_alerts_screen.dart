import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/stock_alert_card.dart';
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
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: controller.onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Rechercher une pièce...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackgroundLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.primary),
                ),
              ),
            ),
          ),

          // Filter and Sort Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Quantity Filter Dropdown
                Expanded(
                  child: Obx(() => DropdownButtonFormField<String>(
                    value: controller.selectedQuantityFilter.value,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: 'Quantité',
                      filled: true,
                      fillColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackgroundLight,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDark ? AppColors.borderDark : AppColors.borderLight,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: controller.quantityFilters.map((filter) {
                      return DropdownMenuItem(
                        value: filter,
                        child: Text(filter, style: const TextStyle(fontSize: 11)),
                      );
                    }).toList(),
                    onChanged: controller.onQuantityFilterChanged,
                  )),
                ),
                const SizedBox(width: 12),
                // Sort Dropdown
                Expanded(
                  child: Obx(() => DropdownButtonFormField<String>(
                    value: controller.selectedSort.value,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: 'Trier par',
                      filled: true,
                      fillColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackgroundLight,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDark ? AppColors.borderDark : AppColors.borderLight,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: controller.sortOptions.map((sort) {
                      return DropdownMenuItem(
                        value: sort,
                        child: Text(sort, style: const TextStyle(fontSize: 11)),
                      );
                    }).toList(),
                    onChanged: controller.onSortChanged,
                  )),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Results Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${controller.filteredAndSortedParts.length} pièces trouvées',
                  style: TextStyle(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    fontSize: 14,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    controller.onSearchChanged('');
                    controller.onQuantityFilterChanged('Tous (5 ou moins)');
                    controller.onSortChanged('Nom A-Z');
                  },
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Réinitialiser'),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 30),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            )),
          ),

          const SizedBox(height: 8),

          // Stock Alert Cards List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final parts = controller.filteredAndSortedParts;

              if (parts.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 64,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Aucune pièce trouvée',
                        style: TextStyle(
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: parts.length,
                itemBuilder: (context, index) {
                  final part = parts[index];
                  final qty = int.tryParse(part.quantity) ?? 0;
                  // Critical: 2 or less, Low: 5 or less
                  final isCritical = qty <= 2;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: StockAlertCard(
                      title: part.designation,
                      imageUrl: part.imageUrl,
                      subtitle: 'Rien que $qty unités restantes en stock',
                      status: isCritical ? 'STOCK CRITIQUE' : 'STOCK FAIBLE',
                      statusColor: isCritical ? AppColors.error : AppColors.warning,
                      statusIcon: isCritical ? Icons.warning : Icons.inventory_2,
                      onRestockPressed: () => controller.navigateToPartDetails(part),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
