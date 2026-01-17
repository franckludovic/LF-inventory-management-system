import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/strings.dart';
import '../../data/models/part_model.dart';
import '../widgets/hero_image_header.dart';
import '../widgets/headline_content.dart';
import '../widgets/inventory_stats_widget.dart';
import '../widgets/location_breakdown_widget.dart';
import '../widgets/part_actions_widget.dart';

class PartDetailsScreen extends StatelessWidget {
  final PartModel part;

  const PartDetailsScreen({
    super.key,
    required this.part,
  });

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
          onPressed: () => Navigator.of(context).pop(),
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
            onPressed: () {
              // TODO: Implement share functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image
            HeroImageHeader(imageUrl: part.imageUrl),

            // Headline Content
            HeadlineContent(
              name: part.name,
              referenceNumber: part.referenceNumber ?? 'REF-${part.name.replaceAll(' ', '-').toUpperCase()}',
              brand: part.brand,
            ),

            // Inventory Stats
            InventoryStatsWidget(
              quantity: part.quantity.replaceAll('Qty: ', ''),
              isLowStock: part.isLowStock,
            ),

            // Location Breakdown
            if (part.locations != null && part.locations!.isNotEmpty)
              LocationBreakdownWidget(locations: part.locations!),

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
