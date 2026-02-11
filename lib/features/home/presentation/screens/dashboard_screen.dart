import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lf_project/core/widgets/custom_app_bar.dart';
import 'package:lf_project/core/widgets/stock_alert_card.dart';
import 'package:lf_project/core/constants/colors.dart';
import '../../controllers/dashboard_controller.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/controllers/user_controller.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.appTitle2,
        onProfileTap: controller.onProfileTap,
        showBackButton: false,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.loadLowStockAlerts();
          await controller.loadAdminStatistics();
        },
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Statistics Cards (Admin & Technician)
                    Obx(() {
                      final userController = Get.find<UserController>();
                      
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Statistiques',
                            style: TextStyle(
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1.5,
                            children: [
                              _buildStatCard(
                                'Total Pièces',
                                controller.totalParts.value.toString(),
                                Icons.inventory_2,
                                AppColors.primary,
                                isDark,
                              ),
                              _buildStatCard(
                                'Stock Faible',
                                controller.lowStockParts.length.toString(),
                                Icons.warning,
                                AppColors.warning,
                                isDark,
                              ),
                              _buildStatCard(
                                'Emplacements',
                                controller.totalLocations.value.toString(),
                                Icons.location_on,
                                AppColors.success,
                                isDark,
                              ),
                              if (userController.isAdmin)
                                _buildStatCard(
                                  'Utilisateurs',
                                  controller.totalUsers.value.toString(),
                                  Icons.people,
                                  AppColors.primary,
                                  isDark,
                                ),
                            ],
                          ),
                          const SizedBox(height: 24),
                        ],
                      );
                    }),


                    // Low Stock Alert Section

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Alerte Stock Faible',

                              style: TextStyle(
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimaryLight,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: controller.navigateToLowStockAlerts,
                          child: Text(
                            'Voir Tout',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Stock Alert Cards - Dynamic from backend
                    Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (controller.lowStockParts.isEmpty) {
                        return const Text('Pas D\'alertes de stock faible pour le moment.');
                      }

                      return Column(
                        children: controller.lowStockParts.take(5).map((part) {

                          final qty = int.tryParse(part.quantity.toString()) ?? 0;
                          final isCritical = qty <= 2;

                          return Column(
                            children: [
                              StockAlertCard(
                                title: part.designation,
                                imageUrl: part.imageUrl,
                                subtitle: 'Rien que $qty unites restantes en stock',
                                status: isCritical ? 'STOCK CRITIC' : 'FAIBLE STOCK',
                                statusColor: isCritical ? AppColors.error : AppColors.warning,
                                statusIcon: isCritical ? Icons.warning : Icons.inventory_2,
                                onRestockPressed: () => (),
                              ),
                              const SizedBox(height: 16),
                            ],
                          );
                        }).toList(),
                      );
                    }),

                    const SizedBox(height: 24),

                    // Recent Activity Section (Admin & Technician)
                    Obx(() {
                      final userController = Get.find<UserController>();
                      if (controller.recentLogs.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userController.isAdmin ? 'Activité Récente' : 'Mon Activité',
                            style: TextStyle(
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 16),
                          ...controller.recentLogs.map((log) {
                            final type = log['type'] ?? 'INCONNU';
                            final quantity = log['quantite'] ?? 0;
                            final date = log['created_at'] != null 
                                ? DateTime.parse(log['created_at']).toLocal().toString().substring(0, 16)
                                : 'Date inconnue';
                            final partName = log['composant']?['designation'] ?? 'Pièce inconnue';
                            
                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackgroundLight,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                                ),
                              ),
                              child: Row(
                                children: [
                                Icon(
                                  (type == 'ADD') ? Icons.add_circle : Icons.remove_circle,
                                  color: (type == 'ADD') ? AppColors.success : AppColors.error,
                                ),

                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          partName,
                                          style: TextStyle(
                                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          '$type - $quantity unités • $date',
                                          style: TextStyle(
                                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),

                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackgroundLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 8),
              Text(
                value,
                style: TextStyle(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
