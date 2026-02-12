import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/colors.dart';
import '../controllers/user_controller.dart';

class ActivityListItem extends StatelessWidget {
  final String date;
  final String partName;
  final String location;
  final String type;
  final String quantity;
  final String by;

  const ActivityListItem({
    super.key,
    required this.date,
    required this.partName,
    required this.location,
    required this.type,
    required this.quantity,
    required this.by,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAdded = type == 'ADDED';
    final userController = Get.find<UserController>();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.borderCardDark : AppColors.borderCardLight,
          ),
        ),
      ),
      child: Row(
        children: [
          // Date
          SizedBox(
            width: 50,
            child: Text(
              date,
              style: TextStyle(
                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Part Info
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  partName,
                  style: TextStyle(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  location,
                  style: TextStyle(
                    color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Type Badge
          Container(
            width: 50,
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isAdded
                    ? Colors.green.withOpacity(isDark ? 0.2 : 0.1)
                    : Colors.red.withOpacity(isDark ? 0.2 : 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isAdded ? 'ADDED' : 'REM',
                style: TextStyle(
                  color: isAdded ? Colors.green[700] : Colors.red[700],
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Quantity
          SizedBox(
            width: 40,
            child: Text(
              quantity,
              style: TextStyle(
                color: isAdded ? Colors.green[700] : Colors.red[700],
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: 8),

          // By - Only show for admins
          if (userController.isAdmin)
            SizedBox(
              width: 40,
              child: Text(
                by,
                style: TextStyle(
                  color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                  fontSize: 12,
                  overflow: TextOverflow.ellipsis,
                ),
                textAlign: TextAlign.right,
              ),
            ),
        ],
      ),
    );
  }
}
