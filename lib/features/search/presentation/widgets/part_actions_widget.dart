import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/strings.dart';
import 'package:get/get.dart';
import '../../../Parts/presentation/screens/stock_update_screen.dart';
import '../../../../core/controllers/user_controller.dart';
import '../../controllers/part_details_controller.dart';

class PartActionsWidget extends StatelessWidget {
  const PartActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userController = Get.find<UserController>();

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Update Stock Button - Full Width
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () async {
                final partDetailsController = Get.find<PartDetailsController>();
                await Get.toNamed('/stock-update', arguments: partDetailsController.part);
              },
              icon: const Icon(Icons.edit_square),
              label: Text(AppStrings.updateStock),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Admin-only buttons
          if (userController.isAdmin) ...[
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Implement edit part functionality
                        Get.snackbar('Edit', 'Edit part functionality coming soon');
                      },
                      icon: const Icon(Icons.edit),
                      label: Text(AppStrings.editPart),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: isDark ? AppColors.borderDark : AppColors.borderLight,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Implement delete part functionality
                        Get.snackbar('Delete', 'Delete part functionality coming soon');
                      },
                      icon: const Icon(Icons.delete),
                      label: Text(AppStrings.deletePart),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: Colors.red,
                        ),
                        foregroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
