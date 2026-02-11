import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lf_project/core/widgets/custom_app_bar.dart';
import 'package:lf_project/core/widgets/stock_alert_card.dart';
import 'package:lf_project/core/constants/colors.dart';
import '../../controllers/dashboard_controller.dart';
import '../../../../core/constants/strings.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.appTitle2,
        onProfileTap: controller.onProfileTap,
        showBackButton: false,
      ),
      body: RefreshIndicator(
        onRefresh: controller.loadLowStockAlerts,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Low Stock Alert Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Low Stock Alert',
                              style: TextStyle(
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimaryLight,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.error,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                'URGENT',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ],
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
                        children: controller.lowStockParts.take(2).map((part) {
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
