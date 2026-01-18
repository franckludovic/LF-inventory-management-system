import 'package:flutter/material.dart';
import '../constants/colors.dart';

class ActionToggle extends StatelessWidget {
  final bool isAddStock;
  final ValueChanged<bool> onToggle;

  const ActionToggle({
    super.key,
    required this.isAddStock,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        // Add Stock Button
        Expanded(
          child: GestureDetector(
            onTap: () => onToggle(true),
            child: Container(
              height: 96,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isAddStock
                    ? AppColors.primary.withOpacity(0.2)
                    : isDark
                        ? AppColors.cardBackgroundDark
                        : AppColors.cardBackgroundLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isAddStock ? AppColors.primary : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_circle,
                    color: isAddStock ? AppColors.primary : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add Stock',
                    style: TextStyle(
                      color: isAddStock ? AppColors.primary : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Remove Stock Button
        Expanded(
          child: GestureDetector(
            onTap: () => onToggle(false),
            child: Container(
              height: 96,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: !isAddStock
                    ? const Color(0xFF233648)
                    : isDark
                        ? AppColors.cardBackgroundDark
                        : AppColors.cardBackgroundLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: !isAddStock ? Colors.transparent : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.remove_circle,
                    color: !isAddStock ? const Color(0xFF92ADC9) : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Remove Stock',
                    style: TextStyle(
                      color: !isAddStock ? const Color(0xFF92ADC9) : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
