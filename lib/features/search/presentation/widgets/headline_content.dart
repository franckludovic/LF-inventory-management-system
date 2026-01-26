import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';

class HeadlineContent extends StatelessWidget {
  final String designation;
  final String reference;
  final String fabriquant;

  const HeadlineContent({
    super.key,
    required this.designation,
    required this.reference,
    required this.fabriquant,
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
            designation,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            reference,
            style: TextStyle(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            fabriquant,
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
