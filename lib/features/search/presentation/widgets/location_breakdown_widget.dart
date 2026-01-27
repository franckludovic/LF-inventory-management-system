import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/strings.dart';

class LocationBreakdownWidget extends StatelessWidget {
  final List<Map<String, String>> locations;

  const LocationBreakdownWidget({
    super.key,
    required this.locations,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.locationBreakdown,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          ...locations.map((location) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _buildLocationItem(
              location.keys.first,
              location.values.first,
              false, // Assuming no primary location for now
              isDark,
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildLocationItem(String location, String quantity, bool isPrimary, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackgroundLight,
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                location == AppStrings.vanStock ? Icons.local_shipping : Icons.inventory_2,
                color: AppColors.primary,
              ),
              const SizedBox(width: 12),
              Text(
                location,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
            ],
          ),
          Text(
            quantity,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isPrimary ? AppColors.primary : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
            ),
          ),
        ],
      ),
    );
  }
}
