import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/models/part_model.dart';
import '../../controllers/part_details_controller.dart';
import '../widgets/hero_image_header.dart';
import '../widgets/headline_content.dart';
import '../widgets/inventory_stats_widget.dart';
import '../widgets/location_breakdown_widget.dart';
import '../widgets/part_actions_widget.dart';

class PartDetailsScreen extends GetView<PartDetailsController> {
  const PartDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
        title: Text(
          AppStrings.partDetails,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: controller.sharePart,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image
            HeroImageHeader(imageUrl: controller.part.imageUrl),

            // Headline Content
            HeadlineContent(
              name: controller.part.name,
              referenceNumber: controller.part.referenceNumber ?? 'REF-${controller.part.name.replaceAll(' ', '-').toUpperCase()}',
              brand: controller.part.brand,
            ),

            // Inventory Stats
            InventoryStatsWidget(
              quantity: controller.part.quantity.replaceAll('Qty: ', ''),
              isLowStock: controller.part.isLowStock,
            ),

            // Location Breakdown
            if (controller.part.locations != null && controller.part.locations!.isNotEmpty)
              LocationBreakdownWidget(locations: controller.part.locations!),

            // Technical Specs
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Divider(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppStrings.lastUpdated,
                    style: TextStyle(
                      fontSize: 10,
                      fontStyle: FontStyle.italic,
                      color: isDark ? AppColors.textSecondaryDark.withOpacity(0.5) : AppColors.textSecondaryLight.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),

            // Action Buttons
            const PartActionsWidget(),
          ],
        ),
      ),
    );
  }
}
